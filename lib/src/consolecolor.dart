// enums.dart

// Externally exposed enumerations used by the `Console` class.

// TODO: Update this with an enhanced enum that includes RGB and 256-color
// values, and returns a string to enable and a string to disable.

enum ConsoleColor {
  /// The named ANSI colors.
  black('\x1b[30m', '\x1b[40m'),
  red('\x1b[31m', '\x1b[41m'),
  green('\x1b[32m', '\x1b[42m'),
  yellow('\x1b[33m', '\x1b[43m'),
  blue('\x1b[34m', '\x1b[44m'),
  magenta('\x1b[35m', '\x1b[45m'),
  cyan('\x1b[36m', '\x1b[46m'),
  white('\x1b[37m', '\x1b[47m'),
  brightBlack('\x1b[90m', '\x1b[100m'),
  brightRed('\x1b[91m', '\x1b[101m'),
  brightGreen('\x1b[92m', '\x1b[102m'),
  brightYellow('\x1b[93m', '\x1b[103'),
  brightBlue('\x1b[94m', '\x1b[104m'),
  brightMagenta('\x1b[95m', '\x1b[105m'),
  brightCyan('\x1b[96m', '\x1b[106m'),
  brightWhite('\x1b[97m', '\x1b[107m');

  final String ansiSetForegroundColorSequence;
  final String ansiSetBackgroundColorSequence;

  const ConsoleColor(
      this.ansiSetForegroundColorSequence, this.ansiSetBackgroundColorSequence);
}
