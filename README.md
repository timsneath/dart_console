Dart library for writing console applications. Developed with 
[a Dart port of the Kilo text editor][dart_kilo] in mind. 
May be missing key features for other console applications :)

## Usage

This package uses [FFI][FFI], which is itself still in development.

This is successfully tested on macOS; there are known problems on
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

A more comprehensive set of demos of the Console class are included in the 
`example/demo.dart` file.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[dart_kilo]: https://github.com/timsneath/dart_kilo
[FFI]: https://dart.dev/server/c-interop
[tracker]: https://github.com/timsneath/dart_console/issues
