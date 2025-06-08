#include "runner.h"

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int RunFlutterApp(HINSTANCE instance, wchar_t* command_line, int show_command) {
  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  flutter::DartProject project(L"data");
  project.set_dart_entrypoint_arguments(command_line_arguments);

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720); // Ovde menjaš dimenzije prozora

  if (!window.CreateAndShow(L"f.Sentence", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  return EXIT_SUCCESS;
}
