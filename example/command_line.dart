// command_line.dart
//
// Demonstrates a simple command-line interface that does not require line
// editing services from the shell.

import 'dart:io';
import 'dart:math' show min, max;

import 'package:dart_console/dart_console.dart';

final console = Console();

const prompt = '>>> ';

// Inspired by
// http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// as a test of the Console class capabilities
main() {
  String input = '';
  int index = 0;
  Key key;

  Coordinate cursorPosition;

  console.writeLine("Command-line reader, which 'shouts' all text back.");
  console.writeLine("Press Ctrl+C to exit.");
  console.write(prompt);
  cursorPosition = console.cursorPosition;

  while (true) {
    key = console.readKey();

    if (!key.isControl) {
      input = input.substring(0, index) + key.char + input.substring(index);
      index++;
    } else {
      switch (key.controlChar) {
        case ControlCharacter.ctrlC:
          exit(0);
          break;
        case ControlCharacter.arrowLeft:
        case ControlCharacter.ctrlB:
          index = max(0, index - 1);
          break;
        case ControlCharacter.arrowRight:
        case ControlCharacter.ctrlF:
          index = min(input.length, index + 1);
          break;
        case ControlCharacter.home:
        case ControlCharacter.ctrlA:
          index = 0;
          break;
        case ControlCharacter.end:
        case ControlCharacter.ctrlE:
          index = input.length;
          break;
        case ControlCharacter.backspace:
          input = input.substring(0, index - 1) + input.substring(index);
          index--;
          break;
        case ControlCharacter.ctrlD: // delete current character
          input = input.substring(0, index) + input.substring(index + 1);
          break;
        case ControlCharacter.ctrlK: // delete to end of line
          input = input.substring(0, index);
          break;
        case ControlCharacter.enter:
          console.writeLine();
          console.writeLine('YOU SAID: ${input.toUpperCase()}');
          console.writeLine();

          input = '';
          index = 0;
          cursorPosition = console.cursorPosition;
          break;
        default:
        // Ignore
      }
    }

    console.cursorPosition = Coordinate(cursorPosition.row, 0);
    console.eraseLine();
    console.write('>>> $input');
    console.cursorPosition =
        Coordinate(cursorPosition.row, index + prompt.length);
  }
}
