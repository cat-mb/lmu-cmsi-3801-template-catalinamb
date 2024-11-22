#include "string_stack.h"
#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

struct _Stack {
    char** elements;      
    int size;            
    int capacity;         
};

stack_response create() {
    stack_response response;

    stack s = (stack)malloc(sizeof(struct _Stack)); 
    if (!s) {
        response.code = out_of_memory;
        response.stack = NULL;
        return response;
    }
    
    s->capacity = 16; 
    s->size = 0;
    s->elements = (char**)malloc(s->capacity * sizeof(char*)); 
    if (!s->elements) {
        free(s);
        response.code = out_of_memory;
        response.stack = NULL;
        return response;
    }

    response.code = success;
    response.stack = s;
    return response;
}

int size(const stack s) {
    return s->size;
}

bool is_empty(const stack s) {
    return s->size == 0;
}

bool is_full(const stack s) {
    return s->size == MAX_CAPACITY;
}

response_code push(stack s, char* item) {
    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (is_full(s)) {
        return stack_full;
    }

    if (s->size == s->capacity) {
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) new_capacity = MAX_CAPACITY;
        char** new_elements = (char**)realloc(s->elements, new_capacity * sizeof(char*));
        if (!new_elements) {
            return out_of_memory;
        }
        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    s->elements[s->size] = strdup(item); 
    if (!s->elements[s->size]) {
        return out_of_memory;
    }
    s->size++;
    return success;
}

string_response pop(stack s) {
    string_response response;
    if (is_empty(s)) {
        response.code = stack_empty;
        response.string = NULL;
        return response;
    }

    response.string = s->elements[s->size - 1];
    response.code = success;

    s->elements[s->size - 1] = NULL;
    s->size--;

    return response;
}

void destroy(stack* s) {
    if (!s || !*s) return;

    for (int i = 0; i < (*s)->size; i++) {
        free((*s)->elements[i]);
    }
    free((*s)->elements);
    free(*s);
    *s = NULL;
}


