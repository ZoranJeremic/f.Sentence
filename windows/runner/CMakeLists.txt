cmake_minimum_required(VERSION 3.10)

project(runner LANGUAGES CXX)

# Set the output directory
set(BINARY_NAME "f_sentence")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/..")

# Define Flutter Windows embedding
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/..")
set(FLUTTER_WINDOWS_DIR "${FLUTTER_MANAGED_DIR}/..")
include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")

# Let CMake know where to find Flutter
set(FLUTTER_ROOT "$ENV{FLUTTER_ROOT}")
if(NOT FLUTTER_ROOT)
  message(FATAL_ERROR "FLUTTER_ROOT environment variable not set.")
endif()
execute_process(
  COMMAND "${FLUTTER_ROOT}/bin/flutter" --version
  RESULT_VARIABLE FLUTTER_RESULT
  OUTPUT_QUIET ERROR_QUIET
)
if(FLUTTER_RESULT)
  message(FATAL_ERROR "Flutter not found at FLUTTER_ROOT: ${FLUTTER_ROOT}")
endif()

# Build configuration
add_definitions(-DUNICODE -D_UNICODE)

# Add the executable
add_executable(${BINARY_NAME}
  "main.cpp"
  "runner.cpp"
  "runner.h"
  "resource.h"
  "flutter_window.cpp"
  "flutter_window.h"
  "utils.cpp"
  "utils.h"
)

# Link the Flutter engine and libraries
add_subdirectory("${FLUTTER_MANAGED_DIR}/flutter" "${CMAKE_CURRENT_BINARY_DIR}/flutter_build")

target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${FLUTTER_MANAGED_DIR}/flutter/include"
)

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_plugin)

# Copy necessary DLLs and data
add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${FLUTTER_MANAGED_DIR}/flutter/bin/cache/artifacts/engine/windows-x64/flutter_windows.dll"
    $<TARGET_FILE_DIR:${BINARY_NAME}>
)

# Enable High-DPI support
set_target_properties(${BINARY_NAME} PROPERTIES
  WIN32_EXECUTABLE TRUE
)
