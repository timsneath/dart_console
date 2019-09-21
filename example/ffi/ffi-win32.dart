// Doesn't work because of missing support for nested structs
// (https://github.com/dart-lang/sdk/issues/37271)

import 'dart:ffi';

const STD_INPUT_HANDLE = -10;
const STD_OUTPUT_HANDLE = -11;
const STD_ERROR_HANDLE = -12;

// HANDLE WINAPI GetStdHandle(
//   _In_ DWORD nStdHandle
// );
typedef getStdHandleNative = Int32 Function(Int32 nStdHandle);
typedef getStdHandleDart = int Function(int nStdHandle);

// BOOL WINAPI GetConsoleScreenBufferInfo(
//   _In_  HANDLE                      hConsoleOutput,
//   _Out_ PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo
// );
typedef getConsoleScreenBufferInfoNative = bool Function(Int32 hConsoleOutput,
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> lpConsoleScreenBufferInfo);
typedef getConsoleScreenBufferInfoDart = bool Function(int hConsoleOutput,
    Pointer<CONSOLE_SCREEN_BUFFER_INFO> lpConsoleScreenBufferInfo);

// typedef struct _CONSOLE_SCREEN_BUFFER_INFO {
//   COORD      dwSize;
//   COORD      dwCursorPosition;
//   WORD       wAttributes;
//   SMALL_RECT srWindow;
//   COORD      dwMaximumWindowSize;
// } CONSOLE_SCREEN_BUFFER_INFO;
class CONSOLE_SCREEN_BUFFER_INFO extends Struct<CONSOLE_SCREEN_BUFFER_INFO> {
  @Int32()
  COORD dwSize;

  @Int32()
  COORD dwCursorPosition;

  @Int16()
  int wAttributes;

  @Int64()
  SMALL_RECT srWindow;

  @Int32()
  COORD dwMaximumWindowSize;

  factory CONSOLE_SCREEN_BUFFER_INFO.allocate(
          COORD dwSize,
          COORD dwCursorPosition,
          int wAttributes,
          SMALL_RECT srWindow,
          COORD dwMaximumWindowSize) =>
      Pointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate()
          .load<CONSOLE_SCREEN_BUFFER_INFO>()
            ..dwSize = dwSize
            ..dwCursorPosition = dwCursorPosition
            ..wAttributes = wAttributes
            ..srWindow = srWindow
            ..dwMaximumWindowSize = dwMaximumWindowSize;
}

// typedef struct _COORD {
//   SHORT X;
//   SHORT Y;
// } COORD, *PCOORD;
class COORD extends Struct<COORD> {
  @Int16()
  int X;

  @Int16()
  int Y;
}

// typedef struct _SMALL_RECT {
//   SHORT Left;
//   SHORT Top;
//   SHORT Right;
//   SHORT Bottom;
// } SMALL_RECT;
class SMALL_RECT extends Struct<SMALL_RECT> {
  @Int16()
  int Left;

  @Int16()
  int Top;

  @Int16()
  int Right;

  @Int16()
  int Bottom;
}

main() {
  final DynamicLibrary win32 = DynamicLibrary.open('user32.dll');

  final GetStdHandle = win32
      .lookupFunction<getStdHandleNative, getStdHandleDart>("GetStdHandle");
  final GetConsoleScreenBufferInfo = win32.lookupFunction<
      getConsoleScreenBufferInfoNative,
      getConsoleScreenBufferInfoDart>("GetConsoleScreenBufferInfo");

  final outputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
  print(outputHandle);
}
