#include <stdlib.h>
#include <uiohook.h>

typedef struct node {
    uiohook_event *value;
    struct node *next;
} node;

typedef struct {
    node *head;
    node *tail;
} linked_list;

void add_event_to_list(linked_list *list, uiohook_event *event) {
    struct node *new_node = (struct node *)malloc(sizeof(struct node));
    new_node->value = event;
    new_node->next = NULL;
    if(!list->head) {
        list->head = new_node;
    } else {
        list->tail->next = new_node;
    }

    list->tail = new_node;
}

uiohook_event *pop_next_event(linked_list *list) {
    struct node *event_node = list->head;
    if(event_node == NULL) {
        return NULL;
    }
    if(event_node->next == NULL) {
        list->head = NULL;
        list->tail = NULL;
    } else {
        list->head = event_node->next;
    }
    
    uiohook_event *event_data = event_node->value;

    free(event_node);
    return event_data;
}