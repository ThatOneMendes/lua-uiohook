# lua-uiohook
A lua module that adds bindings to [libuiohook](https://github.com/kwhat/libuiohook/), a cross-platform keyboard and mouse hooking library.

## Installation
Simply run
```
luarocks install lua-uiohook
```

## Example usage
```lua
local lua_uiohook = require("lua-uiohook");

-- Keyboard input: pressing a key
lua_uiohook.keyboard_press(lua_uiohook.KEY_CODES.KEY_E);

-- Mouse input: moving the mouse then pressing the middle mouse button
local x = 40;
local y = 70;
lua_uiohook.mouse_press(lua_uiohook.MOUSE_BUTTON.MOUSE_BUTTON3, x, y);
-- another way you can do it
lua_uiohook.mouse_move(x, y);
lua_uiohook.mouse_press(lua_uiohook.MOUSE_BUTTON.MOUSE_BUTTON3);

function print_table(table)
    -- pretend like theres a function that prints a table here
end

-- Listen to inputs
local listener;
listener = lua_uiohook.new_event_listener(function(event)
    print("NEW INPUT EVENT");
    print("Of type: ", lua_uiohook.get_event_name_by_value(event.type));
    print("Event data:\n");
    print_table(event.data);
    if event.type == lua_uiohook.EVENT_TYPES.EVENT_KEY_PRESSED and event.data.keyboard.keycode == lua_uiohook.KEY_CODES.KEY_ESCAPE then
        listener:disconnect();
    end
end);

listener:connect();

while listener:is_listening() do
    -- nothing.
end
```