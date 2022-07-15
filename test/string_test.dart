import 'package:dart_console/dart_console.dart';
import 'package:dart_console/src/ansi.dart';

import 'package:test/test.dart';

void main() {
  test('displayLength', () {
    const hello = 'Hello';
    final yellowAttr = ansiSetExtendedForegroundColor(
        ansiForegroundColors[ConsoleColor.brightYellow]!);
    final yellowHello = yellowAttr + hello + ansiResetColor;

    expect(yellowHello.displayWidth, equals(hello.length));
  });

  test('wrap short text', () {
    const hello = 'Hello';
    expect(hello.wrapText(7), equals('Hello'));
  });

  test('wrap long text', () {
    const hello = 'HELLO HELLO Hello Hello hello hello';
    expect(hello.wrapText(11), equals('HELLO HELLO\nHello Hello\nhello hello'));
  });

  test('align plain text single line left', () {
    const hello = 'Hello';
    expect(hello.alignText(width: 7), equals('Hello  '));
    expect(hello.alignText(width: 7).length, equals(7));
  });

  test('align color text single line left', () {
    const hello = 'Hello';
    final yellowAttr = ansiSetExtendedForegroundColor(
        ansiForegroundColors[ConsoleColor.brightYellow]!);
    final yellowHello = yellowAttr + hello + ansiResetColor;

    print(yellowHello.alignText(width: 7));

    expect(yellowHello.stripEscapeCharacters().alignText(width: 7),
        equals('Hello  '));
  });

  test('align color text single line centered', () {
    const hello = 'Hello';
    final yellowAttr = ansiSetExtendedForegroundColor(
        ansiForegroundColors[ConsoleColor.brightYellow]!);
    final yellowHello = yellowAttr + hello + ansiResetColor;

    expect(yellowHello.displayWidth, equals(5));

    final paddedWidth = 7;
    final padding = ((paddedWidth - yellowHello.displayWidth) / 2).round();
    expect(padding, equals(1));

    expect(yellowHello.stripEscapeCharacters().alignText(width: 7).length,
        equals(7));
    expect(yellowHello.alignText(width: 7, alignment: TextAlignment.center),
        equals(' \x1B[38;5;93mHello\x1B[m '));
  });

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
