import 'dart:ffi';
import 'dart:io';

import 'termios.dart';
import 'unistd.dart';
import 'ioctl.dart';

class TermLib {
  DynamicLibrary _stdlib;

  Pointer<TermIOS> _origTermIOSPointer;
  TermIOS _origTermIOS;

  ioctlDart ioctl;
  tcgetattrDart tcgetattr;
  tcsetattrDart tcsetattr;

  int getWindowHeight() {
    Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
    ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer.cast());
    final WinSize winSize = winSizePointer.load<WinSize>();
    return winSize.ws_row;
  }

  int getWindowWidth() {
    Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
    ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer.cast());
    final WinSize winSize = winSizePointer.load<WinSize>();
    return winSize.ws_col;
  }

  void enableRawMode() {
    Pointer<TermIOS> origTermIOSPointer = Pointer<TermIOS>.allocate();
    tcgetattr(STDIN_FILENO, origTermIOSPointer);

    _origTermIOS = origTermIOSPointer.load();

    Pointer<TermIOS> newTermIOSPointer = Pointer<TermIOS>.allocate();
    TermIOS newTermIOS = newTermIOSPointer.load();

    newTermIOS.c_iflag =
        _origTermIOS.c_iflag & ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    newTermIOS.c_oflag = _origTermIOS.c_oflag & ~(OPOST);
    newTermIOS.c_cflag = _origTermIOS.c_cflag | (CS8);
    newTermIOS.c_lflag =
        _origTermIOS.c_lflag & ~(ECHO | ICANON | IEXTEN | ISIG);
    newTermIOS.c_cc0 = _origTermIOS.c_cc0;
    newTermIOS.c_cc1 = _origTermIOS.c_cc1;
    newTermIOS.c_cc2 = _origTermIOS.c_cc2;
    newTermIOS.c_cc3 = _origTermIOS.c_cc3;
    newTermIOS.c_cc4 = _origTermIOS.c_cc4;
    newTermIOS.c_cc5 = _origTermIOS.c_cc5;
    newTermIOS.c_cc6 = _origTermIOS.c_cc6;
    newTermIOS.c_cc7 = _origTermIOS.c_cc7;
    newTermIOS.c_cc8 = _origTermIOS.c_cc8;
    newTermIOS.c_cc9 = _origTermIOS.c_cc9;
    newTermIOS.c_cc10 = _origTermIOS.c_cc10;
    newTermIOS.c_cc11 = _origTermIOS.c_cc11;
    newTermIOS.c_cc12 = _origTermIOS.c_cc12;
    newTermIOS.c_cc13 = _origTermIOS.c_cc13;
    newTermIOS.c_cc14 = _origTermIOS.c_cc14;
    newTermIOS.c_cc15 = _origTermIOS.c_cc15;
    newTermIOS.c_cc16 = _origTermIOS.c_cc16;
    newTermIOS.c_cc17 = _origTermIOS.c_cc17;
    newTermIOS.c_cc18 = _origTermIOS.c_cc18;
    newTermIOS.c_cc19 = _origTermIOS.c_cc19;
    newTermIOS.c_ispeed = _origTermIOS.c_ispeed;
    newTermIOS.c_oflag = _origTermIOS.c_ospeed;

    tcsetattr(STDIN_FILENO, TCSAFLUSH, newTermIOS.addressOf);

    newTermIOSPointer.free();
  }

  void disableRawMode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, _origTermIOS.addressOf);
    _origTermIOSPointer.free();
  }

  TermLib() {
    _stdlib = Platform.isMacOS
        ? DynamicLibrary.open('libSystem.dylib')
        : DynamicLibrary.open("libc.so");

    ioctl = _stdlib.lookupFunction<ioctlNative, ioctlDart>("ioctl");
    tcgetattr =
        _stdlib.lookupFunction<tcgetattrNative, tcgetattrDart>("tcgetattr");
    tcsetattr =
        _stdlib.lookupFunction<tcsetattrNative, tcsetattrDart>("tcsetattr");
  }
}
