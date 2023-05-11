// readline.dart
//
// Demonstrates a simple command-line interface that does not require line
// editing services from the shell.

import 'dart:io';

import 'package:dart_console/dart_console.dart';

final console = Console();

const prompt = '>>> ';

// Inspired by
// http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// as a test of the Console class capabilities

void main() {
  console
    ..write('The ')
    ..setForegroundColor(ConsoleColor.brightYellow)
    ..write('Console.readLine()')
    ..resetColorAttributes()
    ..writeLine(' method provides a basic readline implementation.')
    ..write('Unlike the built-in ')
    ..setForegroundColor(ConsoleColor.brightYellow)
    ..write('stdin.readLineSync()')
    ..resetColorAttributes()
    ..writeLine(' method, you can use arrow keys as well as home/end.')
    ..writeLine()
    ..writeLine('As a demo, this command-line reader "shouts" all text '
        'back in upper case.')
    ..writeLine('Enter a blank line or press Ctrl+C to exit.');

  while (true) {
    console.write(prompt);
    final response = console.readLine(cancelOnBreak: true);
    if (response == null || response.isEmpty) {
      exit(0);
    } else {
      console
        ..writeLine('YOU SAID: ${response.toUpperCase()}')
        ..writeLine();
    }
  }
}
