cmake_minimum_required(VERSION 3.10)

project(dynamic_color)

add_library(dynamic_color STATIC
  fake_dynamic_color.cpp
)

target_include_directories(dynamic_color PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

# Ručno setujemo ono što apply_standard_settings inače radi
set_target_properties(dynamic_color PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED YES
  CXX_EXTENSIONS NO
)

target_link_libraries(dynamic_color flutter flutter_wrapper_plugin)
