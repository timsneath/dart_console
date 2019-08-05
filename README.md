Dart library for writing console applications. Developed with a Dart port
of the Kilo text editor in mind. May be missing key features for other
console applications :)

## Usage

This package uses FFI. Currently, I've wrapped the underlying system
calls I need from `glibc` into a single C file (termlib.c), which is
then wrapped with a Dart file (termlib.dart). The C file is commented
with instructions on how to create a shared library from it.

A simple usage example for the `dart_console` package:

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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/timsneath/dart_console/issues
