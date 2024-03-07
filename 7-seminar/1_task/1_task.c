/* check-pwd.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int check_password(FILE *f, const char *password) {
    size_t max_psw_len = 10;
    char buffer[max_psw_len + 1];
    char format[64];
    int okay = 0;
    snprintf(format, 64, "%%%zus", max_psw_len);
    fscanf(f, format, buffer);
    if (strcmp(buffer, password) == 0)
        okay = 1;

    return okay;
}

int main(int argc, char **argv) {
    if (check_password(stdin, "password"))
        puts("Access granted.");
    else
        puts("Wrong password.");
}