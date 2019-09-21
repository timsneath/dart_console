import 'dart:ffi';

import 'package:dart_console/src/ffi/termlib.dart';

import 'kernel.dart';

class TermLibWindows implements TermLib {
  DynamicLibrary kernel;

  getStdHandleDart GetStdHandle;
  getConsoleScreenBufferInfoDart GetConsoleScreenBufferInfo;
  setConsoleModeDart SetConsoleMode;

  int getWindowHeight() {
    final outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);

    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    return bufferInfo.dwMaximumWindowSizeY;
  }

  int getWindowWidth() {
    final outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);

    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    return bufferInfo.dwMaximumWindowSizeX;
  }

  void enableRawMode() {
    final inputHandle = GetStdHandle(STD_INPUT_HANDLE);

    int dwMode = (~ENABLE_ECHO_INPUT) &
        (~ENABLE_ECHO_INPUT) &
        (~ENABLE_PROCESSED_INPUT) &
        (~ENABLE_WINDOW_INPUT);
    SetConsoleMode(inputHandle, dwMode);
  }

  void disableRawMode() {
    final inputHandle = GetStdHandle(STD_INPUT_HANDLE);

    int dwMode = ENABLE_ECHO_INPUT &
        ENABLE_EXTENDED_FLAGS &
        ENABLE_INSERT_MODE &
        ENABLE_LINE_INPUT &
        ENABLE_MOUSE_INPUT &
        ENABLE_PROCESSED_INPUT &
        ENABLE_QUICK_EDIT_MODE &
        ENABLE_VIRTUAL_TERMINAL_INPUT;
    SetConsoleMode(inputHandle, dwMode);
  }

  TermLibWindows() {
    kernel = DynamicLibrary.open('Kernel32.dll');

    GetStdHandle = kernel
        .lookupFunction<getStdHandleNative, getStdHandleDart>("GetStdHandle");
    GetConsoleScreenBufferInfo = kernel.lookupFunction<
        getConsoleScreenBufferInfoNative,
        getConsoleScreenBufferInfoDart>("GetConsoleScreenBufferInfo");
    SetConsoleMode =
        kernel.lookupFunction<setConsoleModeNative, setConsoleModeDart>(
            "SetConsoleMode");
  }
}
