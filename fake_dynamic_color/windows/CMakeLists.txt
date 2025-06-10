# Minimal fake plugin CMake for Windows
cmake_minimum_required(VERSION 3.15)

project(fake_dynamic_color)

add_library(fake_dynamic_color SHARED
  fake_dynamic_color.cpp
)

# No real code, so nothing else to do
