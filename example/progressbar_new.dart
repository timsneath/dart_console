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

  final progressBar = ProgressBar(
    maxValue: 50,
    startCoordinate: Coordinate(row, 4),
    barWidth: progressBarWidth,
    showPartiallyCompletedTicks: false,
    tickCharacters: ['#'],
  );

  for (var i = 0; i < 50; i++) {
    progressBar.tick();
    sleep(const Duration(milliseconds: 40));
  }
  progressBar.complete();

  console.readKey();
  console.showCursor();
  progressBar.clear();

  console.cursorPosition = Coordinate(console.windowHeight - 3, 0);
}
