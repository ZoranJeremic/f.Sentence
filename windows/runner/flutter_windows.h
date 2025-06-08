#ifndef FLUTTER_WINDOW_H_
#define FLUTTER_WINDOW_H_

#include <windows.h>

class FlutterWindow {
 public:
  FlutterWindow();
  virtual ~FlutterWindow();

  HWND CreateAndShow(const wchar_t* title, int width, int height, HINSTANCE instance, int show_command);
  virtual void OnDestroy();
  virtual LRESULT MessageHandler(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);

 protected:
  HWND window_;
};

#endif  // FLUTTER_WINDOW_H_
