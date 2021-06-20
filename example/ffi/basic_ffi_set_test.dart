import 'package:dart_console/src/ffi/termlib.dart';

void main() {
  final termlib = TermLib();

  final originalHeight = termlib.getWindowHeight();
  final originalWidth = termlib.getWindowWidth();

  print('This example should reduce console width by 2 and height by 1');

  print('Per TermLib, this console window has $originalWidth cols and '
      '$originalHeight rows.');

  if (originalHeight != -1 && originalWidth != -1) {
    print('Per TermLib, this console window has ${termlib.getWindowWidth()} '
        'cols and ${termlib.getWindowHeight()} rows after manipulation');
  } else {
    print('Skipped set, because could not get dimensions');
  }
}
