package = "lua-uiohook"
version = "1.0-0"
source = {
   url = "file://."
}
description = {
   summary = "Lua bindings for libuiohook",
   detailed  = [[
      A module that adds bindings to libuiohook, a cross-platform keyboard and mouse hooking library.
   ]],
   license = "GPLv3"
}
dependencies = {
   "lua = 5.3"
}
rockspec_format = "3.0"

external_dependencies = {
   UIOHOOK = { header = "uiohook.h", library = "uiohook" }
}

build = {
   type = "builtin",
   modules = {
      ["lua-uiohook"] = "src/lua/init.lua",
      ["lua-uiohook.constants"] = "src/lua/constants.lua",
      ["lua-uiohook.core"] = {
         incdirs = {
            "src/include/",
            "$(LUA_INCDIR)",
         },
         libdirs = {
            "$(LIBDIR)",
            "$(LUA_LIBDIR)",
            "$(UIOHOOK_LIBDIR)"
         },
         libraries = {
            unix = {"X11"},
            macosx = {"ApplicationServices"},
            windows = {"winuser"},
            "pthread",
            "uiohook"
         },
         sources = {"src/event_list.c", "src/vector.c", "src/main.c"}
      }
   },
   copy_directories = { "docs" },
   platforms = {
      windows = {
         variables = {
            CC = "gcc", LD = "gcc", AR = "ar"
         }
      }
   }
}
