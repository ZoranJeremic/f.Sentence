cmake_minimum_required(VERSION 3.10)

# Set project name and version
project(f_sentence)

# Define the Windows build
set(BUILD_WINDOWS TRUE)

# Set the Flutter directory
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Include Flutter
include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")

# Add the runner
add_subdirectory("runner")
