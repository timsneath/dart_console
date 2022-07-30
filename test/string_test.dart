import 'package:dart_console/dart_console.dart';
import 'package:dart_console/src/ansi.dart';

import 'package:test/test.dart';

void main() {
  test('Accurate displayWidth', () {
    const hello = 'Hello';
    final yellowAttr = ConsoleColor.brightYellow.ansiSetForegroundColorSequence;
    final yellowHello = yellowAttr + hello + ansiResetColor;

    expect(yellowHello.displayWidth, equals(hello.length));
  });

  test('Wrap short text', () {
    const hello = 'Hello';
    expect(hello.wrapText(7), equals('Hello'));
  });

  test('Wrap long text', () {
    const hello = 'HELLO HELLO Hello Hello hello hello';
    expect(hello.wrapText(11), equals('HELLO HELLO\nHello Hello\nhello hello'));
  });

  test('Align plain text single line left', () {
    const hello = 'Hello';
    expect(hello.alignText(width: 7), equals('Hello  '));
    expect(hello.alignText(width: 7).length, equals(7));
  });

  test('Align color text single line left', () {
    const hello = 'Hello';
    final yellowAttr = ConsoleColor.brightYellow.ansiSetForegroundColorSequence;
    final yellowHello = yellowAttr + hello + ansiResetColor;

    expect(yellowHello.stripEscapeCharacters().alignText(width: 7),
        equals('Hello  '));
  });

  test('Align odd length in even space', () {
    const char = 'c';
    expect(char.alignText(width: 4, alignment: TextAlignment.center),
        equals('  c '));
  });

  test('Align color text single line centered', () {
    const hello = 'Hello';
    final yellowAttr = ConsoleColor.brightYellow.ansiSetForegroundColorSequence;
    final yellowHello = yellowAttr + hello + ansiResetColor;

    expect(yellowHello.displayWidth, equals(5));

    final paddedWidth = 7;
    final padding = ((paddedWidth - yellowHello.displayWidth) / 2).round();
    expect(padding, equals(1));

    expect(yellowHello.stripEscapeCharacters().alignText(width: 7).length,
        equals(7));
    expect(yellowHello.alignText(width: 7, alignment: TextAlignment.center),
        equals(' \x1B[93mHello\x1B[m '));
  });

  test('Strip escape characters', () {
    final calendar = Calendar(DateTime(1969, 08, 15));
    final colorCal = calendar.toString();

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

  test('Superscript', () {
    expect(''.superscript(), equals(''));
    expect('⁰¹²³⁴⁵⁶⁷⁸⁹'.superscript(), equals('⁰¹²³⁴⁵⁶⁷⁸⁹'));
    expect('x2'.superscript(), equals('x²'));
    expect('0123456789'.superscript(), equals('⁰¹²³⁴⁵⁶⁷⁸⁹'));
    expect('///000999:::'.superscript(), equals('///⁰⁰⁰⁹⁹⁹:::'));
    expect('₀₁₂₃₄₅₆₇₈₉'.superscript(), equals('₀₁₂₃₄₅₆₇₈₉'));
  });

  test('Subscript', () {
    expect(''.subscript(), equals(''));
    expect('₀₁₂₃₄₅₆₇₈₉'.subscript(), equals('₀₁₂₃₄₅₆₇₈₉'));
    expect('x2'.subscript(), equals('x₂'));
    expect('0123456789'.subscript(), equals('₀₁₂₃₄₅₆₇₈₉'));
    expect('///000999:::'.subscript(), equals('///₀₀₀₉₉₉:::'));
    expect('⁰¹²³⁴⁵⁶⁷⁸⁹'.subscript(), equals('⁰¹²³⁴⁵⁶⁷⁸⁹'));
  });
}
