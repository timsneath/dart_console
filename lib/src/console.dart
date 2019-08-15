// console.dart
//
// Contains the primary API for dart_console, exposed through the `Console`
// class.

import 'dart:io';

import 'ansi.dart';
import 'enums.dart';
import 'key.dart';
import 'ffi/termlib.dart';

/// A screen position, measured in rows and columns from the top-left origin
/// of the screen. Coordinates are zero-based, and converted as necessary
/// for the underlying system representation (e.g. one-based for VT-style
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

  final _termlib = TermLib();

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
      _termlib.enableRawMode();
    } else {
      _termlib.disableRawMode();
    }
  }

  /// Returns whether the terminal is in raw mode.
  ///
  /// There are a series of flags applied to a UNIX-like terminal that together
  /// constitute 'raw mode'. These flags turn off echoing of character input,
  /// processing of input signals like Ctrl+C, and output processing, as well as
  /// buffering of input until a full line is entered.
  bool get rawMode => _isRawMode;

  /// Clears the entire screen
  void clearScreen() =>
      stdout.write(ansiEraseInDisplayAll + ansiResetCursorPosition);

  /// Erases all the characters in the current line.
  void eraseLine() => stdout.write(ansiEraseInLineAll);

  /// Erases the current line from the cursor to the end of the line.
  void eraseCursorToEnd() => stdout.write(ansiEraseCursorToEnd);

  /// Returns the width of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window width, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid width from either method, the method
  /// throws an [Exception].
  int get windowWidth {
    if (_windowWidth == 0) {
      // try using ioctl() to give us the screen size
      final width = _termlib.getWindowWidth();
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

  /// Returns the height of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window height, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid height from either method, the method
  /// throws an [Exception].
  int get windowHeight {
    if (_windowHeight == 0) {
      // try using ioctl() to give us the screen size
      final height = _termlib.getWindowHeight();
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

  /// Hides the cursor.
  ///
  /// If you hide the cursor, you should take care to return the cursor to
  /// a visible status at the end of the program, even if it throws an
  /// exception, by calling the [showCursor] method.
  void hideCursor() => stdout.write(ansiHideCursor);

  /// Shows the cursor.
  void showCursor() => stdout.write(ansiShowCursor);

  /// Moves the cursor one position to the left.
  void cursorLeft() => stdout.write(ansiCursorLeft);

  /// Moves the cursor one position to the right.
  void cursorRight() => stdout.write(ansiCursorRight);

  /// Moves the cursor one position up.
  void cursorUp() => stdout.write(ansiCursorUp);

  /// Moves the cursor one position down.
  void cursorDown() => stdout.write(ansiCursorDown);

  /// Moves the cursor to the top left corner of the screen.
  void resetCursorPosition() => stdout.write(ansiCursorPosition(1, 1));

  /// Returns the current cursor position as a coordinate.
  ///
  /// Warning: Linux and macOS terminals report their cursor position by
  /// posting an escape sequence to stdin in response to a request. However,
  /// if there is lots of other keyboard input at the same time, some
  /// terminals may interleave that input in the response. There is no
  /// easy way around this; the recommendation is therefore to use this call
  /// before reading keyboard input, to get an original offset, and then
  /// track the local cursor independently based on keyboard input.
  ///
  ///
  Coordinate get cursorPosition {
    rawMode = true;
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
    rawMode = false;

    if (result[0] != '\x1b') {
      print(' result: $result  result.length: ${result.length}');
      return null;
    }

    result = result.substring(2, result.length - 1);
    final coords = result.split(';');

    if (coords.length != 2) {
      print(' coords.length: ${coords.length}');
      return null;
    }
    if ((int.tryParse(coords[0]) != null) &&
        (int.tryParse(coords[1]) != null)) {
      return Coordinate(int.parse(coords[0]) - 1, int.parse(coords[1]) - 1);
    } else {
      print(' coords[0]: ${coords[0]}   coords[1]: ${coords[1]}');
      return null;
    }
  }

  /// Sets the cursor to a specific coordinate.
  ///
  /// Coordinates are measured from the top left of the screen, and are
  /// zero-based.
  set cursorPosition(Coordinate cursor) {
    stdout.write(ansiCursorPosition(cursor.row + 1, cursor.col + 1));
  }

  /// Sets the console foreground color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [ConsoleColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void setForegroundColor(ConsoleColor foreground) {
    stdout.write(ansiSetColor(ansiForegroundColors[foreground]));
  }

  /// Sets the console background color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [ConsoleColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void setBackgroundColor(ConsoleColor background) {
    stdout.write(ansiSetColor(ansiBackgroundColors[background]));
  }

  /// Sets the foreground to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void setForegroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF,
        "Color must be a value between 0 and 255.");

    stdout.write(ansiSetExtendedForegroundColor(colorValue));
  }

  /// Sets the background to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void setBackgroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF,
        "Color must be a value between 0 and 255.");

    stdout.write(ansiSetExtendedBackgroundColor(colorValue));
  }

  /// Sets the text style.
  ///
  /// Note that not all styles may be supported by all terminals.
  void setTextStyle(
      {bool bold = false,
      bool underscore = false,
      bool blink = false,
      bool inverted = false}) {
    stdout.write(ansiSetTextStyles(
        bold: bold, underscore: underscore, blink: blink, inverted: inverted));
  }

  /// Resets all color attributes and text styles to the default terminal
  /// setting.
  void resetColorAttributes() => stdout.write(ansiResetColor);

  /// Writes the text to the console.
  void write(String text) => stdout.write(text);

  /// Returns the current newline string.
  String get newLine => _isRawMode ? '\r\n' : '\n';

  /// Writes a line to the console, optionally with alignment provided by the
  /// [TextAlignment] enumeration.
  ///
  /// If no parameters are supplied, the command simply writes a new line
  /// to the console. By default, text is left aligned.
  ///
  /// Text alignment operates based off the current window width, and pads
  /// the remaining characters with a space character.
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

  /// Reads a single key from the input, including a variety of control
  /// characters.
  ///
  /// Keys are represented by the [Key] class. Keys may be printable (if so,
  /// `Key.isControl` is `false`, and the `Key.char` property may be used to
  /// identify the key pressed. Non-printable keys have `Key.isControl` set
  /// to `true`, and if so the `Key.char` property is empty and instead the
  /// `Key.controlChar` property will be set to a value from the
  /// [ControlCharacter] enumeration that describes which key was pressed.
  ///
  /// Owing to the limitations of terminal key handling, certain keys may
  /// be represented by multiple control key sequences. An example showing
  /// basic key handling can be found in the `example/command_line.dart`
  /// file in the package source code.
  Key readKey() {
    var key;

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
