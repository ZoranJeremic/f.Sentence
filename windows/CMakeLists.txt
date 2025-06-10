cmake_minimum_required(VERSION 3.10)

project(f_sentence LANGUAGES CXX)

# Ručno definiši flutter dir ako ne koristiš standardnu putanju
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Uključi pluginove
if(EXISTS "${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")
  include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")
endif()

# Dodaj folder za build aplikacije
add_subdirectory("runner")
