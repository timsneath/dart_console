## 1.1.2

- Remove ioctl and rely on ANSI escape sequences instead. Increases
  compatibility on non-interactive terminals and fixes ARM64 compatibility
  issue.

## 1.1.1

- Update some lints and platform specifications to satisfy pana.

## 1.1.0

- Add table class for tabulated text (and demo `example/table.dart`)
- Add calendar display, building on table primitives (and demo
  `example/calendar.dart`)
- Update to lints package and fix various issues.
- Add support for faint and strikethru font styles.
- Add support for testing whether the terminal supports emojis.
- Add support for resizing console window (thanks @FaFre)
- Add `writeAligned` function for center- and right-justified text.
- Fix error with forward deleting last character on a line (thanks
  @mhdolatabadi)
- Bump dependencies and support package:ffi 2.x
- Add lots of tests, including Github Actions automation.

## 1.0.0

- Support sound null safety and latest win32 and ffi dependencies.

## 0.6.2

- Bumped minver of win32

## 0.6.1

- Update to latest win32 package
- Add scrollback ignore option (thanks @averynortonsmith)
- Fix readme (thanks @md-weber)

## 0.6.0

- Shift all FFI code to the new [win32](https://pub.dev/packages/win32) package

## 0.5.0

- Add `writeErrorLine` function which writes to stderr
- *BREAKING*: Automatically print a new line to the console after every
  `readLine` input
- *BREAKING*: `readLine` now returns a null string, rather than an empty
  string, when Ctrl+Break or Escape are pressed.
- Add Game of Life example (thanks to @erf)

## 0.4.0

- Update to new FFI API

## 0.3.0

- Add support for Windows consoles that recognize ANSI escape sequences

## 0.2.0

- Add `readline` function and escape character support

## 0.1.0

- Initial version
