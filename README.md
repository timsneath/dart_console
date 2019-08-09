Dart library for writing console applications. Developed with 
[a Dart port of the Kilo text editor][dart_kilo] in mind. 
May be missing key features for other console applications :)

## Usage

This package uses [FFI][FFI], which is itself still in development.
In original versions, I wrapped the underlying system
calls I need from `stdlib` into a single C file (`termlib.c`), which was
then wrapped with a Dart file (`termlib.dart`). Now the package calls
into the stdlib library directly. 

This is only successfully tested on macOS; there are known problems on
Linux, and the equivalent system calls on Windows are not yet
implemented.

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

[dart_kilo]: https://github.com/timsneath/dart_kilo
[FFI]: https://dart.dev/server/c-interop
[tracker]: https://github.com/timsneath/dart_console/issues
