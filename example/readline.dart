import 'package:dart_console/dart_console.dart';

final console = Console();

main() {
  console.setForegroundColor(ConsoleColor.brightYellow);
  console.write("console.readLine");
  console.resetColorAttributes();
  console.writeLine(
      " provides a basic readline implementation that handles cursor navigation.");
  console.writeLine();
  console.write("Enter some text: ");
  final response = console.readLine();

  console.writeLine();
  console.writeLine("You wrote: $response");
}
