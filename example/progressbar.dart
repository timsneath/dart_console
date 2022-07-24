import 'dart:io';
import 'dart:math' as math;

import 'package:dart_console/dart_console.dart';

void main(List<String> args) {
  final console = Console();
  console.setBackgroundColor(ConsoleColor.blue);
  console.setForegroundColor(ConsoleColor.white);
  console.clearScreen();

  final row = (console.windowHeight / 2).round() - 1;
  final progressBarWidth = math.max(console.windowWidth - 10, 10);

  console.cursorPosition = Coordinate(row - 2, 0);
  console.writeLine('L O A D I N G', TextAlignment.center);

  console.cursorPosition = Coordinate(row + 2, 0);
  console.writeLine('Please wait while we make you some avocado toast...',
      TextAlignment.center);

  console.hideCursor();

  for (var i = 0; i <= 50; i++) {
    console.cursorPosition = Coordinate(row, 4);
    final progress = (i / 50 * progressBarWidth).ceil();
    final bar = '[${'#' * progress}${' ' * (progressBarWidth - progress)}]';
    console.write(bar);
    sleep(const Duration(milliseconds: 40));
  }

  console.showCursor();

  console.cursorPosition = Coordinate(console.windowHeight - 3, 0);
}
