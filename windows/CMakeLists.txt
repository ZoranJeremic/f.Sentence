cmake_minimum_required(VERSION 3.10)

project(f_sentence)

set(BUILD_WINDOWS TRUE)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

include(${FLUTTER_SOURCE_DIR}/packages/flutter_tools/bin/utils.cmake)

include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")

add_subdirectory("runner")
