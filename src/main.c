#include <stdio.h>
#include <uiohook.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdlib.h>
#include <pthread.h>
#ifdef _WIN32
    #ifndef WINVER
        #define WINVER 0x0601
    #endif

    #ifndef _WIN32_WINNT
        #define _WIN32_WINNT 0x0601
    #endif

    #define WIN32_LEAN_AND_MEAN

    #include <windows.h>
    #include <winuser.h>
#elif __APPLE__
    #include <ApplicationServices/ApplicationServices.h>
#elif __linux
    #include <X11/Xlib.h>
#endif

#include <event_list.h>
#include <vector.h>

#ifdef NDEBUG
    void dump_lua_stack(lua_State *L) {
        int top = lua_gettop(L);
        printf("------ Lua stack (top=%d) ------\n", top);

        for (int i = top; i >= 1; i--) {
            int t = lua_type(L, i);

            printf("%2d: ", i);

            switch (t) {
                case LUA_TSTRING:
                    printf("string: '%s'\n", lua_tostring(L, i));
                    break;

                case LUA_TBOOLEAN:
                    printf("boolean: %s\n", lua_toboolean(L, i) ? "true" : "false");
                    break;

                case LUA_TNUMBER:
                    printf("number: %g\n", lua_tonumber(L, i));
                    break;

                case LUA_TTABLE:
                    printf("table: %p\n", lua_topointer(L, i));
                    break;

                case LUA_TFUNCTION:
                    printf("function: %p\n", lua_topointer(L, i));
                    break;

                case LUA_TUSERDATA:
                    printf("userdata: %p\n", lua_touserdata(L, i));
                    break;

                case LUA_TLIGHTUSERDATA:
                    printf("lightuserdata: %p\n", lua_touserdata(L, i));
                    break;

                case LUA_TTHREAD:
                    printf("thread: %p\n", lua_tothread(L, i));
                    break;

                case LUA_TNIL:
                    printf("nil\n");
                    break;

                default:
                    printf("%s\n", lua_typename(L, t));
                    break;
            }
        }

        printf("--------------------------------\n");
    }
#endif

typedef struct {
    int pointer;
    bool listening;
} listener_object;

vector *listening_functions;
vector *listening_functions_clone;

pthread_t listener_thread;
pthread_mutex_t listener_function_lock;
pthread_mutex_t hook_creation_lock;
pthread_cond_t hook_creation_wait;

linked_list *event_tree;

// KEYBOARD START

uiohook_event* hold_keyboard(lua_Integer key_id, lua_Integer mask, uiohook_event *event) {
    if(event == NULL) {
        event = calloc(1, sizeof(uiohook_event));
    }
    event->type = EVENT_KEY_PRESSED;
    event->mask = mask;
    event->data.keyboard.keycode = key_id;
    event->data.keyboard.keychar = CHAR_UNDEFINED;
    hook_post_event(event);
    return event;
}

uiohook_event* release_keyboard(lua_Integer key_id, lua_Integer mask, uiohook_event *event) {
    if(event == NULL) {
        event = calloc(1, sizeof(uiohook_event));
    }
    event->type = EVENT_KEY_RELEASED;
    event->mask = mask;
    event->data.keyboard.keycode = key_id;
    event->data.keyboard.keychar = CHAR_UNDEFINED;
    hook_post_event(event);
    return event;
}

static int keyboard_hold_key(lua_State *L) {
    lua_Integer key_id = luaL_checkinteger(L, 1);
    lua_Integer mask = luaL_checkinteger(L, 2);
    uiohook_event *event = hold_keyboard(key_id, mask, NULL);
    free(event);
    return 0;
}

static int keyboard_release_key(lua_State *L) {
    lua_Integer key_id = luaL_checkinteger(L, 1);
    lua_Integer mask = luaL_checkinteger(L, 2);
    uiohook_event *event = release_keyboard(key_id, mask, NULL);
    free(event);
    return 0;
}

static int keyboard_press_key(lua_State *L) {
    lua_Integer key_id = luaL_checkinteger(L, 1);
    lua_Integer mask = luaL_checkinteger(L, 2);
    uiohook_event *event = hold_keyboard(key_id, mask, NULL);
    event = release_keyboard(key_id, mask, event);
    free(event);
    return 0;
}

// KEYBOARD END & MOUSE START

typedef struct {
    int x;
    int y;
} mouse_coordinates;

mouse_coordinates get_mouse_coords() {
    mouse_coordinates coords = {0, 0};
    #ifdef _WIN32
        POINT point;
        GetCursorPos(&point);
        coords.x = point.x;
        coords.y = point.y;
    #elif __APPLE__
        CGPoint point = CGEventGetLocation(CGEventCreate(NULL));
        coords.x = point.x;
        coords.y = point.y;
    #else
        Display *display;
        Window root_window;
        Window returned_root, returned_child;
        int root_x, root_y;
        int win_x, win_y;
        unsigned int mask;

        display = XOpenDisplay(NULL);
        if(display == NULL) {
            return coords;
        }

        root_window = XDefaultRootWindow(display);

        if(XQueryPointer(
            display, root_window,
            &returned_root, &returned_child,
            &root_x, &root_y, &win_x, &win_y,
            &mask
        )) {
            coords.x = root_x;
            coords.y = root_y;
        } else {
            return coords;
        }
    #endif

    return coords;
}

static int get_mouse_coordinates(lua_State *L) {
    mouse_coordinates coords = get_mouse_coords();
    lua_newtable(L);
    
    lua_pushinteger(L, coords.x);
    lua_seti(L, -2, 1);

    lua_pushinteger(L, coords.y);
    lua_seti(L, -2, 2);
    return 1;
}

uiohook_event* hold_mouse(lua_Integer mouse_button, mouse_coordinates coords, uiohook_event *event) {
    if(event == NULL) {
        event = calloc(1, sizeof(uiohook_event));
    }
    event->type = EVENT_MOUSE_PRESSED;
    event->data.mouse.button = mouse_button;
    event->data.mouse.clicks = 1;
    event->data.mouse.x = coords.x;
    event->data.mouse.y = coords.y;
    hook_post_event(event);
    return event;
}

uiohook_event* release_mouse(lua_Integer mouse_button, mouse_coordinates coords, uiohook_event *event) {
    if(event == NULL) {
        event = calloc(1, sizeof(uiohook_event));
    }
    event->type = EVENT_MOUSE_RELEASED;
    event->data.mouse.button = mouse_button;
    event->data.mouse.x = coords.x;
    event->data.mouse.y = coords.y;
    hook_post_event(event);
    return event;
}

static int hold_mouse_button(lua_State *L) {
    int mouse_button = luaL_checkinteger(L, 1);
    int x = luaL_checkinteger(L, 2);
    int y = luaL_checkinteger(L, 3);

    mouse_coordinates coords = {x, y};

    uiohook_event *event = hold_mouse(mouse_button, coords, NULL);
    free(event);
    return 0;
}

static int release_mouse_button(lua_State *L) {
    int mouse_button = luaL_checkinteger(L, 1);
    int x = luaL_checkinteger(L, 2);
    int y = luaL_checkinteger(L, 3);

    mouse_coordinates coords = {x, y};

    uiohook_event *event = release_mouse(mouse_button, coords, NULL);
    free(event);
    return 0;
}

static int click(lua_State *L) {
    int mouse_button = luaL_checkinteger(L, 1);
    int x = luaL_checkinteger(L, 2);
    int y = luaL_checkinteger(L, 3);

    mouse_coordinates coords = {x, y};

    uiohook_event *event = hold_mouse(mouse_button, coords, NULL);
    release_mouse(mouse_button, coords, event);
    free(event);
    return 0;
}

static int move_mouse(lua_State *L) {
    int x = luaL_checkinteger(L, 1);
    int y = luaL_checkinteger(L, 2);
    
    uiohook_event *event = calloc(1, sizeof(uiohook_event));
    event->type = EVENT_MOUSE_MOVED;
    event->data.mouse.x = x;
    event->data.mouse.y = y;
    event->data.mouse.button = MOUSE_NOBUTTON;
    event->mask = 0x00;
    hook_post_event(event);
    free(event);
    return 0;
}

static int scroll_mouse(lua_State *L) {
    lua_Integer amount = luaL_checkinteger(L, 1);
    lua_Integer direction = luaL_checkinteger(L, 2);
    lua_Integer rotation = luaL_checkinteger(L, 3);

    mouse_coordinates coords = get_mouse_coords();

    uiohook_event *event = calloc(1, sizeof(uiohook_event));

    event->type = EVENT_MOUSE_WHEEL;
    event->data.wheel.x = coords.x;
    event->data.wheel.y = coords.y;
    event->data.wheel.direction = direction;
    event->data.wheel.rotation = rotation;
    event->data.wheel.amount = amount;
    event->data.wheel.type = 1;

    hook_post_event(event);
    free(event);
    return 0;
}

// END MOUSE & START INPUT EVENT LISTENER

void libuiohook_on_event(uiohook_event *const event) {
    pthread_mutex_lock(&listener_function_lock);

    if(event->type == EVENT_HOOK_ENABLED) {
        pthread_cond_signal(&hook_creation_wait);
        pthread_mutex_unlock(&hook_creation_lock);
    }

    if(listening_functions->element_size <= 0) {
        pthread_mutex_unlock(&listener_function_lock);
        return;
    }

    uiohook_event *event_to_push = calloc(1, sizeof(uiohook_event));

    memcpy(event_to_push, event, sizeof(uiohook_event));

    add_event_to_list(event_tree, event_to_push);

    pthread_mutex_unlock(&listener_function_lock);
}

void* run_hook(void *status) {
    int success = hook_run();
    if(success != UIOHOOK_SUCCESS) {
        *(int *) status = success;
    }
    pthread_cond_signal(&hook_creation_wait);
    pthread_mutex_unlock(&hook_creation_lock);

    return status;
}

static int listen_events(lua_State *L) {
    luaL_argcheck(L, lua_isfunction(L, 1), 1, "Expected function");
    
    lua_pushvalue(L, 1);
    int function_pointer = luaL_ref(L, LUA_REGISTRYINDEX);

    listener_object *new_listener = lua_newuserdata(L, sizeof(listener_object));
    new_listener->pointer = function_pointer;
    new_listener->listening = false;

    luaL_setmetatable(L, "ListenerObject");
    return 1;
}

static int connect_listener(lua_State *L) {
    listener_object *listener = luaL_checkudata(L, 1, "ListenerObject");
    if(listener->listening == true) {
        return 0;
    }
    vector_add_element(listening_functions, &listener->pointer);
    listener->listening = true;
    return 0;
}

static int disconnect_listener(lua_State *L) {
    listener_object *listener = luaL_checkudata(L, 1, "ListenerObject");
    if(listener->listening == false) {
        return 0;
    }
    size_t index_of_pointer = vector_index_of(listening_functions, &listener->pointer);
    if(index_of_pointer == -1) {
        int err_code = luaL_error(L, "function pointer not found on pointer vector. This is *absolutely* an issue with this library...");
        return err_code;
    }
    vector_remove_element(listening_functions, index_of_pointer);
    listener->listening = false;
    return 0;
}

static int listener_check_status(lua_State *L) {
    listener_object *listener = luaL_checkudata(L, 1, "ListenerObject");
    lua_pushboolean(L, listener->listening);
    return 1;
}

static int gc_listener(lua_State *L) {
    listener_object *listener = lua_touserdata(L, 1);
    luaL_unref(L, LUA_REGISTRYINDEX, listener->pointer);
    size_t index_of_pointer = vector_index_of(listening_functions, &listener->pointer);
    if(index_of_pointer == -1) {
        return 0;
    }
    vector_remove_element(listening_functions, index_of_pointer);
    listener->listening = false;
    return 0;
}

static const luaL_Reg event_listener_methods[] = {
    {"connect", connect_listener},
    {"disconnect", disconnect_listener},
    {"is_listening", listener_check_status},
    {NULL, NULL}
};

void check_for_events(lua_State *L, lua_Debug *LD) {
    pthread_mutex_lock(&listener_function_lock);

    uiohook_event *event = pop_next_event(event_tree);

    pthread_mutex_unlock(&listener_function_lock);
    if(!event) {
        return;
    }
    
    void *data_clone_ptr = calloc(1, sizeof(listening_functions->data));
    if(!data_clone_ptr || !memcpy(data_clone_ptr, listening_functions->data, sizeof(listening_functions->data))) {
        free(event);
        return;
    }
    if(!memcpy(listening_functions_clone, listening_functions, sizeof(vector))) {
        free(data_clone_ptr);
        free(event);
        return;
    }
    listening_functions_clone->data = data_clone_ptr;

    if(listening_functions_clone->num_elements <= 0) {
        free(event);
        return;
    }

    lua_newtable(L);
    lua_pushinteger(L, event->type);
    lua_setfield(L, -2, "type");

    lua_pushinteger(L, event->time);
    lua_setfield(L, -2, "time");

    lua_pushinteger(L, event->reserved);
    lua_setfield(L, -2, "reserved");

    lua_pushinteger(L, event->mask);
    lua_setfield(L, -2, "mask");
    
    lua_newtable(L);
    lua_newtable(L);

    lua_pushinteger(L, event->data.keyboard.keycode);
    lua_setfield(L, -2, "keycode");

    lua_pushinteger(L, event->data.keyboard.keychar);
    lua_setfield(L, -2, "keychar");

    lua_pushinteger(L, event->data.keyboard.rawcode);
    lua_setfield(L, -2, "rawcode");

    lua_setfield(L, -2, "keyboard");

    lua_newtable(L);

    lua_pushinteger(L, event->data.mouse.button);
    lua_setfield(L, -2, "button");

    lua_pushinteger(L, event->data.mouse.clicks);
    lua_setfield(L, -2, "clicks");

    lua_pushinteger(L, event->data.mouse.x);
    lua_setfield(L, -2, "x");

    lua_pushinteger(L, event->data.mouse.y);
    lua_setfield(L, -2, "y");

    lua_setfield(L, -2, "mouse");

    lua_newtable(L);

    lua_pushinteger(L, event->data.wheel.type);
    lua_setfield(L, -2, "type");

    lua_pushinteger(L, event->data.wheel.clicks);
    lua_setfield(L, -2, "clicks");

    lua_pushinteger(L, event->data.wheel.x);
    lua_setfield(L, -2, "x");

    lua_pushinteger(L, event->data.wheel.y);
    lua_setfield(L, -2, "y");

    lua_pushinteger(L, event->data.wheel.amount);
    lua_setfield(L, -2, "amount");

    lua_pushinteger(L, event->data.wheel.rotation);
    lua_setfield(L, -2, "rotation");

    lua_pushinteger(L, event->data.wheel.direction);
    lua_setfield(L, -2, "direction");

    lua_setfield(L, -2, "wheel");

    lua_setfield(L, -2, "data");

    for (size_t i = 0; i < listening_functions_clone->num_elements; i++)
    {
        int function_address = *(int *)vector_get_element(listening_functions_clone, i);

        lua_rawgeti(L, LUA_REGISTRYINDEX, function_address);

        lua_pushvalue(L, -2);

        if (lua_pcall(L, 1, 0, 0) != LUA_OK) {
            const char *err = lua_tostring(L, -1);
            fprintf(stderr, "Error when running event callback: %s\n", err);
            lua_pop(L, 1);
        }
    }

    lua_pop(L, -1);
    free(event);
    return;
}

// INPUT EVENT LISTENER END AND FETCH FUNCTIONS START

static int get_pointer_sensitivity_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_pointer_sensitivity());
    return 1;
}

static int get_pointer_acceleration_multiplier_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_pointer_acceleration_multiplier());
    return 1;
}

static int get_pointer_acceleration_threshold_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_pointer_acceleration_threshold());
    return 1;
}

static int get_multi_click_time_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_multi_click_time());
    return 1;
}

static int get_auto_repeat_rate_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_auto_repeat_rate());
    return 1;
}

static int get_auto_repeat_delay_lua(lua_State *L) {
    lua_pushinteger(L, hook_get_auto_repeat_delay());
    return 1;
}

int get_monitor_dimensions_lua(lua_State *L) {
    int num_is_nil;
    int monitor_num = lua_tointegerx(L, 1, &num_is_nil);

    if(num_is_nil == 0) {
        monitor_num = 0;
    }

    unsigned char count = (unsigned char)monitor_num;

    screen_data *monitor = hook_create_screen_info(&count);

    if(monitor == NULL) {
        return 0;
    }

    lua_newtable(L);

    lua_pushinteger(L, monitor->height);
    lua_setfield(L, -2, "height");

    lua_pushinteger(L, monitor->width);
    lua_setfield(L, -2, "width");
    return 1;
}

// FIN.

static const struct luaL_Reg lua_functions[] = {
    {"keyboard_press", keyboard_press_key},
    {"keyboard_hold", keyboard_hold_key},
    {"keyboard_release", keyboard_release_key},
    {"mouse_press", click},
    {"mouse_hold", hold_mouse_button},
    {"mouse_release", release_mouse_button},
    {"get_mouse_coordinates", get_mouse_coordinates},
    {"move_mouse", move_mouse},
    {"scroll_mouse", scroll_mouse},
    {"new_input_listener", listen_events},
    {"get_pointer_sensitivity", get_pointer_sensitivity_lua},
    {"get_pointer_acceleration_multiplier", get_pointer_acceleration_multiplier_lua},
    {"get_pointer_acceleration_threshold", get_pointer_acceleration_threshold_lua},
    {"get_multi_click_time", get_multi_click_time_lua},
    {"get_keyboard_repeat_rate", get_auto_repeat_rate_lua},
    {"get_auto_repeat_delay", get_auto_repeat_delay_lua},
    {"get_monitor_dimensions", get_monitor_dimensions_lua},
    {NULL, NULL}
};

int luaopen_uiohook_core(lua_State *L)
{
    event_tree = calloc(1, sizeof(linked_list));
    listening_functions = new_vector(1, sizeof(int));
    listening_functions_clone = new_vector(1, sizeof(int));

    pthread_mutex_init(&hook_creation_lock, NULL);
    pthread_mutex_init(&listener_function_lock, NULL);

    hook_set_dispatch_proc(&libuiohook_on_event);

    int *status = calloc(1, sizeof(int));
    pthread_create(&listener_thread, NULL, run_hook, status);

    pthread_cond_wait(&hook_creation_wait, &hook_creation_lock);

    if(*status != UIOHOOK_SUCCESS) {
        fprintf(stderr, "Error initializing event listener thread: ");
        switch (*status) {
            // System level errors.
            case UIOHOOK_ERROR_OUT_OF_MEMORY:
                fprintf(stderr, "Failed to allocate memory. (%d)\n", *status);
                break;

            // X11 specific errors.
            case UIOHOOK_ERROR_X_OPEN_DISPLAY:
                fprintf(stderr, "Failed to open X11 display. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_X_RECORD_NOT_FOUND:
                fprintf(stderr, "Unable to locate XRecord extension. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_X_RECORD_ALLOC_RANGE:
                fprintf(stderr, "Unable to allocate XRecord range. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_X_RECORD_CREATE_CONTEXT:
                fprintf(stderr, "Unable to allocate XRecord context. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_X_RECORD_ENABLE_CONTEXT:
                fprintf(stderr, "Failed to enable XRecord context. (%d)\n", *status);
                break;


            // Windows specific errors.
            case UIOHOOK_ERROR_SET_WINDOWS_HOOK_EX:
                fprintf(stderr, "Failed to register low level windows hook. (%d)\n", *status);
                break;

            // Darwin specific errors.
            case UIOHOOK_ERROR_AXAPI_DISABLED:
                fprintf(stderr, "Failed to enable access for assistive devices. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_CREATE_EVENT_PORT:
                fprintf(stderr, "Failed to create apple event port. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_CREATE_RUN_LOOP_SOURCE:
                fprintf(stderr, "Failed to create apple run loop source. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_GET_RUNLOOP:
                fprintf(stderr, "Failed to acquire apple run loop. (%d)\n", *status);
                break;

            case UIOHOOK_ERROR_CREATE_OBSERVER:
                fprintf(stderr, "Failed to create apple run loop observer. (%d)\n", *status);
                break;

            case UIOHOOK_FAILURE:
            default:
                fprintf(stderr, "An unknown hook error occurred. (%d)\n", *status);
                break;
        }
        exit(*status);
    }

    free(status);

    luaL_newmetatable(L, "ListenerObject");
    luaL_setfuncs(L, event_listener_methods, 0);
    
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    lua_pushcfunction(L, gc_listener);
    lua_setfield(L, -2, "__gc");
    
    lua_pop(L, 1);

    luaL_newlib(L, lua_functions);
    lua_sethook(L, check_for_events, LUA_MASKCOUNT, 100);

    return 1;
}