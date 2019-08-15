A Dart library for building console applications.

[![pub package](https://img.shields.io/pub/v/dart_console.svg)](https://pub.dev/packages/dart_console)

This library contains a variety of useful functions for console application
development, including:

 - Reading the current window dimensions (height, width)
 - Reading and setting the cursor location
 - Setting foreground and background colors
 - Manipulating the console into "raw mode", which allows more advanced
   keyboard input processing than the default `dart:io` library.
 - Reading keys and control sequences from the keyboard
 - Writing aligned text to the screen

The library is being used to implement a Dart version of the [Kilo][kilo] text
editor, and is sufficient for a reasonably complete set of usage, including
`readline`-style CLI and basic text games.

The library assumes a VT-style terminal, as used by macOS and Linux. This
package does not currently work on Windows.

## Usage

A simple example for the `dart_console` package:
```dart
import 'package:dart_console/dart_console.dart';

main() {
  final console = Console();

  console.clearScreen();
  console.resetCursorPosition();

  console.writeAligned(
      'Console size is ${console.windowWidth} cols and ${console.windowHeight} rows.',
      TextAlignment.Center);
  console.writeLine();

  return 0;
}
```

More comprehensive demos of the Console class are included in the 
`example/demo.dart` and `example/command_line.dart` files.

## Other Notes

`dart_console` uses the new [FFI][FFI] capabilities in Dart 2.5 and later. As of
the time of writing (August 2019), this is not available in a stable release.
However, the package declares a dependency of Dart 2.4 so that `dartdoc` still
works. But don't be confused -- you need 2.5, which is currently available
in the `master` channel of Flutter or as a standalone download from the
[Dart SDK][dart] install page.

## Acknowledgements

Special thanks to [Matt Sullivan (@mjohnsullivan)][@mjohnsullivan] and 
[Samir Jindel (@sjindel-google)][@sjindel-google] for their help understanding
the vagaries of FFI in its early state.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[kilo]: https://github.com/antirez/kilo
[dart_kilo]: https://github.com/timsneath/dart_kilo
[FFI]: https://dart.dev/server/c-interop
[tracker]: https://github.com/timsneath/dart_console/issues
[@mjohnsullivan]: https://github.com/mjohnsullivan
[@sjindel-google]: https://github.com/sjindel-google
[dart]: https://dart.dev/get-dart