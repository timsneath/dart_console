// termlib-win.dart
//
// Win32-dependent library for interrogating and manipulating the console.
//
// This class provides raw wrappers for the underlying terminal system calls
// that are not available through ANSI mode control sequences, and is not
// designed to be called directly. Package consumers should normally use the
// `Console` class to call these methods.

import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi;
import 'package:win32/win32.dart';

import '../termlib.dart';

class TermLibWindows implements TermLib {
  DynamicLibrary kernel;

  int inputHandle, outputHandle;

  @override
  int getWindowHeight() {
    final pBufferInfo = ffi.allocate<CONSOLE_SCREEN_BUFFER_INFO>();
    var bufferInfo = pBufferInfo.ref;
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowHeight = bufferInfo.srWindowBottom - bufferInfo.srWindowTop + 1;
    ffi.free(bufferInfo.addressOf);
    return windowHeight;
  }

  @override
  int getWindowWidth() {
    final pBufferInfo = ffi.allocate<CONSOLE_SCREEN_BUFFER_INFO>();
    var bufferInfo = pBufferInfo.ref;
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowWidth = bufferInfo.srWindowRight - bufferInfo.srWindowLeft + 1;
    ffi.free(bufferInfo.addressOf);
    return windowWidth;
  }

  @override
  void enableRawMode() {
    final dwMode = (~ENABLE_ECHO_INPUT) &
        (~ENABLE_ECHO_INPUT) &
        (~ENABLE_PROCESSED_INPUT) &
        (~ENABLE_LINE_INPUT) &
        (~ENABLE_WINDOW_INPUT);
    SetConsoleMode(inputHandle, dwMode);
  }

  @override
  void disableRawMode() {
    final dwMode = ENABLE_ECHO_INPUT &
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
    final lpConsoleCursorInfo = ffi.allocate<CONSOLE_CURSOR_INFO>();
    var consoleCursorInfo = lpConsoleCursorInfo.ref;
    consoleCursorInfo.bVisible = 0;
    SetConsoleCursorInfo(outputHandle, lpConsoleCursorInfo);
    ffi.free(consoleCursorInfo.addressOf);
  }

  void showCursor() {
    final lpConsoleCursorInfo = ffi.allocate<CONSOLE_CURSOR_INFO>();
    var consoleCursorInfo = lpConsoleCursorInfo.ref;
    consoleCursorInfo.bVisible = 1;
    SetConsoleCursorInfo(outputHandle, lpConsoleCursorInfo);
    ffi.free(consoleCursorInfo.addressOf);
  }

  void clearScreen() {
    final pBufferInfo = ffi.allocate<CONSOLE_SCREEN_BUFFER_INFO>();
    var bufferInfo = pBufferInfo.ref;
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);

    final consoleSize = bufferInfo.dwSizeX * bufferInfo.dwSizeY;

    final pCharsWritten = ffi.allocate<Uint32>();
    FillConsoleOutputCharacter(
        outputHandle, ' '.codeUnitAt(0), consoleSize, 0, pCharsWritten);

    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);

    FillConsoleOutputAttribute(
        outputHandle, bufferInfo.wAttributes, consoleSize, 0, pCharsWritten);

    SetConsoleCursorPosition(outputHandle, 0);
    ffi.free(pCharsWritten);
  }

  void setCursorPosition(int x, int y) {
    SetConsoleCursorPosition(outputHandle, (y << 16) + x);
  }

  TermLibWindows() {
    kernel = DynamicLibrary.open('Kernel32.dll');

    outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    inputHandle = GetStdHandle(STD_INPUT_HANDLE);
  }
}
