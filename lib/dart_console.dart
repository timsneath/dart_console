// dart_console.dart

/// Console library.
///
/// Provides enhanced console capabilities for a CLI application that wants to
/// do more than write plain text to stdout.
///
/// ## Console manipulation
///
/// The [Console] class provides simple methods to control the cursor position,
/// hide the cursor, change the foreground or background color, clear the
/// terminal display, read individual keys without echoing to the terminal,
/// erase text and write aligned text to the screen.
///
/// ## Table display
///
/// The [Table] class allows two-dimensional data sets to be displayed in a
/// tabular form, with headers, custom box characters and line drawing, row and
/// column formatting and manipulation.
///
/// ## Calendar
///
/// The [Calendar] class displays a monthly calendar, with options for
/// controlling color and whether the current date is highlighted.
///
/// ## Progress Bar
///
/// The [ProgressBar] class presents a progress bar for long-running operations,
/// optionally including a spinner. It supports headless displays (where it is
/// silent), as well as interactive consoles, and can be adjusted for custom
/// presentation.
///
/// The class works on any desktop environment that supports ANSI escape
/// characters, and has some fallback capabilities for older versions of Windows
/// that use traditional console APIs.
library dart_console;

export 'src/calendar.dart';
export 'src/console.dart';
export 'src/consolecolor.dart';
export 'src/key.dart';
export 'src/progressbar.dart';
export 'src/scrollbackbuffer.dart';
export 'src/string_utils.dart';
export 'src/table.dart';
export 'src/textalignment.dart';
