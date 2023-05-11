import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_console/dart_console.dart';

import 'table.dart';

final console = Console();

List<Function> demoScreens = <Function>[
  // SCREEN 1: Whimsical loading screen :)
  (() {
    console
      ..setBackgroundColor(ConsoleColor.blue)
      ..setForegroundColor(ConsoleColor.white)
      ..clearScreen();

    final row = (console.windowHeight / 2).round() - 1;

    console.cursorPosition = Coordinate(row - 2, 0);
    console
      ..writeLine('L O A D I N G', TextAlignment.center)
      ..cursorPosition = Coordinate(row + 2, 0)
      ..writeLine('Please wait while we make you some avocado toast...',
          TextAlignment.center)
      ..hideCursor();

    final progressBar = ProgressBar(
      maxValue: 100,
      startCoordinate: Coordinate(row, 4),
      barWidth: max(console.windowWidth - 10, 10),
      showSpinner: false,
      tickCharacters: ['#'],
    );

    for (var i = 0; i < 100; i++) {
      progressBar.tick();
      sleep(const Duration(milliseconds: 20));
    }
    progressBar.complete();

    console
      ..showCursor()
      ..cursorPosition = Coordinate(console.windowHeight - 3, 0);
  }),

  // SCREEN 2: General demonstration of basic color set and alignment.
  (() {
    console
      ..setBackgroundColor(ConsoleColor.blue)
      ..setForegroundColor(ConsoleColor.white)
      ..writeLine('Simple Demo', TextAlignment.center)
      ..resetColorAttributes()
      ..writeLine()
      ..writeLine('This console window has ${console.windowWidth} cols and '
          '${console.windowHeight} rows.')
      ..writeLine()
      ..writeLine('This text is left aligned.', TextAlignment.left)
      ..writeLine('This text is center aligned.', TextAlignment.center)
      ..writeLine('This text is right aligned.', TextAlignment.right)
      ..writeLine()
      ..setTextStyle(italic: true)
      ..writeLine('Text is italic (terminal dependent).')
      ..setTextStyle(bold: true)
      ..writeLine('Text is bold (terminal dependent).')
      ..resetColorAttributes()
      ..writeLine();

    for (final color in ConsoleColor.values) {
      console
        ..setForegroundColor(color)
        ..writeLine(color.toString().split('.').last);
    }
    console.resetColorAttributes();
  }),

  // SCREEN 3: Show extended foreground colors
  (() {
    console
      ..setBackgroundColor(ConsoleColor.red)
      ..setForegroundColor(ConsoleColor.white)
      ..writeLine(
          'ANSI Extended 256-Color Foreground Test', TextAlignment.center)
      ..resetColorAttributes()
      ..writeLine();

    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console
          ..setForegroundExtendedColor(color)
          ..write(color.toString().padLeft(4));
      }
      console.writeLine();
    }

    console.resetColorAttributes();
  }),

  // SCREEN 4: Show extended background colors
  (() {
    console
      ..setBackgroundColor(ConsoleColor.green)
      ..setForegroundColor(ConsoleColor.white)
      ..writeLine(
          'ANSI Extended 256-Color Background Test', TextAlignment.center)
      ..resetColorAttributes()
      ..writeLine();

    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console
          ..setBackgroundExtendedColor(color)
          ..write(color.toString().padLeft(4));
      }
      console.writeLine();
    }

    console.resetColorAttributes();
  }),

  // SCREEN 5: Tabular display
  (() {
    console
      ..setBackgroundColor(ConsoleColor.magenta)
      ..setForegroundColor(ConsoleColor.white)
      ..writeLine('Tabular Display Examples', TextAlignment.center)
      ..resetColorAttributes()
      ..writeLine();

    final calendar = Calendar.now();
    console
      ..write(calendar)
      ..writeLine();

    final table = Table()
      ..borderColor = ConsoleColor.blue
      ..borderStyle = BorderStyle.rounded
      ..borderType = BorderType.horizontal
      ..insertColumn(header: 'Number', alignment: TextAlignment.center)
      ..insertColumn(header: 'Presidency', alignment: TextAlignment.right)
      ..insertColumn(header: 'President')
      ..insertColumn(header: 'Party')
      ..insertRows(earlyPresidents)
      ..title = 'Early Presidents of the United States';
    console.write(table);
  }),

  // SCREEN 6: Twinkling stars
  (() {
    final stars = Queue<Coordinate>();
    final rng = Random();
    const numStars = 750;
    const maxStarsOnScreen = 250;

    void addStar() {
      final star = Coordinate(rng.nextInt(console.windowHeight - 1) + 1,
          rng.nextInt(console.windowWidth));
      console.cursorPosition = star;
      console.write('*');
      stars.addLast(star);
    }

    void removeStar() {
      final star = stars.first;
      console.cursorPosition = star;
      console.write(' ');
      stars.removeFirst();
    }

    console
      ..setBackgroundColor(ConsoleColor.yellow)
      ..setForegroundColor(ConsoleColor.brightBlack)
      ..writeLine('Stars', TextAlignment.center)
      ..resetColorAttributes()
      ..hideCursor()
      ..setForegroundColor(ConsoleColor.brightYellow);

    for (var i = 0; i < numStars; i++) {
      if (i < numStars - maxStarsOnScreen) {
        addStar();
      }
      if (i >= maxStarsOnScreen) {
        removeStar();
      }
      sleep(const Duration(milliseconds: 1));
    }

    console
      ..resetColorAttributes()
      ..cursorPosition = Coordinate(console.windowHeight - 3, 0)
      ..showCursor();
  }),
];

//
// main
//
int main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    final selectedDemo = int.tryParse(arguments.first);
    if (selectedDemo != null &&
        selectedDemo > 0 &&
        selectedDemo <= demoScreens.length) {
      demoScreens = <Function>[demoScreens[selectedDemo - 1]];
    }
  }

  for (final demo in demoScreens) {
    console.clearScreen();
    demo();
    console.writeLine();
    if (demoScreens.indexOf(demo) != demoScreens.length - 1) {
      console.writeLine('Press any key to continue, or Ctrl+C to quit...');
    } else {
      console.writeLine('Press any key to end the demo sequence...');
    }

    final key = console.readKey();
    console.resetColorAttributes();

    if (key.controlChar == ControlCharacter.ctrlC) {
      return 1;
    }
  }

  return 0;
}
