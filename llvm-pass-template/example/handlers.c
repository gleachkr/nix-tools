#include <stdio.h>

void store_handler(int* ptr, int val) { 
    printf("value: %i;\n", val);
    printf("store address: %p;\n", ptr);
    printf("address deref: %i;\n", *ptr);
}

void load_handler(int* ptr, int val) { 
    printf("value: %i;\n", val);
    printf("load address: %p;\n", ptr);
    printf("address deref: %i;\n", *ptr);
}
