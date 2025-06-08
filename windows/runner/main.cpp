#include <windows.h>

#include "runner.h"

int APIENTRY wWinMain(HINSTANCE instance, HINSTANCE prev, wchar_t* command_line, int show_command) {
  return RunFlutterApp(instance, command_line, show_command);
}
