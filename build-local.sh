LUA_VERSION="5.5"
DEBUG="OFF"
if [ "$1" != "" ]; then
    LUA_VERSION="$1"
fi
if [ "$2" != "" ]; then
    DEBUG="$2"
fi

if [ -d "build" ]; then
    rm -rf build
fi

rm lua-uiohook/*
mkdir build

cmake -S . -B build -DLOCAL_INSTALL=ON -DLUA_VERSION=$LUA_VERSION -DDEBUG_MODE=$DEBUG
cmake --build build
cmake --install build