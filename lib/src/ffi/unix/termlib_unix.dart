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
import 'ioctl.dart';
import 'termios.dart';
import 'unistd.dart';

class TermLibUnix implements TermLib {
  late final DynamicLibrary _stdlib;

  late final Pointer<TermIOS> _origTermIOSPointer;

  late final ioctlDart ioctl;
  late final tcgetattrDart tcgetattr;
  late final tcsetattrDart tcsetattr;

  Pointer<WinSize> _getWindowSize() {
    final winSizePointer = calloc<WinSize>();

    final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer.cast());
    if (result == -1) return nullptr;

    return winSizePointer;
  }

  @override
  int getWindowHeight() {
    final winSizePointer = _getWindowSize();

    if (winSizePointer == nullptr) return -1;

    try {
      final row = winSizePointer.ref.ws_row;
      return row == 0 ? -1 : row;
    } finally {
      calloc.free(winSizePointer);
    }
  }

  @override
  int setWindowHeight(int height) {
    final winSizePointer = _getWindowSize();
    if (winSizePointer == nullptr) return -1;

    try {
      final winSize = winSizePointer.ref;
      if (winSize.ws_row == 0) {
        return -1;
      } else {
        winSize.ws_row = height;
        final setResult =
            ioctl(STDOUT_FILENO, TIOCSWINSZ, winSizePointer.cast());
        final result = (setResult == -1) ? setResult : winSize.ws_row;
        return result;
      }
    } finally {
      calloc.free(winSizePointer);
    }
  }

  @override
  int getWindowWidth() {
    final winSizePointer = _getWindowSize();
    if (winSizePointer == nullptr) return -1;

    try {
      final col = winSizePointer.ref.ws_col;
      return col == 0 ? -1 : col;
    } finally {
      calloc.free(winSizePointer);
    }
  }

  @override
  int setWindowWidth(int width) {
    final winSizePointer = _getWindowSize();
    if (winSizePointer == nullptr) return -1;

    try {
      final winSize = winSizePointer.ref;
      if (winSize.ws_col == 0) {
        return -1;
      } else {
        winSize.ws_col = width;
        final setResult =
            ioctl(STDOUT_FILENO, TIOCSWINSZ, winSizePointer.cast());
        final result = (setResult == -1) ? setResult : winSize.ws_col;
        return result;
      }
    } finally {
      calloc.free(winSizePointer);
    }
  }

  @override
  void enableRawMode() {
    final origTermIOS = _origTermIOSPointer.ref;

    final newTermIOSPointer = calloc<TermIOS>()
      ..ref.c_iflag =
          origTermIOS.c_iflag & ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON)
      ..ref.c_oflag = origTermIOS.c_oflag & ~OPOST
      ..ref.c_cflag = origTermIOS.c_cflag | CS8
      ..ref.c_lflag = origTermIOS.c_lflag & ~(ECHO | ICANON | IEXTEN | ISIG)
      ..ref.c_cc = origTermIOS.c_cc
      ..ref.c_cc[VMIN] = 0 // VMIN -- return each byte, or 0 for timeout
      ..ref.c_cc[VTIME] = 1 // VTIME -- 100ms timeout (unit is 1/10s)
      ..ref.c_ispeed = origTermIOS.c_ispeed
      ..ref.c_oflag = origTermIOS.c_ospeed;

    tcsetattr(STDIN_FILENO, TCSAFLUSH, newTermIOSPointer);

    calloc.free(newTermIOSPointer);
  }

  @override
  void disableRawMode() {
    if (nullptr == _origTermIOSPointer.cast()) return;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, _origTermIOSPointer);
  }

  TermLibUnix() {
    _stdlib = Platform.isMacOS
        ? DynamicLibrary.open('/usr/lib/libSystem.dylib')
        : DynamicLibrary.open('libc.so.6');

    ioctl = _stdlib.lookupFunction<ioctlNative, ioctlDart>('ioctl');
    tcgetattr =
        _stdlib.lookupFunction<tcgetattrNative, tcgetattrDart>('tcgetattr');
    tcsetattr =
        _stdlib.lookupFunction<tcsetattrNative, tcsetattrDart>('tcsetattr');

    // store console mode settings so we can return them again as necessary
    _origTermIOSPointer = calloc<TermIOS>();
    tcgetattr(STDIN_FILENO, _origTermIOSPointer);
  }
}
