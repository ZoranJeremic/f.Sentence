#include "flutter_window.h"

FlutterWindow::FlutterWindow() : window_(nullptr) {}

FlutterWindow::~FlutterWindow() {}

HWND FlutterWindow::CreateAndShow(const wchar_t* title, int width, int height, HINSTANCE instance, int show_command) {
  WNDCLASS wc = {0};
  wc.lpfnWndProc = DefWindowProc;
  wc.hInstance = instance;
  wc.lpszClassName = L"FlutterWindowClass";

  RegisterClass(&wc);

  window_ = CreateWindow(
      wc.lpszClassName, title,
      WS_OVERLAPPEDWINDOW | WS_VISIBLE,
      CW_USEDEFAULT, CW_USEDEFAULT,
      width, height,
      nullptr, nullptr,
      instance, nullptr);

  ShowWindow(window_, show_command);
  UpdateWindow(window_);

  return window_;
}

void FlutterWindow::OnDestroy() {
  PostQuitMessage(0);
}

LRESULT FlutterWindow::MessageHandler(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  switch (message) {
    case WM_DESTROY:
      OnDestroy();
      return 0;
    default:
      return DefWindowProc(hwnd, message, wparam, lparam);
  }
}
