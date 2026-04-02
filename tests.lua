local io = require("io");
local lua_uiohook = require("lua-uiohook");

function ask(question)
	print(question);
	return io.read("*l");
end

function wait(seconds)
	local endTime = os.time() + seconds
	while os.time() < endTime do
		-- the void of despair and grief
	end
end

local sentence = {
	lua_uiohook.KEY_CODES.KEY_H,
	lua_uiohook.KEY_CODES.KEY_E,
	lua_uiohook.KEY_CODES.KEY_L,
	lua_uiohook.KEY_CODES.KEY_L,
	lua_uiohook.KEY_CODES.KEY_O,
	lua_uiohook.KEY_CODES.KEY_SPACE,
	lua_uiohook.KEY_CODES.KEY_W,
	lua_uiohook.KEY_CODES.KEY_O,
	lua_uiohook.KEY_CODES.KEY_R,
	lua_uiohook.KEY_CODES.KEY_L,
	lua_uiohook.KEY_CODES.KEY_D,
	lua_uiohook.KEY_CODES.KEY_1
}

print("KEYBOARD INPUT START!")

print("Spelling the sentence \"Hello world!\"")
for i, key in pairs(sentence) do
	if i == 1 or i == #sentence then
		lua_uiohook.keyboard_hold(lua_uiohook.KEY_CODES.KEY_SHIFT_L, lua_uiohook.MODIFIER_MASKS.MASK_SHIFT_L);
		lua_uiohook.keyboard_press(key, lua_uiohook.MODIFIER_MASKS.MASK_SHIFT_L)
		lua_uiohook.keyboard_release(lua_uiohook.KEY_CODES.KEY_SHIFT_L, lua_uiohook.MODIFIER_MASKS.MASK_SHIFT_L);
	else
		lua_uiohook.keyboard_press(key)
	end
	wait(1)
end

print("MOUSE INPUT GO!")

print("Moving the mouse to 0,0")
lua_uiohook.move_mouse(0, 0);

wait(3)

print("Fetching monitor dimensions")
local monitor_size = lua_uiohook.get_monitor_dimensions();

print("width: ", monitor_size.width, " height: ", monitor_size.height)

wait(1)

local new_dims = {
	width = math.floor(monitor_size.width / 2),
	height = math.floor(monitor_size.height / 2)
}

print("Moving mouse to ", new_dims.width, ",", new_dims.height)

lua_uiohook.move_mouse(new_dims.width, new_dims.height)

wait(1)

print("Pressing the right mouse button")

lua_uiohook.mouse_press(lua_uiohook.MOUSE_BUTTON.MOUSE_BUTTON2)

print("Fin.")