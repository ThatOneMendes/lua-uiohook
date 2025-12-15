---@diagnostic disable: missing-return, duplicate-doc-field, duplicate-doc-alias, duplicate-set-field
local lua_uiohook = {}

---@alias KEY_CODE integer

---@class KEY_CODES
---@field KEY_ESCAPE KEY_CODE @Esc key
---@field KEY_F1 KEY_CODE @Function key F1
---@field KEY_F2 KEY_CODE @Function key F2
---@field KEY_F3 KEY_CODE @Function key F3
---@field KEY_F4 KEY_CODE @Function key F4
---@field KEY_F5 KEY_CODE @Function key F5
---@field KEY_F6 KEY_CODE @Function key F6
---@field KEY_F7 KEY_CODE @Function key F7
---@field KEY_F8 KEY_CODE @Function key F8
---@field KEY_F9 KEY_CODE @Function key F9
---@field KEY_F10 KEY_CODE @Function key F10
---@field KEY_F11 KEY_CODE @Function key F11
---@field KEY_F12 KEY_CODE @Function key F12
---@field KEY_F13 KEY_CODE @Function key F13
---@field KEY_F14 KEY_CODE @Function key F14
---@field KEY_F15 KEY_CODE @Function key F15
---@field KEY_F16 KEY_CODE @Function key F16
---@field KEY_F17 KEY_CODE @Function key F17
---@field KEY_F18 KEY_CODE @Function key F18
---@field KEY_F19 KEY_CODE @Function key F19
---@field KEY_F20 KEY_CODE @Function key F20
---@field KEY_F21 KEY_CODE @Function key F21
---@field KEY_F22 KEY_CODE @Function key F22
---@field KEY_F23 KEY_CODE @Function key F23
---@field KEY_F24 KEY_CODE @Function key F24
---@field KEY_BACKQUOTE KEY_CODE @` (backtick / tilde) key
---@field KEY_1 KEY_CODE @"1" key
---@field KEY_2 KEY_CODE @"2" key
---@field KEY_3 KEY_CODE @"3" key
---@field KEY_4 KEY_CODE @"4" key
---@field KEY_5 KEY_CODE @"5" key
---@field KEY_6 KEY_CODE @"6" key
---@field KEY_7 KEY_CODE @"7" key
---@field KEY_8 KEY_CODE @"8" key
---@field KEY_9 KEY_CODE @"9" key
---@field KEY_0 KEY_CODE @"0" key
---@field KEY_MINUS KEY_CODE @- / _ key
---@field KEY_EQUALS KEY_CODE @= / + key
---@field KEY_BACKSPACE KEY_CODE @Backspace
---@field KEY_TAB KEY_CODE @Tab
---@field KEY_CAPS_LOCK KEY_CODE @Caps Lock
---@field KEY_A KEY_CODE @Letter A
---@field KEY_B KEY_CODE @Letter B
---@field KEY_C KEY_CODE @Letter C
---@field KEY_D KEY_CODE @Letter D
---@field KEY_E KEY_CODE @Letter E
---@field KEY_F KEY_CODE @Letter F
---@field KEY_G KEY_CODE @Letter G
---@field KEY_H KEY_CODE @Letter H
---@field KEY_I KEY_CODE @Letter I
---@field KEY_J KEY_CODE @Letter J
---@field KEY_K KEY_CODE @Letter K
---@field KEY_L KEY_CODE @Letter L
---@field KEY_M KEY_CODE @Letter M
---@field KEY_N KEY_CODE @Letter N
---@field KEY_O KEY_CODE @Letter O
---@field KEY_P KEY_CODE @Letter P
---@field KEY_Q KEY_CODE @Letter Q
---@field KEY_R KEY_CODE @Letter R
---@field KEY_S KEY_CODE @Letter S
---@field KEY_T KEY_CODE @Letter T
---@field KEY_U KEY_CODE @Letter U
---@field KEY_V KEY_CODE @Letter V
---@field KEY_W KEY_CODE @Letter W
---@field KEY_X KEY_CODE @Letter X
---@field KEY_Y KEY_CODE @Letter Y
---@field KEY_Z KEY_CODE @Letter Z
---@field KEY_OPEN_BRACKET KEY_CODE @[ key
---@field KEY_CLOSE_BRACKET KEY_CODE @] key
---@field KEY_BACK_SLASH KEY_CODE @\ / | key
---@field KEY_SEMICOLON KEY_CODE @; / : key
---@field KEY_QUOTE KEY_CODE @' / " key
---@field KEY_ENTER KEY_CODE @Enter / Return key
---@field KEY_COMMA KEY_CODE @, key
---@field KEY_PERIOD KEY_CODE @. key
---@field KEY_SLASH KEY_CODE @/ / ? key
---@field KEY_SPACE KEY_CODE @Space bar
---@field KEY_PRINTSCREEN KEY_CODE @Print Screen / SysRq
---@field KEY_SCROLL_LOCK KEY_CODE @Scroll Lock
---@field KEY_PAUSE KEY_CODE @Pause / Break
---@field KEY_LESSER_GREATER KEY_CODE @\< \> (ISO extra key)
---@field KEY_INSERT KEY_CODE @Insert
---@field KEY_DELETE KEY_CODE @Delete
---@field KEY_HOME KEY_CODE @Home
---@field KEY_END KEY_CODE @End
---@field KEY_PAGE_UP KEY_CODE @Page Up
---@field KEY_PAGE_DOWN KEY_CODE @Page Down
---@field KEY_UP KEY_CODE @Arrow Up
---@field KEY_LEFT KEY_CODE @Arrow Left
---@field KEY_CLEAR KEY_CODE @Clear
---@field KEY_RIGHT KEY_CODE @Arrow Right
---@field KEY_DOWN KEY_CODE @Arrow Down
---@field KEY_NUM_LOCK KEY_CODE @Num Lock
---@field KEY_KP_DIVIDE KEY_CODE @Keypad /
---@field KEY_KP_MULTIPLY KEY_CODE @Keypad *
---@field KEY_KP_SUBTRACT KEY_CODE @Keypad -
---@field KEY_KP_EQUALS KEY_CODE @Keypad =
---@field KEY_KP_ADD KEY_CODE @Keypad +
---@field KEY_KP_ENTER KEY_CODE @Keypad Enter
---@field KEY_KP_SEPARATOR KEY_CODE @Keypad separator (, or . depending on locale)
---@field KEY_KP_1 KEY_CODE @Keypad 1
---@field KEY_KP_2 KEY_CODE @Keypad 2
---@field KEY_KP_3 KEY_CODE @Keypad 3
---@field KEY_KP_4 KEY_CODE @Keypad 4
---@field KEY_KP_5 KEY_CODE @Keypad 5
---@field KEY_KP_6 KEY_CODE @Keypad 6
---@field KEY_KP_7 KEY_CODE @Keypad 7
---@field KEY_KP_8 KEY_CODE @Keypad 8
---@field KEY_KP_9 KEY_CODE @Keypad 9
---@field KEY_KP_0 KEY_CODE @Keypad 0
---@field KEY_KP_END KEY_CODE @Keypad End
---@field KEY_KP_DOWN KEY_CODE @Keypad Down Arrow
---@field KEY_KP_PAGE_DOWN KEY_CODE @Keypad Page Down
---@field KEY_KP_LEFT KEY_CODE @Keypad Left Arrow
---@field KEY_KP_CLEAR KEY_CODE @Keypad Clear
---@field KEY_KP_RIGHT KEY_CODE @Keypad Right Arrow
---@field KEY_KP_HOME KEY_CODE @Keypad Home
---@field KEY_KP_UP KEY_CODE @Keypad Up Arrow
---@field KEY_KP_PAGE_UP KEY_CODE @Keypad Page Up
---@field KEY_KP_INSERT KEY_CODE @Keypad Insert
---@field KEY_KP_DELETE KEY_CODE @Keypad Delete
---@field KEY_SHIFT_L KEY_CODE @Left Shift
---@field KEY_SHIFT_R KEY_CODE @Right Shift
---@field KEY_CONTROL_L KEY_CODE @Left Control
---@field KEY_CONTROL_R KEY_CODE @Right Control
---@field KEY_ALT_L KEY_CODE @Left Alt
---@field KEY_ALT_R KEY_CODE @Right Alt
---@field KEY_META_L KEY_CODE @Left Meta
---@field KEY_META_R KEY_CODE @Right Meta
---@field KEY_CONTEXT_MENU KEY_CODE @Application / Menu key
---@field KEY_POWER KEY_CODE @Power key
---@field KEY_SLEEP KEY_CODE @Sleep key
---@field KEY_WAKE KEY_CODE @Wake key
---@field KEY_MEDIA_PLAY KEY_CODE @Play / Pause media key
---@field KEY_MEDIA_STOP KEY_CODE @Stop media playback
---@field KEY_MEDIA_PREVIOUS KEY_CODE @Previous track
---@field KEY_MEDIA_NEXT KEY_CODE @Next track
---@field KEY_MEDIA_SELECT KEY_CODE @Launch media app
---@field KEY_MEDIA_EJECT KEY_CODE @Eject optical media
---@field KEY_VOLUME_MUTE KEY_CODE @Mute
---@field KEY_VOLUME_UP KEY_CODE @Volume Up
---@field KEY_VOLUME_DOWN KEY_CODE @Volume Down
---@field KEY_APP_MAIL KEY_CODE @Launch mail app
---@field KEY_APP_CALCULATOR KEY_CODE @Launch calculator
---@field KEY_APP_MUSIC KEY_CODE @Launch music player
---@field KEY_APP_PICTURES KEY_CODE @Launch images/pictures app
---@field KEY_BROWSER_SEARCH KEY_CODE @Browser search
---@field KEY_BROWSER_HOME KEY_CODE @Browser home
---@field KEY_BROWSER_BACK KEY_CODE @Browser back
---@field KEY_BROWSER_FORWARD KEY_CODE @Browser forward
---@field KEY_BROWSER_STOP KEY_CODE @Browser stop
---@field KEY_BROWSER_REFRESH KEY_CODE @Browser refresh
---@field KEY_BROWSER_FAVORITES KEY_CODE @Browser favorites
---@field KEY_KATAKANA KEY_CODE @Japanese Katakana mode
---@field KEY_UNDERSCORE KEY_CODE @_ (underscore) Japanese keyboard
---@field KEY_FURIGANA KEY_CODE @Furigana (JP)
---@field KEY_KANJI KEY_CODE @Kanji convert key
---@field KEY_HIRAGANA KEY_CODE @Hiragana mode
---@field KEY_YEN KEY_CODE @Yen ¥ key (Japanese)
---@field KEY_KP_COMMA KEY_CODE @Keypad comma (European)
---@field KEY_SUN_HELP KEY_CODE @Sun Help key
---@field KEY_SUN_STOP KEY_CODE @Sun Stop key
---@field KEY_SUN_PROPS KEY_CODE @Sun Props
---@field KEY_SUN_FRONT KEY_CODE @Sun Front
---@field KEY_SUN_OPEN KEY_CODE @Sun Open
---@field KEY_SUN_FIND KEY_CODE @Sun Find
---@field KEY_SUN_AGAIN KEY_CODE @Sun Again
---@field KEY_SUN_UNDO KEY_CODE @Sun Undo
---@field KEY_SUN_COPY KEY_CODE @Sun Copy
---@field KEY_SUN_INSERT KEY_CODE @Sun Insert
---@field KEY_SUN_CUT KEY_CODE @Sun Cut
---@field KEY_UNDEFINED KEY_CODE @Undefined / unknown key

---@type KEY_CODES
lua_uiohook.KEY_CODES = {
    KEY_ESCAPE                                = 0x0001,

    KEY_F1                                    = 0x003B,
    KEY_F2                                    = 0x003C,
    KEY_F3                                    = 0x003D,
    KEY_F4                                    = 0x003E,
    KEY_F5                                    = 0x003F,
    KEY_F6                                    = 0x0040,
    KEY_F7                                    = 0x0041,
    KEY_F8                                    = 0x0042,
    KEY_F9                                    = 0x0043,
    KEY_F10                                   = 0x0044,
    KEY_F11                                   = 0x0057,
    KEY_F12                                   = 0x0058,
    KEY_F13                                   = 0x005B,
    KEY_F14                                   = 0x005C,
    KEY_F15                                   = 0x005D,
    KEY_F16                                   = 0x0063,
    KEY_F17                                   = 0x0064,
    KEY_F18                                   = 0x0065,
    KEY_F19                                   = 0x0066,
    KEY_F20                                   = 0x0067,
    KEY_F21                                   = 0x0068,
    KEY_F22                                   = 0x0069,
    KEY_F23                                   = 0x006A,
    KEY_F24                                   = 0x006B,

    KEY_BACKQUOTE                             = 0x0029,

    KEY_1                                     = 0x0002,
    KEY_2                                     = 0x0003,
    KEY_3                                     = 0x0004,
    KEY_4                                     = 0x0005,
    KEY_5                                     = 0x0006,
    KEY_6                                     = 0x0007,
    KEY_7                                     = 0x0008,
    KEY_8                                     = 0x0009,
    KEY_9                                     = 0x000A,
    KEY_0                                     = 0x000B,

    KEY_MINUS                                 = 0x000C,
    KEY_EQUALS                                = 0x000D,
    KEY_BACKSPACE                             = 0x000E,

    KEY_TAB                                   = 0x000F,
    KEY_CAPS_LOCK                             = 0x003A,

    KEY_A                                     = 0x001E,
    KEY_B                                     = 0x0030,
    KEY_C                                     = 0x002E,
    KEY_D                                     = 0x0020,
    KEY_E                                     = 0x0012,
    KEY_F                                     = 0x0021,
    KEY_G                                     = 0x0022,
    KEY_H                                     = 0x0023,
    KEY_I                                     = 0x0017,
    KEY_J                                     = 0x0024,
    KEY_K                                     = 0x0025,
    KEY_L                                     = 0x0026,
    KEY_M                                     = 0x0032,
    KEY_N                                     = 0x0031,
    KEY_O                                     = 0x0018,
    KEY_P                                     = 0x0019,
    KEY_Q                                     = 0x0010,
    KEY_R                                     = 0x0013,
    KEY_S                                     = 0x001F,
    KEY_T                                     = 0x0014,
    KEY_U                                     = 0x0016,
    KEY_V                                     = 0x002F,
    KEY_W                                     = 0x0011,
    KEY_X                                     = 0x002D,
    KEY_Y                                     = 0x0015,
    KEY_Z                                     = 0x002C,

    KEY_OPEN_BRACKET                          = 0x001A,
    KEY_CLOSE_BRACKET                         = 0x001B,
    KEY_BACK_SLASH                            = 0x002B,

    KEY_SEMICOLON                             = 0x0027,
    KEY_QUOTE                                 = 0x0028,
    KEY_ENTER                                 = 0x001C,

    KEY_COMMA                                 = 0x0033,
    KEY_PERIOD                                = 0x0034,
    KEY_SLASH                                 = 0x0035,

    KEY_SPACE                                 = 0x0039,

    KEY_PRINTSCREEN                           = 0x0E37,
    KEY_SCROLL_LOCK                           = 0x0046,
    KEY_PAUSE                                 = 0x0E45,

    KEY_LESSER_GREATER                        = 0x0E46,

    KEY_INSERT                                = 0x0E52,
    KEY_DELETE                                = 0x0E53,
    KEY_HOME                                  = 0x0E47,
    KEY_END                                   = 0x0E4F,
    KEY_PAGE_UP                               = 0x0E49,
    KEY_PAGE_DOWN                             = 0x0E51,

    KEY_UP                                    = 0xE048,
    KEY_LEFT                                  = 0xE04B,
    KEY_CLEAR                                 = 0xE04C,
    KEY_RIGHT                                 = 0xE04D,
    KEY_DOWN                                  = 0xE050,

    KEY_NUM_LOCK                              = 0x0045,
    KEY_KP_DIVIDE                             = 0x0E35,
    KEY_KP_MULTIPLY                           = 0x0037,
    KEY_KP_SUBTRACT                           = 0x004A,
    KEY_KP_EQUALS                             = 0x0E0D,
    KEY_KP_ADD                                = 0x004E,
    KEY_KP_ENTER                              = 0x0E1C,
    KEY_KP_SEPARATOR                          = 0x0053,

    KEY_KP_1                                  = 0x004F,
    KEY_KP_2                                  = 0x0050,
    KEY_KP_3                                  = 0x0051,
    KEY_KP_4                                  = 0x004B,
    KEY_KP_5                                  = 0x004C,
    KEY_KP_6                                  = 0x004D,
    KEY_KP_7                                  = 0x0047,
    KEY_KP_8                                  = 0x0048,
    KEY_KP_9                                  = 0x0049,
    KEY_KP_0                                  = 0x0052,

    KEY_KP_END                                = 0xEE00 | 0x004F,
    KEY_KP_DOWN                               = 0xEE00 | 0x0050,
    KEY_KP_PAGE_DOWN                          = 0xEE00 | 0x0051,
    KEY_KP_LEFT                               = 0xEE00 | 0x004B,
    KEY_KP_CLEAR                              = 0xEE00 | 0x004C,
    KEY_KP_RIGHT                              = 0xEE00 | 0x004D,
    KEY_KP_HOME                               = 0xEE00 | 0x0047,
    KEY_KP_UP                                 = 0xEE00 | 0x0048,
    KEY_KP_PAGE_UP                            = 0xEE00 | 0x0049,
    KEY_KP_INSERT                             = 0xEE00 | 0x0052,
    KEY_KP_DELETE                             = 0xEE00 | 0x0053,

    KEY_SHIFT_L                               = 0x002A,
    KEY_SHIFT_R                               = 0x0036,
    KEY_CONTROL_L                             = 0x001D,
    KEY_CONTROL_R                             = 0x0E1D,
    KEY_ALT_L                                 = 0x0038,
    KEY_ALT_R                                 = 0x0E38,
    KEY_META_L                                = 0x0E5B,
    KEY_META_R                                = 0x0E5C,
    KEY_CONTEXT_MENU                          = 0x0E5D,

    KEY_POWER                                 = 0xE05E,
    KEY_SLEEP                                 = 0xE05F,
    KEY_WAKE                                  = 0xE063,

    KEY_MEDIA_PLAY                            = 0xE022,
    KEY_MEDIA_STOP                            = 0xE024,
    KEY_MEDIA_PREVIOUS                        = 0xE010,
    KEY_MEDIA_NEXT                            = 0xE019,
    KEY_MEDIA_SELECT                          = 0xE06D,
    KEY_MEDIA_EJECT                           = 0xE02C,

    KEY_VOLUME_MUTE                           = 0xE020,
    KEY_VOLUME_UP                             = 0xE030,
    KEY_VOLUME_DOWN                           = 0xE02E,

    KEY_APP_MAIL                              = 0xE06C,
    KEY_APP_CALCULATOR                        = 0xE021,
    KEY_APP_MUSIC                             = 0xE03C,
    KEY_APP_PICTURES                          = 0xE064,

    KEY_BROWSER_SEARCH                        = 0xE065,
    KEY_BROWSER_HOME                          = 0xE032,
    KEY_BROWSER_BACK                          = 0xE06A,
    KEY_BROWSER_FORWARD                       = 0xE069,
    KEY_BROWSER_STOP                          = 0xE068,
    KEY_BROWSER_REFRESH                       = 0xE067,
    KEY_BROWSER_FAVORITES                     = 0xE066,

    KEY_KATAKANA                              = 0x0070,
    KEY_UNDERSCORE                            = 0x0073,
    KEY_FURIGANA                              = 0x0077,
    KEY_KANJI                                 = 0x0079,
    KEY_HIRAGANA                              = 0x007B,
    KEY_YEN                                   = 0x007D,
    KEY_KP_COMMA                              = 0x007E,

    KEY_SUN_HELP                              = 0xFF75,
    KEY_SUN_STOP                              = 0xFF78,
    KEY_SUN_PROPS                             = 0xFF76,
    KEY_SUN_FRONT                             = 0xFF77,
    KEY_SUN_OPEN                              = 0xFF74,
    KEY_SUN_FIND                              = 0xFF7E,
    KEY_SUN_AGAIN                             = 0xFF79,
    KEY_SUN_UNDO                              = 0xFF7A,
    KEY_SUN_COPY                              = 0xFF7C,
    KEY_SUN_INSERT                            = 0xFF7D,
    KEY_SUN_CUT                               = 0xFF7B,

    KEY_UNDEFINED                             = 0x0000,
}

---@class Coordinates
---@field [1] integer
---@field [2] integer

---@class Dimensions
---@field width integer
---@field height integer

---@alias MODIFIER_MASK integer

---@class MODIFIER_MASKS
---@field MASK_NONE MODIFIER_MASK @No mask
---@field MASK_SHIFT_L MODIFIER_MASK @Left Shift
---@field MASK_CTRL_L MODIFIER_MASK @Left Control
---@field MASK_META_L MODIFIER_MASK @Left Meta
---@field MASK_ALT_L MODIFIER_MASK @Left Alt
---@field MASK_SHIFT_R MODIFIER_MASK @Right Shift
---@field MASK_CTRL_R MODIFIER_MASK @Right Control
---@field MASK_META_R MODIFIER_MASK @Right Meta
---@field MASK_ALT_R MODIFIER_MASK @Right Alt
---@field MASK_SHIFT MODIFIER_MASK @Left or Right Shift
---@field MASK_CTRL MODIFIER_MASK @Left or Right Control
---@field MASK_META MODIFIER_MASK @Left or Right Meta
---@field MASK_ALT MODIFIER_MASK @Left or Right Alt
---@field MASK_BUTTON1 MODIFIER_MASK @Mouse Button 1
---@field MASK_BUTTON2 MODIFIER_MASK @Mouse Button 2
---@field MASK_BUTTON3 MODIFIER_MASK @Mouse Button 3
---@field MASK_BUTTON4 MODIFIER_MASK @Mouse Button 4
---@field MASK_BUTTON5 MODIFIER_MASK @Mouse Button 5
---@field MASK_NUM_LOCK MODIFIER_MASK @Num Lock
---@field MASK_CAPS_LOCK MODIFIER_MASK @Caps Lock
---@field MASK_SCROLL_LOCK MODIFIER_MASK @Scroll Lock

---@type MODIFIER_MASKS
lua_uiohook.MODIFIER_MASKS = {
    MASK_NONE        = 0,
    MASK_SHIFT_L     = 1 << 0,
    MASK_CTRL_L      = 1 << 1,
    MASK_META_L      = 1 << 2,
    MASK_ALT_L       = 1 << 3,

    MASK_SHIFT_R     = 1 << 4,
    MASK_CTRL_R      = 1 << 5,
    MASK_META_R      = 1 << 6,
    MASK_ALT_R       = 1 << 7,

    MASK_SHIFT       = (1 << 0) | (1 << 4),
    MASK_CTRL        = (1 << 1) | (1 << 5),
    MASK_META        = (1 << 2) | (1 << 6),
    MASK_ALT         = (1 << 3) | (1 << 7),

    MASK_BUTTON1     = 1 << 8,
    MASK_BUTTON2     = 1 << 9,
    MASK_BUTTON3     = 1 << 10,
    MASK_BUTTON4     = 1 << 11,
    MASK_BUTTON5     = 1 << 12,

    MASK_NUM_LOCK    = 1 << 13,
    MASK_CAPS_LOCK   = 1 << 14,
    MASK_SCROLL_LOCK = 1 << 15,
}

---@alias MOUSE_BUTTON integer

---@class MOUSE_BUTTONS
---@field MOUSE_NOBUTTON MOUSE_BUTTON @Any button
---@field MOUSE_BUTTON1  MOUSE_BUTTON @Left button
---@field MOUSE_BUTTON2  MOUSE_BUTTON @Right button
---@field MOUSE_BUTTON3  MOUSE_BUTTON @Middle button

---@type MOUSE_BUTTONS
lua_uiohook.MOUSE_BUTTON = {
    MOUSE_NOBUTTON =                             0,
    MOUSE_BUTTON1  =                             1,
    MOUSE_BUTTON2  =                             3,
    MOUSE_BUTTON3  =                             2
}

---@alias EVENT_TYPE integer

---@class EVENT_TYPES
---@field EVENT_HOOK_ENABLED EVENT_TYPE   @Event listener enabled, doesn't actually fire since this library sets up event listening on load.
---@field EVENT_HOOK_DISABLED EVENT_TYPE  @Event listener disabled, doesn't actually fire since this library never disables the event listener once enabled.
---@field EVENT_KEY_TYPED EVENT_TYPE      @Key typed, not recomended to use this since the data.keycode value is always 0 when this event fires, listen for KEY_PRESSED instead.
---@field EVENT_KEY_PRESSED EVENT_TYPE    @Key pressed
---@field EVENT_KEY_RELEASED EVENT_TYPE   @Key released
---@field EVENT_MOUSE_CLICKED EVENT_TYPE  @Mouse clicked
---@field EVENT_MOUSE_PRESSED EVENT_TYPE  @Mouse pressed
---@field EVENT_MOUSE_RELEASED EVENT_TYPE @Mouse released
---@field EVENT_MOUSE_MOVED EVENT_TYPE    @Mouse moved
---@field EVENT_MOUSE_DRAGGED EVENT_TYPE  @Mouse dragged
---@field EVENT_MOUSE_WHEEL EVENT_TYPE    @Mouse wheel

---@type EVENT_TYPES
lua_uiohook.EVENT_TYPES = {
    EVENT_HOOK_ENABLED   = 1,
    EVENT_HOOK_DISABLED  = 2,
    EVENT_KEY_TYPED      = 3,
    EVENT_KEY_PRESSED    = 4,
    EVENT_KEY_RELEASED   = 5,
    EVENT_MOUSE_CLICKED  = 6,
    EVENT_MOUSE_PRESSED  = 7,
    EVENT_MOUSE_RELEASED = 8,
    EVENT_MOUSE_MOVED    = 9,
    EVENT_MOUSE_DRAGGED  = 10,
    EVENT_MOUSE_WHEEL    = 11
}

---@alias SCROLL_DIRECTION integer

---@class SCROLL_DIRECTIONS
---@field UP_DOWN SCROLL_DIRECTION Scrolls up and down.
---@field LEFT_RIGHT SCROLL_DIRECTION Scrolls left and right.

---@type SCROLL_DIRECTIONS
lua_uiohook.SCROLL_DIRECTIONS = {
    UP_DOWN = 3,
    LEFT_RIGHT = 4
}

---@alias SCROLL_ROTATION integer

---@class SCROLL_ROTATIONS
---@field UP SCROLL_ROTATION Scrolls up/left.
---@field DOWN SCROLL_ROTATION Scrolls down/right.

---@type SCROLL_ROTATIONS
lua_uiohook.SCROLL_ROTATIONS = {
    UP = -1,
    DOWN = 1
}

---@class KeyboardEventData
---@field keycode KEY_CODE
---@field rawcode integer
---@field keychar integer

---@class MouseEventData
---@field x integer
---@field y integer
---@field button integer

---@class MouseWheelEventData
---@field x integer
---@field y integer
---@field clicks integer
---@field type integer
---@field amount integer
---@field rotation integer
---@field direction integer

---@class InputEventData
---@field keyboard KeyboardEventData
---@field mouse MouseEventData
---@field wheel MouseWheelEventData

---@class InputEvent
---@field type EVENT_TYPE @ The type of event that was fired.
---@field time integer
---@field mask MODIFIER_MASK @ Modifier mask of the event.
---@field reserved integer
---@field data InputEventData

---@class EventListener
local event_listener_object = {}

--- Starts listening to input events.
function event_listener_object:connect() end

--- Stops listening to input events.
function event_listener_object:disconnect() end

--- Returns true if the listener is currently listening to events.
--- @return boolean
function event_listener_object:is_listening() end

--- Simulates a key press.
--- @param key_code KEY_CODE
--- @param mask MODIFIER_MASK|nil
function lua_uiohook.keyboard_press(key_code, mask) end

--- Simulates a key being held down.
--- @param key_code KEY_CODE
--- @param mask MODIFIER_MASK|nil
function lua_uiohook.keyboard_hold(key_code, mask) end

--- Releases a key that was being held down.
--- @param key_code KEY_CODE
--- @param mask MODIFIER_MASK|nil
function lua_uiohook.keyboard_release(key_code, mask) end

--- Gets the keyboard key repeat delay.
---@return integer
function lua_uiohook.get_auto_repeat_delay() end

--- Gets the keyboard key repeat rate.
---@return integer
function lua_uiohook.get_keyboard_repeat_rate() end

---@return integer
function lua_uiohook.get_multi_click_time() end

---@return integer
function lua_uiohook.get_pointer_acceleration_threshold() end

---@return integer
function lua_uiohook.get_pointer_acceleration_multiplier() end

---@return integer
function lua_uiohook.get_pointer_sensitivity() end

--- Simulates a mouse click
--- @param mouse_button MOUSE_BUTTON @The mouse button to use.
--- @param x integer|nil @The X coordinate of the click, if not specified, will use the current mouse X coordinate.
--- @param y integer|nil @The Y coordinate of the click, if not specified, will use the current mouse Y coordinate.
function lua_uiohook.mouse_press(mouse_button, x, y) end

--- Simulates a mouse hold
--- @param mouse_button MOUSE_BUTTON @The mouse button to use.
--- @param x integer|nil @The X coordinate of the click, if not specified, will use the current mouse X coordinate.
--- @param y integer|nil @The Y coordinate of the click, if not specified, will use the current mouse Y coordinate.
function lua_uiohook.mouse_hold(mouse_button, x, y) end

--- Releases the mouse from being held
--- @param mouse_button MOUSE_BUTTON @The mouse button to use.
--- @param x integer|nil @The X coordinate of the click, if not specified, will use the current mouse X coordinate.
--- @param y integer|nil @The Y coordinate of the click, if not specified, will use the current mouse Y coordinate.
function lua_uiohook.mouse_release(mouse_button, x, y) end

--- Gets the coordinates of the mouse pointer.
--- @return Coordinates
function lua_uiohook.get_mouse_coordinates() end

--- Moves the mouse pointer to the specified X and Y coordinates
--- @param x integer
--- @param y integer
function lua_uiohook.move_mouse(x, y) end

--- Scrolls the mouse.
--- @param amount integer|nil
--- @param direction SCROLL_DIRECTION|nil
--- @param rotation SCROLL_ROTATION|nil
function lua_uiohook.scroll_mouse(amount, direction, rotation) end

--- Returns a new event listener.
--- @param callback fun(event : InputEvent) @ The function to run every input event.
--- @return EventListener
function lua_uiohook.new_input_listener(callback) end

--- Returns the dimensions of the monitor specified in monitor_num.
--- @param monitor_number integer|nil @ Monitor number, keep in mind this is zero indexed, so the first monitor is 0 and so on.
--- @return Dimensions
function lua_uiohook.get_monitor_dimensions(monitor_number) end

--- Returns a string with the keyboard key name of the specified value.
--- @param value KEY_CODE
--- @return string|nil
function lua_uiohook.get_key_name_by_value(value) end

--- Returns a string with the event type name of the specified value.
--- @param value EVENT_TYPE
--- @return string|nil
function lua_uiohook.get_event_name_by_value(value) end

--- Returns a string with the modifier mask name of the specified value.
--- @param value MODIFIER_MASK
--- @return string|nil
function lua_uiohook.get_modifier_mask_name_by_value(value) end

--- Returns a string with the mouse button name of the specified value.
--- @param value MOUSE_BUTTON
--- @return string|nil
function lua_uiohook.get_mouse_button_name_by_value(value) end

--- Returns a string with the scroll rotation name of the specified value.
--- @param value SCROLL_ROTATION
--- @return string|nil
function lua_uiohook.get_scroll_rotation_name_by_value(value) end

--- Returns a string with the scroll direction name of the specified value.
--- @param value SCROLL_DIRECTION
--- @return string|nil
function lua_uiohook.get_scroll_direction_name_by_value(value) end

--- Sends an input event to the device.
--- It is recomended to only fill the fields you are going to use.
--- (If you're gonna send a MOUSE_MOVED event, only set the type of the event and the X and Y coordinates of the event.data.mouse)
--- @param event InputEvent The event data to send to the device
function lua_uiohook.post_event(event) end

return lua_uiohook
