cmake_minimum_required(VERSION 3.1)

project(heapsapp)

include_directories(build/libs/hashlink/src)

# LibHL

file(GLOB libhl
    build/libs/hashlink/src/std/*.c
	build/libs/hashlink/src/alloc.c
	build/libs/hashlink/src/gc.c
)
list(REMOVE_ITEM libhl ${CMAKE_CURRENT_SOURCE_DIR}/build/libs/hashlink/src/std/debug.c)

file(GLOB pcre build/libs/hashlink/include/pcre/pcre*.c)

add_library(hl STATIC
	${pcre}
	${libhl}
    build/libs/hashlink/src/std/sys_android.c
)

target_include_directories(hl PRIVATE build/libs/hashlink/include/pcre)
target_link_libraries(hl log)

# FMT

set(TJ_LIB ${CMAKE_CURRENT_SOURCE_DIR}/build/libs/libjpeg-turbo/obj/local/${ANDROID_ABI}/libjpeg-turbo.a)
add_custom_target(turbojpeg
	${ANDROID_NDK}/ndk-build APP_ABI=${ANDROID_ABI} APP_PLATFORM=${ANDROID_PLATFORM}
	NDK_PROJECT_PATH=./build/libs/libjpeg-turbo
	WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
	BYPRODUCTS ${TJ_LIB}
)

file(GLOB fmt build/libs/hashlink/libs/fmt/*.c)
file(GLOB png build/libs/hashlink/include/png/*.c)
file(GLOB zlib build/libs/hashlink/include/zlib/*.c)
file(GLOB vorbis build/libs/hashlink/include/vorbis/*.c)
file(GLOB mikkt build/libs/hashlink/include/mikktspace/*.c)
file(GLOB minimp3 build/libs/hashlink/include/minimp3/*.c)

add_library(fmt.hdll STATIC
	${fmt}
	${png}
	${zlib}
	${vorbis}
	${mikkt}
)

add_dependencies(fmt.hdll turbojpeg)
file(GLOB tj_include build/libs/libjpeg-turbo/jni/vendor/libjpeg-turbo/libjpeg-turbo-*)
target_link_libraries(fmt.hdll ${TJ_LIB})
target_compile_definitions(fmt.hdll PRIVATE PNG_ARM_NEON_OPT=0) #disable Neon support for now

target_include_directories(fmt.hdll PRIVATE
	build/libs/hashlink/include/png
	build/libs/hashlink/include/mikktspace
	build/libs/hashlink/include/minimp3
	build/libs/hashlink/include/vorbis
	build/libs/hashlink/include/zlib
	${tj_include}
)

# SDL

add_subdirectory(build/libs/sdl2)
file(GLOB sdl build/libs/hashlink/libs/sdl/*.c)
add_library(sdl.hdll STATIC ${sdl})
target_include_directories(sdl.hdll PUBLIC sdl2/include)
target_link_libraries(sdl.hdll SDL2 SDL2main EGL GLESv3)

# OpenAL

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/build/libs/openal-nativetools/CMakeLists.txt ${CMAKE_CURRENT_SOURCE_DIR}/build/libs/openal-soft COPYONLY)
add_subdirectory(build/libs/openal-soft)
file(GLOB openal build/libs/hashlink/libs/openal/*.c)
add_library(openal.hdll STATIC ${openal})
target_include_directories(openal.hdll PUBLIC build/libs/openal-soft/include)
target_link_libraries(openal.hdll OpenAL)

# UI

file(GLOB ui build/libs/hashlink/libs/ui/ui_stub.c)
add_library(ui.hdll STATIC ${ui})

# Android

find_library(android-lib android)

# Heaps Application

add_library(heapsapp SHARED src/haxe/main.c src/main/pony.c src/main/jni.c)
target_include_directories(heapsapp PRIVATE src/haxe)
target_link_libraries(heapsapp ${android-lib} hl sdl.hdll fmt.hdll openal.hdll ui.hdll)
