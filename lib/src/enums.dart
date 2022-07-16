// enums.dart

// Externally exposed enumerations used by the `Console` class.

// TODO: Update this with an enhanced enum that includes RGB and 256-color
// values, and returns a string to enable and a string to disable.

/// The named ANSI colors.
enum ConsoleColor {
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  brightBlack,
  brightRed,
  brightGreen,
  brightYellow,
  brightBlue,
  brightMagenta,
  brightCyan,
  brightWhite
}

/// Text alignments for line output.
enum TextAlignment { left, center, right }
