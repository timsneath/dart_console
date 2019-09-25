// termlib-win.dart
//
// Win32-dependent library for interrogating and manipulating the console.
//
// This class provides raw wrappers for the underlying terminal system calls
// that are not available through ANSI mode control sequences, and is not
// designed to be called directly. Package consumers should normally use the
// `Console` class to call these methods.

import 'dart:ffi';

import 'package:dart_console/src/ffi/termlib.dart';

import 'kernel32.dart';

class TermLibWindows implements TermLib {
  DynamicLibrary kernel;

  getStdHandleDart GetStdHandle;
  getConsoleScreenBufferInfoDart GetConsoleScreenBufferInfo;
  setConsoleModeDart SetConsoleMode;
  setConsoleCursorInfoDart SetConsoleCursorInfo;
  setConsoleCursorPositionDart SetConsoleCursorPosition;
  fillConsoleOutputCharacterDart FillConsoleOutputCharacter;
  fillConsoleOutputAttributeDart FillConsoleOutputAttribute;

  int inputHandle, outputHandle;

  int getWindowHeight() {
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowHeight = bufferInfo.srWindowBottom - bufferInfo.srWindowTop + 1;
    pBufferInfo.free();
    return windowHeight;
  }

  int getWindowWidth() {
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);
    final windowWidth = bufferInfo.srWindowRight - bufferInfo.srWindowLeft + 1;
    pBufferInfo.free();
    return windowWidth;
  }

  void enableRawMode() {
    int dwMode = (~ENABLE_ECHO_INPUT) &
        (~ENABLE_ECHO_INPUT) &
        (~ENABLE_PROCESSED_INPUT) &
        (~ENABLE_LINE_INPUT) &
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

  void clearScreen() {
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> pBufferInfo =
        Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate();
    CONSOLE_SCREEN_BUFFER_INFO bufferInfo = pBufferInfo.load();
    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);

    final consoleSize = bufferInfo.dwSizeX * bufferInfo.dwSizeY;

    final pCharsWritten = Pointer<Int32>.allocate();
    FillConsoleOutputCharacter(
        outputHandle, ' '.codeUnitAt(0), consoleSize, 0, pCharsWritten);

    GetConsoleScreenBufferInfo(outputHandle, pBufferInfo);

    FillConsoleOutputAttribute(
        outputHandle, bufferInfo.wAttributes, consoleSize, 0, pCharsWritten);

    SetConsoleCursorPosition(outputHandle, 0);
    pCharsWritten.free();
  }

  void setCursorPosition(int x, int y) {
    SetConsoleCursorPosition(outputHandle, (y << 16) + x);
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
    SetConsoleCursorPosition = kernel.lookupFunction<
        setConsoleCursorPositionNative,
        setConsoleCursorPositionDart>("SetConsoleCursorPosition");
    FillConsoleOutputCharacter = kernel.lookupFunction<
        fillConsoleOutputCharacterNative,
        fillConsoleOutputCharacterDart>("FillConsoleOutputCharacterA");
    FillConsoleOutputAttribute = kernel.lookupFunction<
        fillConsoleOutputAttributeNative,
        fillConsoleOutputAttributeDart>("FillConsoleOutputAttribute");

    outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    inputHandle = GetStdHandle(STD_INPUT_HANDLE);
  }
}
