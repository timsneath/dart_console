import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'package:test/test.dart';
import '../example/readme.dart' as readme_example;

void main() {
  test('Coordinate positioning', () {
    final console = Console();
    if (stdout.hasTerminal && stdin.hasTerminal) {
      const coordinate = Coordinate(5, 8);

      console.cursorPosition = coordinate;

      final returnedCoordinate = console.cursorPosition!;

      expect(coordinate.row, equals(returnedCoordinate.row));
      expect(coordinate.col, equals(returnedCoordinate.col));
    }
  });

  test('Should run readme example', () {
    if (stdout.hasTerminal && stdin.hasTerminal) {
      expect(readme_example.main(), 0);
    }
  });
}
