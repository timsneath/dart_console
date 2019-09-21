import 'dart:ffi';

import 'package:dart_console/src/ffi/termlib.dart';

import 'kernel.dart';

class TermLibWindows implements TermLib {
  DynamicLibrary kernel;

  getStdHandleDart GetStdHandle;
  getConsoleScreenBufferInfoDart GetConsoleScreenBufferInfo;
  setConsoleModeDart SetConsoleMode;
  setConsoleCursorInfoDart SetConsoleCursorInfo;

  int inputHandle, outputHandle;

  int getWindowHeight() {
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowHeight = bufferInfo.dwMaximumWindowSizeY;
    pBufferInfo.free();
    return windowHeight;
  }

  int getWindowWidth() {
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowWidth = bufferInfo.dwMaximumWindowSizeX;
    pBufferInfo.free();
    return windowWidth;
  }

  void enableRawMode() {
    int dwMode = (~ENABLE_ECHO_INPUT) &
        (~ENABLE_ECHO_INPUT) &
        (~ENABLE_PROCESSED_INPUT) &
        (~ENABLE_WINDOW_INPUT);
    SetConsoleMode(inputHandle, dwMode);
  }

  void disableRawMode() {
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

  void hideCursor() {
    Pointer<CONSOLE_CURSOR_INFO> lpConsoleCursorInfo =
        Pointer<CONSOLE_CURSOR_INFO>.allocate();
    CONSOLE_CURSOR_INFO consoleCursorInfo = lpConsoleCursorInfo.load();
    consoleCursorInfo.bVisible = 0;
    SetConsoleCursorInfo(outputHandle, lpConsoleCursorInfo);
    lpConsoleCursorInfo.free();
  }

  void showCursor() {
    Pointer<CONSOLE_CURSOR_INFO> lpConsoleCursorInfo =
        Pointer<CONSOLE_CURSOR_INFO>.allocate();
    CONSOLE_CURSOR_INFO consoleCursorInfo = lpConsoleCursorInfo.load();
    consoleCursorInfo.bVisible = 1;
    SetConsoleCursorInfo(outputHandle, lpConsoleCursorInfo);
    lpConsoleCursorInfo.free();
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
    SetConsoleCursorInfo = kernel.lookupFunction<setConsoleCursorInfoNative,
        setConsoleCursorInfoDart>("SetConsoleCursorInfo");

    outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    inputHandle = GetStdHandle(STD_INPUT_HANDLE);
  }
}
