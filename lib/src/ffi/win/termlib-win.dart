// termlib-win.dart
//
// Win32-dependent library for interrogating and manipulating the console.
//
// This class provides raw wrappers for the underlying terminal system calls
// that are not available through ANSI mode control sequences, and is not
// designed to be called directly. Package consumers should normally use the
// `Console` class to call these methods.

import 'dart:ffi';

import 'package:dart_console/src/console-exception.dart';
import 'package:dart_console/src/ffi/termlib.dart';

import 'kernel32.dart';

/// Implementation of the TermLib interface for Windows consoles.
class TermLibWindows implements TermLib {
  DynamicLibrary kernel;

  getConsoleModeDart GetConsoleMode;
  getLastErrorDart GetLastError;
  getStdHandleDart GetStdHandle;
  getConsoleScreenBufferInfoDart GetConsoleScreenBufferInfo;
  setConsoleModeDart SetConsoleMode;
  setConsoleCursorInfoDart SetConsoleCursorInfo;
  setConsoleCursorPositionDart SetConsoleCursorPosition;
  fillConsoleOutputCharacterDart FillConsoleOutputCharacter;
  fillConsoleOutputAttributeDart FillConsoleOutputAttribute;

  int inputHandle, outputHandle;
  int dwOriginalInputMode, dwOriginalOutputMode;
  bool virtualTerminalSupport;

  /// Attempts to enable virtual terminal processing on Windows.
  ///
  /// VT terminal support is only available on modern consoles. Early versions
  /// of Windows 10 and earlier had no support, and a "legacy console" mode
  /// still exists on newer versions of Windows 10. If this is not available,
  /// we set a status flag so that downstream dependencies can take appropriate
  /// action.
  void initializeTerminal() {
    final lpInputMode = Pointer<Int32>.allocate();
    GetConsoleMode(inputHandle, lpInputMode);
    dwOriginalInputMode = lpInputMode.load();
    lpInputMode.free();

    final lpOutputMode = Pointer<Int32>.allocate();
    GetConsoleMode(outputHandle, lpOutputMode);
    dwOriginalOutputMode = lpOutputMode.load();
    lpOutputMode.free();

    // Per Microsoft docs, checking whether SetConsoleMode returns 0 and
    // GetLastError returns ERROR_INVALID_PARAMETER is the current mechanism
    // to determine when running on a down-level system that doesn't support
    // VT-style escape sequences.
    final dwOutMode = dwOriginalOutputMode | ENABLE_VIRTUAL_TERMINAL_PROCESSING;

    if (SetConsoleMode(outputHandle, dwOutMode) == 0) {
      final lastError = GetLastError();
      if (lastError == ERROR_INVALID_PARAMETER) {
        virtualTerminalSupport = false;
      } else {
        throw ConsoleException('Unable to set Windows console mode.');
      }
    } else {
      virtualTerminalSupport = true;
    }
  }

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
    final dwInputMode = dwOriginalInputMode &
        (~ENABLE_ECHO_INPUT) &
        (~ENABLE_LINE_INPUT) &
        (~ENABLE_PROCESSED_INPUT) &
        (~ENABLE_WINDOW_INPUT);

    SetConsoleMode(inputHandle, dwInputMode);
  }

  void disableRawMode() {
    // If not null, then enable has never been called and we have nothing to do
    if (dwOriginalInputMode != null) {
      SetConsoleMode(inputHandle, dwOriginalInputMode);
    }
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
    pBufferInfo.free();
  }

  void setCursorPosition(int x, int y) {
    SetConsoleCursorPosition(outputHandle, (y << 16) + x);
  }

  TermLibWindows() {
    kernel = DynamicLibrary.open('Kernel32.dll');

    GetConsoleMode =
        kernel.lookupFunction<getConsoleModeNative, getConsoleModeDart>(
            "GetConsoleMode");
    GetLastError = kernel
        .lookupFunction<getLastErrorNative, getLastErrorDart>("GetLastError");
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
    if ((outputHandle == INVALID_HANDLE_VALUE) ||
        (inputHandle == INVALID_HANDLE_VALUE)) {
      throw ConsoleException('Error: Unable to get handle');
    }

    initializeTerminal();
  }
}
