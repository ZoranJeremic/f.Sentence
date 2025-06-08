#ifndef UTILS_H_
#define UTILS_H_

#include <string>
#include <windows.h>

std::wstring Utf8ToWide(const std::string& utf8);
std::string WideToUtf8(const std::wstring& wide);

#endif  // UTILS_H_
