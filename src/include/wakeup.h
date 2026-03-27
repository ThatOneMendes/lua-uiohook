#ifndef WAKEUP_H
#define WAKEUP_H

#ifdef _WIN32
    #include <windows.h>
#endif

typedef struct wakeup {
#ifdef _WIN32
    HANDLE event;
#else
    int read_fd;
    int write_fd;
#endif
} wakeup_t;

int wakeup_init(wakeup_t *w);

void wakeup_wait(wakeup_t *w);

void wakeup_signal(wakeup_t *w);

void wakeup_destroy(wakeup_t *w);

#endif