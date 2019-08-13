import 'dart:ffi';
import 'dart:io';

// BOOL WINAPI GetConsoleScreenBufferInfoEx(
//     _In_ HANDLE hConsoleOutput,
//     _Out_ PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx);

// HANDLE WINAPI GetStdHandle(
//  _In_ DWORD nStdHandle
// );

// typedef struct _COORD {
//     SHORT X;
//     SHORT Y;
// } COORD, *PCOORD;

// typedef struct _SMALL_RECT {
//     SHORT Left;
//     SHORT Top;
//     SHORT Right;
//     SHORT Bottom;
// } SMALL_RECT, *PSMALL_RECT;

// typedef struct _CONSOLE_SCREEN_BUFFER_INFOEX
// {
//     ULONG cbSize;
//     COORD dwSize;
//     COORD dwCursorPosition;
//     WORD wAttributes;
//     SMALL_RECT srWindow;
//     COORD dwMaximumWindowSize;
//     WORD wPopupAttributes;
//     BOOL bFullscreenSupported;
//     COLORREF ColorTable[16];
// } CONSOLE_SCREEN_BUFFER_INFOEX, *PCONSOLE_SCREEN_BUFFER_INFOEX;

class COORD extends Struct<COORD> {
  @Int16()
  int X;
  @Int16()
  int Y;
}

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

class CONSOLE_SCREEN_BUFFER_INFOEX
    extends Struct<CONSOLE_SCREEN_BUFFER_INFOEX> {
  @Int32()
  int cbSize;

  COORD dwSize;

  COORD dwCursorPosition;

  @Int32()
  int wAttributes;

  SMALL_RECT srWindow;

  COORD dwMaximumWindowSize;

  @Int32()
  int wPopupAttributes;

  bool bFullscreenSupported;

  @Int32()
  int ColorTable0;
  @Int32()
  int ColorTable1;
  @Int32()
  int ColorTable2;
  @Int32()
  int ColorTable3;
  @Int32()
  int ColorTable4;
  @Int32()
  int ColorTable5;
  @Int32()
  int ColorTable6;
  @Int32()
  int ColorTable7;
  @Int32()
  int ColorTable8;
  @Int32()
  int ColorTable9;
  @Int32()
  int ColorTable10;
  @Int32()
  int ColorTable11;
  @Int32()
  int ColorTable12;
  @Int32()
  int ColorTable13;
  @Int32()
  int ColorTable14;
  @Int32()
  int ColorTable15;
}

class TermLib {
  int getWindowHeight() {
    return 0;
  }

  int getWindowWidth() {
    return 0;
  }

  void enableRawMode() {}

  void disableRawMode() {}

  TermLib() {
    if (Platform.isWindows) {}
  }
}
