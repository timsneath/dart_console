import 'package:dart_console/src/enums.dart';
import 'package:dart_console/src/ffi/win/kernel32.dart';

const winForegroundColors = {
  ConsoleColor.black: 0,
  ConsoleColor.red: FOREGROUND_RED,
  ConsoleColor.green: FOREGROUND_GREEN,
  ConsoleColor.yellow: FOREGROUND_RED | FOREGROUND_GREEN,
  ConsoleColor.blue: FOREGROUND_BLUE,
  ConsoleColor.magenta: FOREGROUND_RED | FOREGROUND_BLUE,
  ConsoleColor.cyan: FOREGROUND_GREEN | FOREGROUND_BLUE,
  ConsoleColor.white: FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE,
  ConsoleColor.brightBlack: FOREGROUND_INTENSITY,
  ConsoleColor.brightRed: FOREGROUND_INTENSITY | FOREGROUND_RED,
  ConsoleColor.brightGreen: FOREGROUND_INTENSITY | FOREGROUND_GREEN,
  ConsoleColor.brightYellow:
      FOREGROUND_INTENSITY | FOREGROUND_RED | FOREGROUND_GREEN,
  ConsoleColor.brightBlue: FOREGROUND_INTENSITY | FOREGROUND_BLUE,
  ConsoleColor.brightMagenta:
      FOREGROUND_INTENSITY | FOREGROUND_RED | FOREGROUND_BLUE,
  ConsoleColor.brightCyan:
      FOREGROUND_INTENSITY | FOREGROUND_GREEN | FOREGROUND_BLUE,
  ConsoleColor.brightWhite: FOREGROUND_INTENSITY |
      FOREGROUND_RED |
      FOREGROUND_GREEN |
      FOREGROUND_BLUE,
};

const winBackgroundColors = {
  ConsoleColor.black: 0,
  ConsoleColor.red: BACKGROUND_RED,
  ConsoleColor.green: BACKGROUND_GREEN,
  ConsoleColor.yellow: BACKGROUND_RED | BACKGROUND_GREEN,
  ConsoleColor.blue: BACKGROUND_BLUE,
  ConsoleColor.magenta: BACKGROUND_RED | BACKGROUND_BLUE,
  ConsoleColor.cyan: BACKGROUND_GREEN | BACKGROUND_BLUE,
  ConsoleColor.white: BACKGROUND_RED | BACKGROUND_GREEN | BACKGROUND_BLUE,
  ConsoleColor.brightBlack: BACKGROUND_INTENSITY,
  ConsoleColor.brightRed: BACKGROUND_INTENSITY | BACKGROUND_RED,
  ConsoleColor.brightGreen: BACKGROUND_INTENSITY | BACKGROUND_GREEN,
  ConsoleColor.brightYellow:
      BACKGROUND_INTENSITY | BACKGROUND_RED | BACKGROUND_GREEN,
  ConsoleColor.brightBlue: BACKGROUND_INTENSITY | BACKGROUND_BLUE,
  ConsoleColor.brightMagenta:
      BACKGROUND_INTENSITY | BACKGROUND_RED | BACKGROUND_BLUE,
  ConsoleColor.brightCyan:
      BACKGROUND_INTENSITY | BACKGROUND_GREEN | BACKGROUND_BLUE,
  ConsoleColor.brightWhite: BACKGROUND_INTENSITY |
      BACKGROUND_RED |
      BACKGROUND_GREEN |
      BACKGROUND_BLUE,
};
