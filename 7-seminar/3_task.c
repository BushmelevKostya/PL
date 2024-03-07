/* stack-smash.c */

#include <stdio.h>
#include <stdlib.h>

struct user {
    const char *name, *password;
} const users[] = {{"Cat", "Meowmeow"}, {"Skeletor", "Nyarr"}};

void print_users() {
    printf("Users:\n");
    for (size_t i = 0; i < sizeof(users) / sizeof(struct user); i++) {
        printf("%s: %s\n", users[i].name, users[i].password);
    }
}

void fill(FILE *f, char *where, size_t buf_size) {
	fread(where, 1, buf_size, f);
}

void vulnerable(FILE *f) {
    size_t buf_size = 8;
    char buffer[buf_size];
    fill(f, buffer, buf_size);
}

int main(int argc, char **argv) {
    vulnerable(stdin);
    printf("%s", "nothing happened\n");
}
