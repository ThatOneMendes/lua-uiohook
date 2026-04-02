param (
    [string]$LuaVersion = "5.4", # msys2 still hasn't updated its lua package to 5.5, oh well!
    [string]$DebugMode = "OFF"  # Default value
)

if ( Test-Path -Path build ) {
    Remove-Item -Recurse -Force build
}

Remove-Item -Path "lua-uiohook/*" -Recurse -Force
New-Item -ItemType Directory build

cmake -S . -B build -DLOCAL_INSTALL=ON -DLUA_VERSION="$LuaVersion" -DDEBUG_MODE="$DebugMode"
cmake --build build
cmake --install build