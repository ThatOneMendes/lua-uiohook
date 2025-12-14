#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct vector {
    void* data;
    size_t num_elements;
    size_t capacity;
    size_t element_size;
} vector;

vector *new_vector(size_t initial_capacity, size_t element_size) {
    if(!initial_capacity) {
        initial_capacity = 1;
    }

    if(!element_size) {
        fprintf(stderr, "Error when creating vector: element size not specified.\n");
        return NULL;
    }

    vector *vec = calloc(1, sizeof(vector));
    vec->capacity = initial_capacity;
    vec->element_size = element_size;
    vec->num_elements = 0;
    vec->data = calloc(vec->capacity, vec->element_size);
    if(vec->data == NULL) {
        free(vec);
        fprintf(stderr, "Error when creating vector: calloc error.\n");
        return NULL;
    }
    return vec;
}

void vector_add_element(vector *vec, const void *element) {
    if(vec->num_elements >= vec->capacity) {
        void *new_data_ptr = realloc(vec->data, (vec->capacity + 1) * vec->element_size);
        if(new_data_ptr == NULL) {
            fprintf(stderr, "Error when adding element to vector: realloc error\n");
            return;
        }
        vec->capacity++;
        vec->data = new_data_ptr;
    }

    memcpy(vec->data + (vec->num_elements * vec->element_size), element, vec->element_size);
    vec->num_elements++;
}

void vector_change_element(vector *vec, size_t index, const void *new_element) {
    if(vec->num_elements <= 0) {
        fprintf(stderr, "Error when changing element of vector: vector is empty.\n");
        return;
    }

    if(index > (vec->num_elements - 1)) {
        fprintf(stderr, "Error when changing element of vector: index is out of bounds.\n");
        return;
    }

    memcpy(vec->data + (index * vec->element_size), new_element, vec->element_size);
}

void vector_pop_element(vector *vec) {
    if(vec->num_elements <= 0) {
        return;
    }

    void *new_data_ptr = NULL;

    if((vec->num_elements - 1) == 0) {
        new_data_ptr = calloc(1, vec->element_size);
        if(new_data_ptr == NULL) {
            fprintf(stderr, "Error during vector pop (vector with single element): calloc error\n");
            return;
        }
        vec->num_elements = 0;
        vec->capacity = 1;
        free(vec->data);
        vec->data = new_data_ptr;
        return;
    }

    new_data_ptr = realloc(vec->data, (vec->num_elements - 1) * vec->element_size);
    if(new_data_ptr == NULL) {
        fprintf(stderr, "Error during vector pop (vector with two or more elements): realloc error\n");
        return;
    }

    vec->num_elements--;
    vec->data = new_data_ptr;
    vec->capacity--;
    return;
}

void vector_remove_element(vector *vec, size_t index) {
    if(vec->num_elements <= 0) {
        fprintf(stderr, "Error when removing element of vector: vector is empty.\n");
        return;
    }

    if(index > (vec->num_elements - 1)) {
        fprintf(stderr, "Error when removing element of vector: index is out of bounds.\n");
        return;
    }

    void *new_data_ptr = NULL;
    
    if(vec->num_elements == 1) {
        new_data_ptr = calloc(1, vec->element_size);
    } else {
        memcpy(vec->data + (index * vec->element_size), vec->data + ((index + 1) * vec->element_size), vec->element_size * (vec->num_elements - index));
        new_data_ptr = realloc(vec->data, (vec->num_elements - 1) * vec->element_size);
    }
    
    if(new_data_ptr == NULL) {
        fprintf(stderr, "Error when removing element of vector: realloc error\n");
        return;
    }

    if(vec->num_elements == 1) {
        free(vec->data);
    }

    vec->num_elements--;
    if(vec->num_elements <= 0) {
        vec->capacity = 1; // NEVER reach capacity 0...
    } else {
        vec->capacity--;
    }
    vec->data = new_data_ptr;
}

void *vector_get_element(vector *vec, size_t index) {
    if(vec->num_elements <= 0) {
        fprintf(stderr, "Error when accessing element of vector: vector is empty.\n");
        return NULL;
    }

    if(index > (vec->num_elements - 1)) {
        fprintf(stderr, "Error when accessing element of vector: index is out of bounds.\n");
        return NULL;
    }

    return vec->data + (index * vec->element_size);
}

size_t vector_index_of(vector *vec, const void *element) {
    unsigned char data = *(unsigned char*)vec->data;
    unsigned char element_cmp = *(unsigned char*)element;

    for (size_t i = 0; i < vec->num_elements; i++) {
        for (size_t j = i * vec->element_size; j < (i + 1) * vec->element_size; j++) {
            int equal = memcmp(&data + j, &element_cmp, vec->element_size);
            if(equal) return i;
        }
    }
    return -1;
}

#ifdef NDEBUG
int main() {
    vector *vec = new_vector(1, sizeof(int));

    int action;
    int element_to_add;
    size_t index_to_poke;

    for(;;) {
        printf("Action (0 - add element, 1 - remove element, 2 - change element, 3 - find index of element): ");
        scanf("%d", &action);
        switch(action) {
            case 0:
            printf("Number to add: ");
            scanf("%d", &element_to_add);
            vector_add_element(vec, &element_to_add);
            break;
            case 2:
            printf("Index to mess with: ");
            scanf("%zd", &index_to_poke);
            printf("New element: ");
            scanf("%d", &element_to_add);
            vector_change_element(vec, index_to_poke, &element_to_add);
            break;
            case 1:
            printf("Index to mess with: ");
            scanf("%zd", &index_to_poke);
            vector_remove_element(vec, index_to_poke);
            break;
            case 3:
            printf("Element to find: ");
            scanf("%d", &element_to_add);
            size_t index_found = vector_index_of(vec, &element_to_add);
            printf("Index is %zd\n", index_found);
            break;
            default:
            printf("enter something little bro.\n");
        }
    };
    return 0;
}
#endif