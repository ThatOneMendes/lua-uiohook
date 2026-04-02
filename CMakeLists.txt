cmake_minimum_required(VERSION 3.10)
project(lua_uiohook C)

option(LUA_VERSION "The lua version to build against")
option(DEBUG_MODE "Enable debugging." OFF)
set(INSTALL_CORE lib/lua-uiohook)
set(INSTALL_FILES share/lua-uiohook)

if(LOCAL_INSTALL)
    set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR})
    set(INSTALL_CORE lua-uiohook)
    set(INSTALL_FILES lua-uiohook)
endif()

if(DEBUG_MODE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

find_package(PkgConfig QUIET)

if(PkgConfig_FOUND)
    pkg_check_modules(LUA_PC QUIET lua${LUA_VERSION})
endif()

if(LUA_PC_FOUND)
    message(STATUS "Using Lua ${LUA_VERSION} via pkg-config")

    set(LUA_INCLUDE_DIRS ${LUA_PC_INCLUDE_DIRS})
    set(LUA_LIBRARIES   ${LUA_PC_LIBRARIES})
else()
    message(WARNING "pkg-config not found or lua${LUA_VERSION}.pc missing, falling back to find_package")

    find_package(Lua ${LUA_VERSION} EXACT REQUIRED)

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
    src/wakeup.c
)

if(WIN32)
    add_library(uiohook_core SHARED ${SOURCES} src/lua_uiohook.def)
    set_target_properties(uiohook_core PROPERTIES
        PREFIX ""
        OUTPUT_NAME "core"
        SUFFIX ".dll"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lua-uiohook"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lua-uiohook"
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lua-uiohook"
    )
    target_link_libraries(uiohook_core PRIVATE
        uiohook
        ${LUA_LIBRARIES}
        user32
        kernel32
        gdi32
        advapi32
        pthread
    )
elseif(APPLE)
    add_library(uiohook_core SHARED ${SOURCES})
    set_target_properties(uiohook_core PROPERTIES
        PREFIX ""
        OUTPUT_NAME "core"
    )
    target_link_libraries(uiohook_core PRIVATE
        uiohook
        ${LUA_LIBRARIES}
        ApplicationServices
        pthread
    )
else()
    add_library(uiohook_core SHARED ${SOURCES})
    set_target_properties(uiohook_core PROPERTIES
        PREFIX ""
        OUTPUT_NAME "core"
    )
    target_link_libraries(uiohook_core PRIVATE
        uiohook
        ${LUA_LIBRARIES}
        X11
        pthread
    )
endif()

if(DEBUG_MODE)
    target_compile_definitions(uiohook_core PRIVATE DEBUG)
endif()

target_include_directories(uiohook_core PRIVATE
    ${LUA_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/include
)

install(TARGETS uiohook_core
    RUNTIME DESTINATION "${INSTALL_CORE}"
    LIBRARY DESTINATION "${INSTALL_CORE}"
    ARCHIVE DESTINATION "${INSTALL_CORE}"
)

if(LOCAL_INSTALL)
    install(FILES
        src/lua/init.lua
        src/lua/constants.lua
        DESTINATION "${INSTALL_FILES}"
    )
endif()