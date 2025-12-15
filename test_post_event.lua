local lua_uiohook = require("lua-uiohook");

local my_event = {
    data = {
        mouse = {
            x = 400,
            y = 340
        }
    },
    type = lua_uiohook.EVENT_TYPES.EVENT_MOUSE_MOVED
}
_ = io.read("*l");

lua_uiohook.post_event(my_event);