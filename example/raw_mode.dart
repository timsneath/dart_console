import 'package:dart_console/src/ffi/termlib.dart';

main() {
  final termlib = TermLib();
  termlib.enableRawMode();
  print('Here is some text.\nHere is some more text.');
  termlib.disableRawMode();
}
