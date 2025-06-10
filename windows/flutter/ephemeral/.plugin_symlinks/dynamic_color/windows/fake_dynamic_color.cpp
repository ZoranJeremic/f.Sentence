// fake_dynamic_color.cpp
#include <windows.h>

// Ovo je samo dummy implementacija da ne bi build pucao
extern "C" __declspec(dllexport) void RegisterDynamicColorPlugin() {
  // ništa ne radi, ali build će proći
}
