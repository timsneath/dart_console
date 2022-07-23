import 'package:dart_console/dart_console.dart';
import 'package:test/test.dart';

void main() {
  test('Basic colored text span', () {
    final fg = ConsoleColor.black();
    final bg = ConsoleColor.brightCyan();
    final span = TextSpan('Hello', foregroundColor: fg, backgroundColor: bg);
    final text = ('<<<$span>>>');

    expect(text, equals('<<<[30m[106mHello[m>>>'));
  });

  test('Nested colored text span', () {
    final fg = ConsoleColor.black();
    final bg = ConsoleColor.brightCyan();
    final span = TextSpan('Hello', foregroundColor: fg, backgroundColor: bg);
    final text = ('<<<$span>>>');

    final fg2 = ConsoleColor.white();
    final bg2 = ConsoleColor.green();
    final span2 = TextSpan(text, foregroundColor: fg2, backgroundColor: bg2);
    final text2 = ('{{{$span2}}}');

    expect(
        text2, equals('{{{[37m[42m<<<[30m[106mHello[37m[42m>>>[m}}}'));
  });

  test('Nested semi-colored text span', () {
    final bg = ConsoleColor.cyan();
    final span = TextSpan('Hello', backgroundColor: bg);
    final text = ('<<<$span>>>');

    final fg2 = ConsoleColor.brightRed();
    final span2 = TextSpan(text, foregroundColor: fg2);
    final text2 = ('{{{$span2}}}');

    expect(
        text2, equals('{{{[37m[42m<<<[30m[106mHello[37m[42m>>>[m}}}'));
  }, skip: 'Need to find original color.');
}
