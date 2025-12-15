local io = require("io");
local lua_uiohook = require("lua-uiohook");
local listener;

function print_table(t, level)
    level = level or 0
    local indent = string.rep("    ", level)

    if type(t) ~= "table" then
        print(indent .. tostring(t))
        return
    end

    print(indent .. "{")
    for key, value in pairs(t) do
        io.write(indent .. "  [" .. tostring(key) .. "] = ")
        if type(value) == "table" then
            print_table(value, level + 1)
        else
            print(tostring(value) .. ",")
        end
    end
    print(indent .. "}")
end

listener = lua_uiohook.new_input_listener(function(event)
    print("NEW INPUT EVENT");
    print("Of type: ", lua_uiohook.get_event_name_by_value(event.type));
    print("Event data:\n");
    print_table(event.data);
    if event.type == lua_uiohook.EVENT_TYPES.EVENT_KEY_PRESSED and event.data.keyboard.keycode == lua_uiohook.KEY_CODES.KEY_ESCAPE then
        listener:disconnect();
    end
end)

listener:connect()

while listener:is_listening() do
    
end