package = "lua-uiohook"
version = "1.1-0"
source = {
   url = "git://github.com/ThatOneMendes/lua-uiohook.git",
   tag = "v1.1-0"
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

build = {
   type = "cmake",
   copy_directories = { "docs" },
   platforms = {
      windows = {
         variables = {
            CC = "gcc", LD = "gcc", AR = "ar"
         }
      }
   }
}
