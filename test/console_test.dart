import 'package:dart_console/dart_console.dart';
import 'package:dart_console/src/ffi/termlib.dart';

import 'package:test/test.dart';
import '../example/readme.dart' as readme_example;

void main() {
  late Console console;

  setUp(() {
    console = Console();
  });

  test('Coordinate positioning', () {
    const coordinate = Coordinate(5, 8);

    console.cursorPosition = coordinate;

    final returnedCoordinate = console.cursorPosition!;

    expect(coordinate.row, equals(returnedCoordinate.row));
    expect(coordinate.col, equals(returnedCoordinate.col));
  });

  test('should run readme example', () {
    expect(readme_example.main(), 0);
  });

  test('resize window', () {
    final termlib = TermLib();

    final originalHeight = termlib.getWindowHeight();
    final originalWidth = termlib.getWindowWidth();

    expect(originalHeight, isNot(-1));
    expect(originalWidth, isNot(-1));

    termlib.setWindowHeight(originalHeight + 1);
    termlib.setWindowWidth(originalWidth + 1);

    final newHeight = termlib.getWindowHeight();
    final newWidth = termlib.getWindowWidth();

    expect(newHeight, equals(originalHeight + 1));
    expect(newWidth, equals(originalWidth + 1));
  });
}
