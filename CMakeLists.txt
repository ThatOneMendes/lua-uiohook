cmake_minimum_required(VERSION 3.10)
project(lua_uiohook C)

# GETTING THE RIGHT LUA VERSION (5.3 in this case)

set(LUA_REQUESTED_VERSION 5.3)

find_package(PkgConfig QUIET)

if(PkgConfig_FOUND)
    pkg_check_modules(LUA_PC QUIET lua${LUA_REQUESTED_VERSION})
endif()

if(LUA_PC_FOUND)
    message(STATUS "Using Lua ${LUA_REQUESTED_VERSION} via pkg-config")

    set(LUA_INCLUDE_DIRS ${LUA_PC_INCLUDE_DIRS})
    set(LUA_LIBRARIES   ${LUA_PC_LIBRARIES})
else()
    message(WARNING "pkg-config not found or lua${LUA_REQUESTED_VERSION}.pc missing, falling back to FindLua")

    find_package(Lua ${LUA_REQUESTED_VERSION} EXACT REQUIRED)

    set(LUA_INCLUDE_DIRS ${LUA_INCLUDE_DIR})
    set(LUA_LIBRARIES   ${LUA_LIBRARIES})
endif()

message(STATUS "Lua includes: ${LUA_INCLUDE_DIRS}")
message(STATUS "Lua libs: ${LUA_LIBRARIES}")

# BUILDING LIBUIOHOOK

include(FetchContent)

set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "" FORCE)

FetchContent_Declare(
    libuiohook
    GIT_REPOSITORY https://github.com/kwhat/libuiohook.git
    GIT_TAG 1.2
)

FetchContent_MakeAvailable(libuiohook)

set_property(DIRECTORY ${libuiohook_SOURCE_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)
set_property(DIRECTORY ${libuiohook_BINARY_DIR} PROPERTY EXCLUDE_FROM_ALL TRUE)

# THE REST

set(SOURCES
    src/main.c
    src/event_list.c
    src/vector.c
)

add_library(uiohook_core MODULE ${SOURCES})

set_target_properties(uiohook_core PROPERTIES
    PREFIX ""
    OUTPUT_NAME "core"
)

if(WIN32)
    set_target_properties(uiohook_core PROPERTIES
        SUFFIX ".dll"
    )
endif()

target_include_directories(uiohook_core PRIVATE
    ${LUA_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/include
)

target_link_libraries(uiohook_core PRIVATE
    uiohook
    ${LUA_LIBRARIES}
)

install(TARGETS uiohook_core
    LIBRARY DESTINATION lib/lua/5.3/lua-uiohook
)

install(FILES
    src/lua/init.lua
    src/lua/constants.lua
    DESTINATION share/lua/5.3/lua-uiohook
)
