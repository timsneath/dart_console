import 'package:dart_console/dart_console.dart';

main() {
  final console = Console();
  console.writeLine('This console window has ${console.windowWidth} cols and '
      '${console.windowHeight} rows.');
}
