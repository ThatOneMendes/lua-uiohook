local lib_uiohook = require("lua-uiohook.core");
local constants = require("lua-uiohook.constants");

local function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function ()
            error("attempt to update a read-only table", 2)
        end,
        __pairs = function()
            return pairs(t)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

-- Setup constants
lib_uiohook.EVENT_TYPES = readOnly(constants["EVENT_TYPES"]);
lib_uiohook.KEY_CODES = readOnly(constants["KEY_CODES"]);
lib_uiohook.MODIFIER_MASKS = readOnly(constants["MODIFIER_MASKS"]);
lib_uiohook.MOUSE_BUTTON = readOnly(constants["MOUSE_BUTTON"]);
lib_uiohook.SCROLL_DIRECTIONS = readOnly(constants["SCROLL_DIRECTIONS"]);
lib_uiohook.SCROLL_ROTATIONS = readOnly(constants["SCROLL_ROTATIONS"]);

local function get_key_in_table_by_value(t, value)
    for name, v in pairs(t) do
        if v == value then
            return name
        end
    end
    return nil
end

function lib_uiohook.get_key_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.KEY_CODES, value)
end

function lib_uiohook.get_event_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.EVENT_TYPES, value)
end

function lib_uiohook.get_modifier_mask_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.MODIFIER_MASKS, value)
end

function lib_uiohook.get_mouse_button_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.MOUSE_BUTTON, value)
end

function lib_uiohook.get_scroll_rotation_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.SCROLL_ROTATIONS, value)
end

function lib_uiohook.get_scroll_direction_name_by_value(value)
    return get_key_in_table_by_value(lib_uiohook.SCROLL_DIRECTIONS, value)
end

local mouse_press = lib_uiohook.mouse_press
local mouse_hold = lib_uiohook.mouse_hold
local mouse_release = lib_uiohook.mouse_release
local scroll_mouse = lib_uiohook.scroll_mouse

function lib_uiohook.mouse_press(mouse_button, x, y)
    local mouse_coordinates = lib_uiohook.get_mouse_coordinates()
    if type(x) ~= "number" then
        x = mouse_coordinates[1];
    end
    if type(y) ~= "number" then
        y = mouse_coordinates[2];
    end
    if type(mouse_button) ~= "number" or not lib_uiohook.get_mouse_button_name_by_value(mouse_button) == nil then
        error("mouse_button must be a valid lib_uiohook.MOUSE_BUTTON.")
    end

    mouse_press(mouse_button, x, y)
end

function lib_uiohook.mouse_hold(mouse_button, x, y)
    local mouse_coordinates = lib_uiohook.get_mouse_coordinates()
    if type(x) ~= "number" then
        x = mouse_coordinates[1];
    end
    if type(y) ~= "number" then
        y = mouse_coordinates[2];
    end
    if type(mouse_button) ~= "number" or not lib_uiohook.get_mouse_button_name_by_value(mouse_button) == nil then
        error("mouse_button must be a valid lib_uiohook.MOUSE_BUTTON.")
    end

    mouse_hold(mouse_button, x, y)
end

function lib_uiohook.mouse_release(mouse_button, x, y)
    local mouse_coordinates = lib_uiohook.get_mouse_coordinates()
    if type(x) ~= "number" then
        x = mouse_coordinates[1];
    end
    if type(y) ~= "number" then
        y = mouse_coordinates[2];
    end
    if type(mouse_button) ~= "number" or lib_uiohook.get_mouse_button_name_by_value(mouse_button) == nil then
        error("mouse_button must be a valid lua_uiohook.MOUSE_BUTTON")
    end

    mouse_release(mouse_button, x, y)
end

function lib_uiohook.scroll_mouse(amount, direction, rotation)
    if not amount then
        amount = 3
    end
    if not direction then
        direction = lib_uiohook.SCROLL_DIRECTIONS.UP_DOWN
    end
    if not rotation then
        rotation = lib_uiohook.SCROLL_ROTATIONS.DOWN
    end

    if type(amount) ~= "number" then
        error("amount must be a valid number.");
    end
    if type(direction) ~= "number" or lib_uiohook.get_scroll_direction_name_by_value(direction) == nil then
        error("direction must be a valid lua_uiohook.SCROLL_DIRECTIONS")
    end
    if type(rotation) ~= "number" or lib_uiohook.get_scroll_rotation_name_by_value(rotation) == nil then
        error("rotation must be a valid lua_uiohook.SCROLL_ROTATIONS")
    end

    scroll_mouse(amount, direction, rotation)
end

local keyboard_press = lib_uiohook.keyboard_press
local keyboard_hold = lib_uiohook.keyboard_hold
local keyboard_release = lib_uiohook.keyboard_release

function lib_uiohook.keyboard_press(key_code, mask)
    if not mask then
        mask = lib_uiohook.MODIFIER_MASKS.MASK_NONE
    end
    if type(key_code) ~= "number" or lib_uiohook.get_key_name_by_value(key_code) == nil then
        error("key_code must be a valid lua_uiohook.KEY_CODES")
    end
    if type(mask) ~= "number" or lib_uiohook.get_modifier_mask_name_by_value(mask) == nil then
        error("mask must be a valid lua_uiohook.MODIFIER_MASKS")
    end
    keyboard_press(key_code, mask)
end

function lib_uiohook.keyboard_hold(key_code, mask)
    if not mask then
        mask = lib_uiohook.MODIFIER_MASKS.MASK_NONE
    end
    if type(key_code) ~= "number" or lib_uiohook.get_key_name_by_value(key_code) == nil then
        error("key_code must be a valid lua_uiohook.KEY_CODES")
    end
    if type(mask) ~= "number" or lib_uiohook.get_modifier_mask_name_by_value(mask) == nil then
        error("mask must be a valid lua_uiohook.MODIFIER_MASKS")
    end
    keyboard_hold(key_code, mask)
end

function lib_uiohook.keyboard_release(key_code, mask)
    if not mask then
        mask = lib_uiohook.MODIFIER_MASKS.MASK_NONE
    end
    if type(key_code) ~= "number" or lib_uiohook.get_key_name_by_value(key_code) == nil then
        error("key_code must be a valid lua_uiohook.KEY_CODES")
    end
    if type(mask) ~= "number" or lib_uiohook.get_modifier_mask_name_by_value(mask) == nil then
        error("mask must be a valid lua_uiohook.MODIFIER_MASKS")
    end
    keyboard_release(key_code, mask)
end

return lib_uiohook