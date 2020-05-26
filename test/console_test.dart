import 'package:dart_console/dart_console.dart';

import 'package:test/test.dart';
import '../example/readme.dart' as readmeExample;

void main() {
  Console console;

  setUp(() {
    console = Console();
  });

  test('Coordinate positioning', () {
    final coordinate = Coordinate(5, 8);

    console.cursorPosition = coordinate;

    final returnedCoordinate = console.cursorPosition;

    expect(coordinate.row, equals(returnedCoordinate.row));
    expect(coordinate.col, equals(returnedCoordinate.col));
  });

  test('should run readme example', () {
    expect(readmeExample.main(), 0);
  });
}
