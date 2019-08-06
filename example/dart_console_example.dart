import 'dart:io';
import 'dart:math' show max;

import 'package:dart_console/dart_console.dart';

final console = Console();

final demoScreens = <Function>[
  // SCREEN 1: Whimsical loading screen :)
  (() {
    console.setBackgroundColor(ConsoleColor.blue);
    console.setForegroundColor(ConsoleColor.white);
    console.clearScreen();

    final row = (console.windowHeight / 2).round() - 1;
    final progressBarWidth = max(console.windowWidth - 10, 10);

    console.cursorPosition = Coordinate(row - 2, 0);
    console.writeLine('L O A D I N G', TextAlignment.center);

    console.cursorPosition = Coordinate(row + 2, 0);
    console.writeLine('Please wait while we make you some avocado toast...',
        TextAlignment.center);

    console.hideCursor();

    for (int i = 0; i < 50; i++) {
      console.cursorPosition = Coordinate(row, 5);
      final progress = (i / 50 * progressBarWidth).ceil();
      final bar = '[' +
          ('#' * progress) +
          (' ' * (progressBarWidth - progress - 2)) +
          ']';
      console.write(bar);
      sleep(Duration(milliseconds: 40));
    }

    console.showCursor();

    console.cursorPosition = Coordinate(console.windowHeight - 3, 0);
  }),

  // SCREEN 2: General demonstration of basic color set and alignment.
  (() {
    console.setBackgroundColor(ConsoleColor.blue);
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine('Simple Demo', TextAlignment.center);
    console.resetColorAttributes();

    console.writeLine();

    console.writeLine('This console window has ${console.windowWidth} cols and '
        '${console.windowHeight} rows.');
    console.writeLine();

    console.writeLine('This text is left aligned.', TextAlignment.left);
    console.writeLine('This text is center aligned.', TextAlignment.center);
    console.writeLine('This text is right aligned.', TextAlignment.right);

    for (ConsoleColor color in ConsoleColor.values) {
      console.setForegroundColor(color);
      console.writeLine(color.toString().split('.').last);
    }
    console.resetColorAttributes();
  }),

  // SCREEN 3: Show extended foreground colors
  (() {
    console.setBackgroundColor(ConsoleColor.red);
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine(
        'ANSI Extended 256-Color Foreground Test', TextAlignment.center);
    console.resetColorAttributes();

    console.writeLine();

    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.setForegroundExtendedColor(color);
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }

    console.resetColorAttributes();
  }),

  // SCREEN 4: Show extended background colors
  (() {
    console.setBackgroundColor(ConsoleColor.green);
    console.setForegroundColor(ConsoleColor.white);
    console.writeLine(
        'ANSI Extended 256-Color Background Test', TextAlignment.center);
    console.resetColorAttributes();

    console.writeLine();

    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.setBackgroundExtendedColor(color);
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }

    console.resetColorAttributes();
  }),
];

//
// main
//
main() {
  for (final demo in demoScreens) {
    console.clearScreen();
    demo();
    console.writeLine();
    console.writeLine('Press any key to continue...');

    final key = console.readKey();
    console.resetColorAttributes();

    if (key.controlChar == ControlCharacter.ctrlC) {
      return 1;
    }
  }

  return 0;
}
