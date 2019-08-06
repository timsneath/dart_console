import 'dart:io';

import 'ansi.dart';
import 'enums.dart';
import 'key.dart';
import 'ffi/termlib.dart';

class Coordinate {
  final int row;
  final int col;

  const Coordinate(int row, int col)
      : this.row = row,
        this.col = col;

  bool operator ==(dynamic other) =>
      other is Coordinate && row == other.row && col == other.col;
}

class Console {
  // We cache these values so we don't have to keep retrieving them. The
  // downside is that the class isn't dynamically responsive to a resized
  // console, but that's not unusual for console applications anyway.
  int _windowWidth = 0;
  int _windowHeight = 0;

  bool _rawMode = false;

  final termlib = TermLib();

  // Console options and screen information
  void enableRawMode() {
    _rawMode = true;
    termlib.enableRawMode();
  }

  void disableRawMode() {
    _rawMode = false;
    termlib.disableRawMode();
  }

  void clearScreen() =>
      stdout.write(ansiEraseInDisplayAll + ansiResetCursorPosition);

  void clearToLineEnd() => stdout.write(ansiEraseInLineRight);

  int get windowWidth {
    if (_windowWidth == 0) {
      // try using ioctl() to give us the screen size
      final width = termlib.getWindowWidth();
      if (width != -1) {
        _windowWidth = width;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition;
        stdout.write(ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition;
        cursorPosition = originalCursor;

        if (newCursor != null) {
          _windowWidth = newCursor.col;
        } else {
          // we've run out of options; terminal is unsupported
          throw Exception("Couldn't retrieve window width");
        }
      }
    }

    return _windowWidth;
  }

  int get windowHeight {
    if (_windowHeight == 0) {
      // try using ioctl() to give us the screen size
      final height = termlib.getWindowHeight();
      if (height != -1) {
        _windowHeight = height;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition;
        stdout.write(ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition;
        cursorPosition = originalCursor;

        if (newCursor != null) {
          _windowHeight = newCursor.row;
        } else {
          // we've run out of options; terminal is unsupported
          throw Exception("Couldn't retrieve window height");
        }
      }
    }

    return _windowHeight;
  }

  // Cursor settings
  void hideCursor() => stdout.write(ansiHideCursor);
  void showCursor() => stdout.write(ansiShowCursor);

  void cursorLeft() => stdout.write(ansiCursorLeft);
  void cursorRight() => stdout.write(ansiCursorRight);
  void cursorUp() => stdout.write(ansiCursorUp);
  void cursorDown() => stdout.write(ansiCursorDown);

  void resetCursorPosition() => stdout.write(ansiCursorPosition());

  Coordinate get cursorPosition {
    stdout.write(ansiDeviceStatusReportCursorPosition);
    // returns a Cursor Position Report result in the form <ESC>[24;80R
    // which we have to parse apart, unfortunately
    String result = '';
    int i = 0;

    // avoid infinite loop if we're getting a bad result
    while (i < 16) {
      result += String.fromCharCode(stdin.readByteSync());
      if (result.endsWith('R')) break;
      i++;
    }

    if (result[0] != '\x1b') return null;

    result = result.substring(2, result.length - 1);
    final coords = result.split(';');

    if (coords.length != 2) return null;
    if ((int.tryParse(coords[0]) != null) &&
        (int.tryParse(coords[1]) != null)) {
      return Coordinate(int.parse(coords[0]) - 1, int.parse(coords[1]) - 1);
    } else {
      return null;
    }
  }

  set cursorPosition(Coordinate cursor) {
    stdout.write(ansiCursorPosition(col: cursor.col + 1, row: cursor.row + 1));
  }

  // Printing text to the console
  void setForegroundColor(ConsoleColor foreground) {
    stdout.write(ansiSetColor(ansiForegroundColors[foreground]));
  }

  void setForegroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF,
        "Color must be a value between 0 and 255.");

    stdout.write(ansiSetExtendedForegroundColor(colorValue));
  }

  void setBackgroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF,
        "Color must be a value between 0 and 255.");

    stdout.write(ansiSetExtendedBackgroundColor(colorValue));
  }

  void setBackgroundColor(ConsoleColor background) {
    stdout.write(ansiSetColor(ansiBackgroundColors[background]));
  }

  void resetColorAttributes() => stdout.write(ansiResetColor);

  void write(String text) => stdout.write(text);

  void writeLine([String text]) {
    if (text != null) {
      stdout.write(text);
    }
    if (_rawMode) {
      stdout.write('\r\n');
    } else {
      stdout.write('\n');
    }
  }

  void writeAligned(String text, TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.center:
        final padding = ((windowWidth - text.length) / 2).round();
        text = text.padLeft(text.length + padding);
        text = text.padRight(windowWidth);
        break;
      case TextAlignment.right:
        text = text.padLeft(windowWidth);
        break;
      case TextAlignment.left:
        text = text.padRight(windowWidth);
    }
    writeLine(text);
  }

  // reading text from the keyboard
  Key readKey() {
    var key = Key();

    if (!_rawMode) enableRawMode();
    final codeUnit = stdin.readByteSync();
    if (codeUnit >= 0x00 && codeUnit <= 0x1f) {
      key.isControl = true;
      key.char = '';
      key.controlChar = ControlCharacter.Unknown;
    } else if (codeUnit == 0x7f) {
      key.isControl = true;
      key.char = '';
      key.controlChar = ControlCharacter.Backspace;
    } else {
      key.isControl = false;
      key.char = String.fromCharCode(codeUnit);
      key.controlChar = ControlCharacter.None;
    }
    if (!_rawMode) disableRawMode();
    return key;
  }
}
