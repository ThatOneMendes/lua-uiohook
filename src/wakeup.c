#ifdef _WIN32
    #include <windows.h>
    #include <stdio.h>
#else
    #include <unistd.h>
    #include <stdio.h>
    #include <stdint.h>
    #include <sys/select.h>
    #ifdef __linux__
        #include <sys/eventfd.h>
    #endif
    #include <poll.h>
#endif

typedef struct wakeup {
#ifdef _WIN32
    HANDLE event;
#else
    int read_fd;
    int write_fd;
#endif
} wakeup_t;

int wakeup_init(wakeup_t *w) {
#ifdef _WIN32
    w->event = CreateEvent(NULL, FALSE, FALSE, NULL);
    return w->event ? 0 : -1;
#else
#ifdef __linux__
    w->read_fd  = eventfd(0, EFD_CLOEXEC);
    w->write_fd = w->read_fd;
    return w->read_fd >= 0 ? 0 : -1;
#else
    int pipefd[2];
    if (pipe(pipefd) != 0)
        return -1;

    w->read_fd  = pipefd[0];
    w->write_fd = pipefd[1];
    return 0;
#endif
#endif
}

int wakeup_wait(wakeup_t *w, int timeout_ms) {
#ifdef _WIN32
    DWORD ret = WaitForSingleObject(w->event, (DWORD)timeout_ms);
    if (ret == WAIT_OBJECT_0) return 1;
    if (ret == WAIT_TIMEOUT)  return 0;
    return -1;
#else
#ifdef __linux__
    struct pollfd pfd = { .fd = w->read_fd, .events = POLLIN };
    int ret = poll(&pfd, 1, timeout_ms);
    if (ret == 0)  return 0;
    if (ret == -1) return -1;
    uint64_t v;
    read(w->read_fd, &v, sizeof(v));
    return 1;
#else
    struct timeval tv = {
        .tv_sec  = timeout_ms / 1000,
        .tv_usec = (timeout_ms % 1000) * 1000
    };
    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(w->read_fd, &rfds);

    int ret = select(w->read_fd + 1, &rfds, NULL, NULL, &tv);
    if (ret == 0)  return 0;
    if (ret == -1) return -1;
    char buf[64];
    read(w->read_fd, buf, sizeof(buf));
    return 1;
#endif
#endif
}

void wakeup_signal(wakeup_t *w) {
#ifdef _WIN32
    SetEvent(w->event);
#else
#ifdef __linux__
    uint64_t one = 1;
    write(w->write_fd, &one, sizeof(one));
#else
    write(w->write_fd, "x", 1);
#endif
#endif
}

void wakeup_destroy(wakeup_t *w) {
#ifdef _WIN32
    CloseHandle(w->event);
#else
    close(w->read_fd);
#ifndef __linux__
    close(w->write_fd);
#endif
#endif
}
