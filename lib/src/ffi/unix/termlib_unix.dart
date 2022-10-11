// termlib-unix.dart
//
// glibc-dependent library for interrogating and manipulating the console.
//
// This class provides raw wrappers for the underlying terminal system calls
// that are not available through ANSI mode control sequences, and is not
// designed to be called directly. Package consumers should normally use the
// `Console` class to call these methods.

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../termlib.dart';
import 'termios.dart';
import 'unistd.dart';

class TermLibUnix implements TermLib {
  late final DynamicLibrary _stdlib;

  late final Pointer<TermIOS> _origTermIOSPointer;

  late final TCGetAttrDart tcgetattr;
  late final TCSetAttrDart tcsetattr;

  @override
  int setWindowHeight(int height) {
    stdout.write('\x1b[8;$height;t');
    return height;
  }

  @override
  int setWindowWidth(int width) {
    stdout.write('\x1b[8;;${width}t');
    return width;
  }

  @override
  void enableRawMode() {
    final origTermIOS = _origTermIOSPointer.ref;

    final newTermIOSPointer = calloc<TermIOS>()
      ..ref.c_iflag =
          origTermIOS.c_iflag & ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON)
      ..ref.c_oflag = origTermIOS.c_oflag & ~OPOST
      ..ref.c_cflag = (origTermIOS.c_cflag & ~CSIZE) | CS8
      ..ref.c_lflag = origTermIOS.c_lflag & ~(ECHO | ICANON | IEXTEN | ISIG)
      ..ref.c_cc = origTermIOS.c_cc
      ..ref.c_cc[VMIN] = 0 // VMIN -- return each byte, or 0 for timeout
      ..ref.c_cc[VTIME] = 1 // VTIME -- 100ms timeout (unit is 1/10s)
      ..ref.c_ispeed = origTermIOS.c_ispeed
      ..ref.c_oflag = origTermIOS.c_ospeed;

    tcsetattr(STDIN_FILENO, TCSANOW, newTermIOSPointer);

    calloc.free(newTermIOSPointer);
  }

  @override
  void disableRawMode() {
    if (nullptr == _origTermIOSPointer.cast()) return;
    tcsetattr(STDIN_FILENO, TCSANOW, _origTermIOSPointer);
  }

  TermLibUnix() {
    _stdlib = Platform.isMacOS
        ? DynamicLibrary.open('/usr/lib/libSystem.dylib')
        : DynamicLibrary.open('libc.so.6');

    tcgetattr =
        _stdlib.lookupFunction<TCGetAttrNative, TCGetAttrDart>('tcgetattr');
    tcsetattr =
        _stdlib.lookupFunction<TCSetAttrNative, TCSetAttrDart>('tcsetattr');

    // store console mode settings so we can return them again as necessary
    _origTermIOSPointer = calloc<TermIOS>();
    tcgetattr(STDIN_FILENO, _origTermIOSPointer);
  }
}
