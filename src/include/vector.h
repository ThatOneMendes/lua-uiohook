#ifndef VECTOR_H
#define VECTOR_H
#include <stdlib.h>

typedef struct vector {
    void* data;
    size_t num_elements;
    size_t capacity;
    size_t element_size;
} vector;

vector *new_vector(size_t initial_capacity, size_t element_size);

void vector_add_element(vector *vec, const void *element);

void vector_change_element(vector *vec, size_t index, const void *new_element);

void vector_pop_element(vector *vec);

void vector_remove_element(vector *vec, size_t index);

void *vector_get_element(vector *vec, size_t index);

size_t vector_index_of(vector *vec, const void *element);

#endif