local EVENT_TYPES = {
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

local MOUSE_BUTTON = {
    MOUSE_NOBUTTON =                             0,
    MOUSE_BUTTON1  =                             1,
    MOUSE_BUTTON2  =                             3,
    MOUSE_BUTTON3  =                             2
}

local MODIFIER_MASKS = {
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

local KEY_CODES = {
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

local SCROLL_DIRECTIONS = {
    UP_DOWN = 3,
    LEFT_RIGHT = 4
}

local SCROLL_ROTATIONS = {
    UP = -1,
    DOWN = 1
}

return {
    ["EVENT_TYPES"] = EVENT_TYPES,
    ["KEY_CODES"] = KEY_CODES,
    ["MODIFIER_MASKS"] = MODIFIER_MASKS,
    ["MOUSE_BUTTON"] = MOUSE_BUTTON,
    ["SCROLL_DIRECTIONS"] = SCROLL_DIRECTIONS,
    ["SCROLL_ROTATIONS"] = SCROLL_ROTATIONS
}