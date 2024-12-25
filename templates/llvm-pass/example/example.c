#include <stdio.h>

int main (int argc) {
    int d = argc;
    printf("arguments: %i\n", d);
    d = d + d;
    printf("arguments: %i\n", d);
    d = d + d;
    printf("arguments: %i\n", d);
    printf("Hello World\n");
    return 0;
}
