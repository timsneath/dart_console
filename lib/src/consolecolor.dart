// enums.dart

import 'dart:math' as math;

// Externally exposed enumerations used by the `Console` class.

class ConsoleColor {
  /// The named ANSI colors.
  static List<ConsoleColor> get ansiColors => <ConsoleColor>[
        ConsoleColor.black(),
        ConsoleColor.red(),
        ConsoleColor.green(),
        ConsoleColor.yellow(),
        ConsoleColor.blue(),
        ConsoleColor.magenta(),
        ConsoleColor.cyan(),
        ConsoleColor.white(),
        ConsoleColor.brightBlack(),
        ConsoleColor.brightRed(),
        ConsoleColor.brightGreen(),
        ConsoleColor.brightYellow(),
        ConsoleColor.brightBlue(),
        ConsoleColor.brightMagenta(),
        ConsoleColor.brightCyan(),
        ConsoleColor.brightWhite()
      ];

  factory ConsoleColor.black() => ConsoleColor('\x1b[30m', '\x1b[40m');
  factory ConsoleColor.red() => ConsoleColor('\x1b[31m', '\x1b[41m');
  factory ConsoleColor.green() => ConsoleColor('\x1b[32m', '\x1b[42m');
  factory ConsoleColor.yellow() => ConsoleColor('\x1b[33m', '\x1b[43m');
  factory ConsoleColor.blue() => ConsoleColor('\x1b[34m', '\x1b[44m');
  factory ConsoleColor.magenta() => ConsoleColor('\x1b[35m', '\x1b[45m');
  factory ConsoleColor.cyan() => ConsoleColor('\x1b[36m', '\x1b[46m');
  factory ConsoleColor.white() => ConsoleColor('\x1b[37m', '\x1b[47m');
  factory ConsoleColor.brightBlack() => ConsoleColor('\x1b[90m', '\x1b[100m');
  factory ConsoleColor.brightRed() => ConsoleColor('\x1b[91m', '\x1b[101m');
  factory ConsoleColor.brightGreen() => ConsoleColor('\x1b[92m', '\x1b[102m');
  factory ConsoleColor.brightYellow() => ConsoleColor('\x1b[93m', '\x1b[103');
  factory ConsoleColor.brightBlue() => ConsoleColor('\x1b[94m', '\x1b[104m');
  factory ConsoleColor.brightMagenta() => ConsoleColor('\x1b[95m', '\x1b[105m');
  factory ConsoleColor.brightCyan() => ConsoleColor('\x1b[96m', '\x1b[106m');
  factory ConsoleColor.brightWhite() => ConsoleColor('\x1b[97m', '\x1b[107m');

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
