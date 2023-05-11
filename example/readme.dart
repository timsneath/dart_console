import 'package:dart_console/dart_console.dart';

int main() {
  final console = Console();

  console
    ..clearScreen()
    ..resetCursorPosition()
    ..writeLine(
      'Console size is ${console.windowWidth} cols and ${console.windowHeight} rows.',
      TextAlignment.center,
    )
    ..writeLine();

  return 0;
}
