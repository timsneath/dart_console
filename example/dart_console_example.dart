import 'package:dart_console/dart_console.dart';

main() {
  final console = Console();

  console.clearScreen();

  console.setBackgroundColor(ConsoleColor.blue);
  console.setForegroundColor(ConsoleColor.white);
  console.writeAligned(
      'Console size is ${console.windowWidth} cols and ${console.windowHeight} rows.',
      TextAlignment.center);
  console.writeLine();
  console.resetColorAttributes();

  console.writeAligned('Left aligned', TextAlignment.left);
  console.writeLine();
  console.writeAligned('Center aligned', TextAlignment.center);
  console.writeLine();
  console.writeAligned('Right aligned', TextAlignment.right);
  console.writeLine();

  for (ConsoleColor color in ConsoleColor.values) {
    console.setForegroundColor(color);
    console.writeLine(color.toString().split('.').last);
  }
  console.resetColorAttributes();

  console.writeLine();
  console.writeLine('Press any key to continue...');
  console.readKey();
  console.clearScreen();

  return 0;
}
