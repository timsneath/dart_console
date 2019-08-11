import 'dart:io';

import 'ansi.dart';
import 'enums.dart';
import 'key.dart';
import 'ffi/termlib.dart';

/// A screen position, measured in rows and columns from the top-left origin
/// of the screen. Coordinates are zero-based, and converted as necessary
/// for the underlying system representation (e.g. one-bsed for VT-style
/// displays).
class Coordinate {
  final int row;
  final int col;

  const Coordinate(this.row, this.col);
}

/// A representation of the current console window.
///
/// Use the [Console] to get information about the current window and to read
/// and write to it.
///
/// A comprehensive set of demos of using the Console class can be found in the
/// `demo.dart` file in the `examples/` subdirectory.
class Console {
  // We cache these values so we don't have to keep retrieving them. The
  // downside is that the class isn't dynamically responsive to a resized
  // console, but that's not unusual for console applications anyway.
  int _windowWidth = 0;
  int _windowHeight = 0;

  bool _isRawMode = false;

  final termlib = TermLib();

  /// Enables or disables raw mode.
  ///
  /// There are a series of flags applied to a UNIX-like terminal that together
  /// constitute 'raw mode'. These flags turn off echoing of character input,
  /// processing of input signals like Ctrl+C, and output processing, as well as
  /// buffering of input until a full line is entered.
  ///
  /// Raw mode is useful for console applications like text editors, which
  /// perform their own input and output processing, as well as for reading a
  /// single key from the input.
  ///
  /// If you use raw mode, you should disable it before your program returns, to
  /// avoid the console being left in a state unsuitable for interactive input.
  ///
  /// When raw mode is enabled, the newline command (`\n`) does not also perform
  /// a carriage return (`\r`). You can use the [newLine] property or the
  /// [writeLine] function instead of explicitly using `\n` to ensure the
  /// correct results.
  ///
  set rawMode(bool value) {
    this._isRawMode = value;
    if (value) {
      termlib.enableRawMode();
    } else {
      termlib.disableRawMode();
    }
  }

  bool get rawMode => _isRawMode;

  void clearScreen() =>
      stdout.write(ansiEraseInDisplayAll + ansiResetCursorPosition);

  void clearLine() => stdout.write(ansiEraseInLineAll);

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

  void resetCursorPosition() => stdout.write(ansiCursorPosition(1, 1));

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
    stdout.write(ansiCursorPosition(cursor.row + 1, cursor.col + 1));
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

  String get newLine => _isRawMode ? '\r\n' : '\n';

  void writeLine([String text, TextAlignment alignment]) {
    if (text != null) {
      switch (alignment) {
        case TextAlignment.center:
          final padding = ((windowWidth - text.length) / 2).round();
          text = text.padLeft(text.length + padding);
          text = text.padRight(windowWidth);
          break;
        case TextAlignment.right:
          text = text.padLeft(windowWidth);
          break;
        default:
      }
      stdout.write(text);
    }
    stdout.write(newLine);
  }

  // TODO: Ctrl+Q isn't working on Linux for some reason
  // reading text from the keyboard
  Key readKey() {
    var key;

    // if (!_isRawMode)
    rawMode = true;
    final codeUnit = stdin.readByteSync();
    if (codeUnit >= 0x01 && codeUnit <= 0x1a) {
      // Ctrl+A thru Ctrl+Z are mapped to the 1st-26th entries in the
      // enum, so it's easy to convert them across
      key = Key()
        ..isControl = true
        ..char = ''
        ..controlChar = ControlCharacter.values[codeUnit];
    } else if (codeUnit == 0x1b) {
      // escape sequence (e.g. \x1b[A for up arrow)
      key = Key()
        ..isControl = true
        ..char = '';

      final escapeSequence = <String>[];

      escapeSequence.add(String.fromCharCode(stdin.readByteSync()));
      escapeSequence.add(String.fromCharCode(stdin.readByteSync()));

      if (escapeSequence[0] == '[') {
        switch (escapeSequence[1]) {
          case 'A':
            key.controlChar = ControlCharacter.arrowUp;
            break;
          case 'B':
            key.controlChar = ControlCharacter.arrowDown;
            break;
          case 'C':
            key.controlChar = ControlCharacter.arrowRight;
            break;
          case 'D':
            key.controlChar = ControlCharacter.arrowLeft;
            break;
          case 'H':
            key.controlChar = ControlCharacter.home;
            break;
          case 'F':
            key.controlChar = ControlCharacter.end;
            break;
          default:
            if (escapeSequence[1].codeUnits[0] > '0'.codeUnits[0] &&
                escapeSequence[1].codeUnits[0] < '9'.codeUnits[0]) {
              escapeSequence.add(String.fromCharCode(stdin.readByteSync()));
              if (escapeSequence[2] != '~') {
                key.controlChar = ControlCharacter.unknown;
              } else {
                switch (escapeSequence[1]) {
                  case '1':
                    key.controlChar = ControlCharacter.home;
                    break;
                  case '3':
                    key.controlChar = ControlCharacter.delete;
                    break;
                  case '4':
                    key.controlChar = ControlCharacter.end;
                    break;
                  case '5':
                    key.controlChar = ControlCharacter.pageUp;
                    break;
                  case '6':
                    key.controlChar = ControlCharacter.pageDown;
                    break;
                  case '7':
                    key.controlChar = ControlCharacter.home;
                    break;
                  case '8':
                    key.controlChar = ControlCharacter.end;
                    break;
                  default:
                    key.controlChar = ControlCharacter.unknown;
                }
              }
            } else {
              key.controlChar = ControlCharacter.unknown;
            }
        }
      } else if (escapeSequence[0] == 'O') {
        switch (escapeSequence[1]) {
          case 'H':
            key.controlChar = ControlCharacter.home;
            break;
          case 'F':
            key.controlChar = ControlCharacter.end;
            break;
          default:
        }
      } else {
        key.controlChar = ControlCharacter.unknown;
      }
    } else if (codeUnit == 0x7f) {
      key = Key()
        ..isControl = true
        ..char = ''
        ..controlChar = ControlCharacter.backspace;
    } else if (codeUnit == 0x00 || (codeUnit >= 0x1c && codeUnit <= 0x1f)) {
      key = Key()
        ..isControl = true
        ..char = ''
        ..controlChar = ControlCharacter.unknown;
    } else {
      // assume other characters are printable
      key = Key()
        ..isControl = false
        ..char = String.fromCharCode(codeUnit)
        ..controlChar = ControlCharacter.none;
    }
    rawMode = false;
    return key;
  }
}
