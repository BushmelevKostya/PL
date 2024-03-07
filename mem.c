#define _DEFAULT_SOURCE

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#include "mem_internals.h"
#include "mem.h"
#include "util.h"

void debug_block(struct block_header *b, const char *fmt, ...);

void debug(const char *fmt, ...);

extern inline block_size size_from_capacity(block_capacity cap);

extern inline block_capacity capacity_from_size(block_size sz);

static bool block_is_big_enough(size_t query, struct block_header *block) { return block->capacity.bytes >= query; }

static size_t pages_count(size_t mem) { return mem / getpagesize() + ((mem % getpagesize()) > 0); }

static size_t round_pages(size_t mem) { return getpagesize() * pages_count(mem); }

static void block_init(void* restrict addr, block_size block_sz, void *restrict next) {
    *((struct block_header *) addr) = (struct block_header) {
            .next = next,
            .capacity = capacity_from_size(block_sz),
            .is_free = true
    };
}

static size_t region_actual_size(size_t query) { return size_max(round_pages(query), REGION_MIN_SIZE); }

extern inline bool region_is_invalid(const struct region *r);

static void* map_pages(void const *addr, size_t length, int additional_flags) {
    return mmap((void *) addr, length, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | additional_flags, -1, 0);
}

/*  аллоцировать регион памяти и инициализировать его блоком */
static struct region alloc_region(void const* addr, size_t query) {
    //add size of header
    query += offsetof(struct block_header, contents);
    size_t actual_size = region_actual_size(query);
    void *region_ptr = map_pages(addr, actual_size, MAP_FIXED);
    bool extends = !(region_ptr == MAP_FAILED);

    if (region_ptr == MAP_FAILED) {
        region_ptr = map_pages(addr, actual_size, 0);
        if (region_ptr == MAP_FAILED) {
            return REGION_INVALID;
        }
    }
    struct region region = {.addr = region_ptr, .size = actual_size, .extends = extends};
    block_init(region.addr, (block_size) {actual_size}, NULL);
    return region;
}

static void* block_after(struct block_header const *block);

void* heap_init(size_t initial) {
    const struct region region = alloc_region(HEAP_START, initial);
    if (region_is_invalid(&region)) return NULL;

    return region.addr;
}

static bool blocks_continuous(
        struct block_header const *fst,
        struct block_header const *snd);

/*  освободить всю память, выделенную под кучу */
void heap_term() {
    struct block_header* cur_block = (struct block_header*) HEAP_START;
    void* start_ptr;
    while (cur_block != NULL) {
        size_t cur_region_size = 0;
        start_ptr = cur_block;
        while (blocks_continuous(cur_block, cur_block->next)) {
            cur_region_size += size_from_capacity(cur_block->capacity).bytes;
            cur_block = cur_block->next;
        }
        cur_region_size += size_from_capacity(cur_block->capacity).bytes;
        cur_block = cur_block->next;
        munmap(start_ptr, cur_region_size);
    }
}

#define BLOCK_MIN_CAPACITY 24
#define header_size offsetof(struct block_header, contents)

/*  --- Разделение блоков (если найденный свободный блок слишком большой )--- */

static bool block_splittable(struct block_header* restrict block, size_t query) {
    return block->is_free &&
           query + header_size + BLOCK_MIN_CAPACITY <= block->capacity.bytes;
}

static bool split_if_too_big(struct block_header* block, size_t query) {
    if (block_splittable(block, query)) {
        query = size_max(query, BLOCK_MIN_CAPACITY);

        block_size first_block_size = size_from_capacity((block_capacity){ query });
        block_size second_block_size = { block->capacity.bytes - query };

        void* first_next = block->contents + query;
        struct block_header* second_next = block->next;

        block_init(block, first_block_size, first_next);
        block_init(first_next, second_block_size, second_next);
        return 1;
    }
    return 0;
}


/*  --- Слияние соседних свободных блоков --- */

static void *block_after(struct block_header const *block) {
    return (void *) (block->contents + block->capacity.bytes);
}

static bool blocks_continuous(
        struct block_header const *fst,
        struct block_header const *snd) {
    return (void *) snd == block_after(fst);
}

static bool mergeable(struct block_header const *restrict fst, struct block_header const *restrict snd) {
    return fst->is_free && snd->is_free && blocks_continuous(fst, snd);
}

static bool try_merge_with_next(struct block_header* block) {
    if (block != NULL && block->next != NULL && mergeable(block, block->next)) {
        struct block_header* new_next = block->next->next;
        block_size snd_size =  size_from_capacity(block->next->capacity);
        block_capacity new_capacity = { block->capacity.bytes + snd_size.bytes};
        block_size new_size = size_from_capacity(new_capacity);
        block_init(block, new_size, new_next);
        return 1;
    }
    return 0;
}


/*  --- ... ecли размера кучи хватает --- */

struct block_search_result {
    enum {
        BSR_FOUND_GOOD_BLOCK, BSR_REACHED_END_NOT_FOUND, BSR_CORRUPTED
    } type;
    struct block_header *block;
};

static bool is_good(struct block_header* block, size_t sz) {
    return (block->is_free && block->capacity.bytes >= sz);
}

static void try_merge_all_blocks(struct block_header* block) {
    struct block_header* cur_block = block;
    if (block == NULL) return;
    while (cur_block->next != NULL) {
        if (try_merge_with_next(cur_block)) {
            continue;
        }
        cur_block = cur_block->next;
    }
}

static struct block_search_result find_good_or_last(struct block_header* restrict block, size_t sz) {
    if (block == NULL) {
        return (struct block_search_result) { BSR_CORRUPTED };
    }
    struct block_header* prev_block = NULL;
    try_merge_all_blocks(block);
    struct block_header* cur_block = block;
    while (cur_block != NULL) {
        if (is_good(cur_block, sz)) {
            return (struct block_search_result) { BSR_FOUND_GOOD_BLOCK, cur_block };
        }
        prev_block = cur_block;
        cur_block = cur_block->next;
    }
    return (struct block_search_result) { BSR_REACHED_END_NOT_FOUND, prev_block };
}

/*  Попробовать выделить память в куче начиная с блока `block` не пытаясь расширить кучу
 Можно переиспользовать как только кучу расширили. */
static struct block_search_result try_memalloc_existing(size_t query, struct block_header* block) {
    struct block_search_result res = find_good_or_last(block, query);
    if (res.type == BSR_FOUND_GOOD_BLOCK) {
        split_if_too_big(res.block, query);
        res.block->is_free = false;
    }
    return res;
}


static struct block_header* grow_heap(struct block_header *restrict last, size_t query) {
    void* last_end = block_after(last);
    struct region new_region = alloc_region(last_end, query);
    struct block_header* addr_region = new_region.addr;
    if (addr_region == NULL) {
        return NULL;
    }
    last->next = addr_region;
    if (addr_region != last_end) {
        return addr_region;
    }
    if (try_merge_with_next(last)) {
        return last;
    }
    return addr_region;
}

/*  Реализует основную логику malloc и возвращает заголовок выделенного блока */
static struct block_header* memalloc(size_t query, struct block_header* heap_start) {
    if (heap_start == NULL) {
        struct region region = alloc_region(heap_start, query);
        if (region_is_invalid(&region)) {
            return NULL;
        }
        heap_start = region.addr;
    }
    struct block_search_result res = try_memalloc_existing(query, heap_start);
    switch (res.type) {
        case BSR_FOUND_GOOD_BLOCK:
            return res.block;
        case BSR_REACHED_END_NOT_FOUND: {
            struct block_header* new_block = grow_heap(res.block, query);
            if (new_block != NULL) {
                res = try_memalloc_existing(query, new_block);
                return res.block;
            }
            return NULL;
        }
        default: return NULL;
    }
}

void* _malloc(size_t query) {
    struct block_header *const addr = memalloc(query, (struct block_header *) HEAP_START);
    if (addr) return addr->contents;
    else return NULL;
}

static struct block_header* block_get_header(void *contents) {
    return (struct block_header*) (((uint8_t *) contents) - offsetof(struct block_header, contents));
}

void _free(void* mem) {
    if (!mem) return;
    struct block_header *header = block_get_header(mem);
    header->is_free = true;
    try_merge_all_blocks(header);
}
