#ifndef EVENT_LIST_H
#define EVENT_LIST_H
#include <uiohook.h>

typedef struct node {
    uiohook_event *value;
    struct node *next;
} node;

typedef struct {
    node *head;
    node *tail;
} linked_list;

void add_event_to_list(linked_list *list, uiohook_event *event);

uiohook_event *pop_next_event(linked_list *list);

#endif