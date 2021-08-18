import 'package:dart_console/dart_console.dart';
import 'package:test/test.dart';

void main() {
  test('Strip escape characters', () {
    final calendar = Calendar(DateTime(1969, 08, 15));
    final colorCal = calendar.render();

    final monoCal = colorCal.stripEscapeCharacters();
    expect(monoCal, equals('''
                August 1969                
╭─────┬─────┬─────┬─────┬─────┬─────┬─────╮
│ Sun │ Mon │ Tue │ Wed │ Thu │ Fri │ Sat │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │   1 │   2 │
│   3 │   4 │   5 │   6 │   7 │   8 │   9 │
│  10 │  11 │  12 │  13 │  14 │  15 │  16 │
│  17 │  18 │  19 │  20 │  21 │  22 │  23 │
│  24 │  25 │  26 │  27 │  28 │  29 │  30 │
│  31 │     │     │     │     │     │     │
╰─────┴─────┴─────┴─────┴─────┴─────┴─────╯
'''));
  });
}
