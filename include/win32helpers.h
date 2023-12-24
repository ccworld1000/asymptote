/**
 * @file win32helpers.h
 * @brief Windows-specific utility functions header
 * @author Supakorn "Jamie" Rassameemasmuang (jamievlin [at] outlook.com)
 */

#pragma once

#if defined(_WIN32)

#include <Windows.h>
#include "common.h"

namespace camp::w32
{

void checkResult(BOOL result, string const& message="");
void checkLStatus(LSTATUS result, string const& message="");

string buildWindowsCmd(const mem::vector<string>& command);

string getErrorMessage(DWORD const& errorCode);


/**
 * A simple wraper for <tt>HKEY</tt>
 */
class RegKeyWrapper
{
public:
  RegKeyWrapper(HKEY const& regKey);
  RegKeyWrapper();

  ~RegKeyWrapper();
  RegKeyWrapper(RegKeyWrapper const&) = delete;
  RegKeyWrapper& operator=(RegKeyWrapper const&) = delete;

  RegKeyWrapper(RegKeyWrapper&& other) noexcept;
  RegKeyWrapper& operator=(RegKeyWrapper&& other) noexcept;

  /**
   * @return The registry key held by the wrapper
   */
  [[nodiscard]]
  HKEY getKey() const;
  PHKEY put();

  void release();

private:
  void closeExistingKey();
  HKEY key;
};

class HandleRaiiWrapper
{
public:
    HandleRaiiWrapper() = default;
    HandleRaiiWrapper(HANDLE const& handle);
    ~HandleRaiiWrapper();

    HandleRaiiWrapper(HandleRaiiWrapper const&) = delete;
    HandleRaiiWrapper& operator=(HandleRaiiWrapper const&) = delete;

    HandleRaiiWrapper(HandleRaiiWrapper&& other) noexcept;

    // already hold a handle, should not consume another one
    HandleRaiiWrapper& operator=(HandleRaiiWrapper&& other) = delete;

    [[nodiscard]]
    HANDLE getHandle() const;

    LPHANDLE put();

private:
    HANDLE hd = nullptr;

};

} // namespace camp::w32

#endif