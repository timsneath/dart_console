// enums.dart

import 'dart:math' as math;

// Externally exposed enumerations used by the `Console` class.

class ConsoleColor {
  /// The named ANSI colors.
  static List<ConsoleColor> get values => <ConsoleColor>[
        ConsoleColor.black,
        ConsoleColor.red,
        ConsoleColor.green,
        ConsoleColor.yellow,
        ConsoleColor.blue,
        ConsoleColor.magenta,
        ConsoleColor.cyan,
        ConsoleColor.white,
        ConsoleColor.brightBlack,
        ConsoleColor.brightRed,
        ConsoleColor.brightGreen,
        ConsoleColor.brightYellow,
        ConsoleColor.brightBlue,
        ConsoleColor.brightMagenta,
        ConsoleColor.brightCyan,
        ConsoleColor.brightWhite
      ];

  static ConsoleColor get black => ConsoleColor('\x1b[30m', '\x1b[40m');
  static ConsoleColor get red => ConsoleColor('\x1b[31m', '\x1b[41m');
  static ConsoleColor get green => ConsoleColor('\x1b[32m', '\x1b[42m');
  static ConsoleColor get yellow => ConsoleColor('\x1b[33m', '\x1b[43m');
  static ConsoleColor get blue => ConsoleColor('\x1b[34m', '\x1b[44m');
  static ConsoleColor get magenta => ConsoleColor('\x1b[35m', '\x1b[45m');
  static ConsoleColor get cyan => ConsoleColor('\x1b[36m', '\x1b[46m');
  static ConsoleColor get white => ConsoleColor('\x1b[37m', '\x1b[47m');
  static ConsoleColor get brightBlack => ConsoleColor('\x1b[90m', '\x1b[100m');
  static ConsoleColor get brightRed => ConsoleColor('\x1b[91m', '\x1b[101m');
  static ConsoleColor get brightGreen => ConsoleColor('\x1b[92m', '\x1b[102m');
  static ConsoleColor get brightYellow => ConsoleColor('\x1b[93m', '\x1b[103');
  static ConsoleColor get brightBlue => ConsoleColor('\x1b[94m', '\x1b[104m');
  static ConsoleColor get brightMagenta =>
      ConsoleColor('\x1b[95m', '\x1b[105m');
  static ConsoleColor get brightCyan => ConsoleColor('\x1b[96m', '\x1b[106m');
  static ConsoleColor get brightWhite => ConsoleColor('\x1b[97m', '\x1b[107m');

  /// One of the 256 extended xterm colors.
  ///
  /// A grid showing the default colors can be found here:
  /// https://robotmoon.com/256-colors/
  ///
  /// Note that terminals may redefine the exact color specified by each color.
  factory ConsoleColor.xtermColor(int value) =>
      ConsoleColor('\x1b[38;5;${value}m', '\x1b[48;5;${value}m');

  /// A 24-bit color. Note that not all terminals can display 24-bit colors.
  factory ConsoleColor.fromRGB(int red, int green, int blue) => ConsoleColor(
      '\x1b[38;2;$red;$green;${blue}m', '\x1b[48;2;$red;$green;${blue}m');

  factory ConsoleColor.random() {
    final red = math.Random().nextInt(256);
    final green = math.Random().nextInt(256);
    final blue = math.Random().nextInt(256);

    return ConsoleColor.fromRGB(red, green, blue);
  }

  final String ansiSetForegroundColorSequence;
  final String ansiSetBackgroundColorSequence;

  const ConsoleColor(
      this.ansiSetForegroundColorSequence, this.ansiSetBackgroundColorSequence);
}
