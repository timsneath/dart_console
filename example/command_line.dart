// command_line.dart
//
// Demonstrates a simple command-line interface that does not require line
// editing services from the shell.

import 'dart:io';
import 'dart:math' show min, max;

import 'package:dart_console/dart_console.dart';

final console = Console();

// Adapted from
// http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// as a test of the Console class capabilities
main() {
  String input = '';
  int index = 0;
  Key key;

  console.writeLine("Command-line reader, which 'shouts' all text back.");
  console.write('>>> ');

  while (true) {
    key = console.readKey();

    if (!key.isControl) {
      input = input.substring(0, index) + key.char + input.substring(index);
      index++;
      console.write(key.char);
    } else {
      switch (key.controlChar) {
        case ControlCharacter.ctrlC:
          exit(0);
          break;
        case ControlCharacter.arrowLeft:
          index = max(0, index - 1);
          final cursor = console.cursorPosition;
          console.cursorPosition = Coordinate(cursor.row, index);
          break;
        case ControlCharacter.arrowRight:
          index = min(input.length, index + 1);
          final cursor = console.cursorPosition;
          console.cursorPosition = Coordinate(cursor.row, index);
          break;
        case ControlCharacter.enter:
          console.writeLine();
          console.writeLine('YOU SAID: ${input.toUpperCase()}');
          console.writeLine();

          input = '';
          index = 0;
          console.write('>>> ');
          break;
        default:
        // Ignore
      }
    }
  }
}
