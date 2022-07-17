// ansi.dart
//
// Contains ANSI escape sequences used by dart_console. Other classes should
// use these constants rather than embedding raw control codes.
//
// For more information on commonly-accepted ANSI mode control sequences, read
// https://vt100.net/docs/vt100-ug/chapter3.html.

const ansiDeviceStatusReportCursorPosition = '\x1b[6n';
const ansiEraseInDisplayAll = '\x1b[2J';
const ansiEraseInLineAll = '\x1b[2K';
const ansiEraseCursorToEnd = '\x1b[K';

const ansiHideCursor = '\x1b[?25l';
const ansiShowCursor = '\x1b[?25h';

const ansiCursorLeft = '\x1b[D';
const ansiCursorRight = '\x1b[C';
const ansiCursorUp = '\x1b[A';
const ansiCursorDown = '\x1b[B';

const ansiResetCursorPosition = '\x1b[H';
const ansiMoveCursorToScreenEdge = '\x1b[999C\x1b[999B';
String ansiCursorPosition(int row, int col) => '\x1b[$row;${col}H';

String ansiSetColor(int color) => '\x1b[${color}m';
String ansiSetExtendedForegroundColor(int color) => '\x1b[38;5;${color}m';
String ansiSetExtendedBackgroundColor(int color) => '\x1b[48;5;${color}m';
const ansiResetColor = '\x1b[m';

String ansiSetTextStyles(
    {bool bold = false,
    bool faint = false,
    bool italic = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
    bool invisible = false,
    bool strikethru = false}) {
  final styles = <int>[];
  if (bold) styles.add(1);
  if (faint) styles.add(2);
  if (italic) styles.add(3);
  if (underscore) styles.add(4);
  if (blink) styles.add(5);
  if (inverted) styles.add(7);
  if (invisible) styles.add(8);
  if (strikethru) styles.add(9);
  return '\x1b[${styles.join(";")}m';
}
