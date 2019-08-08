import 'dart:ffi';
import 'dylib_utils.dart';

import 'termios.dart';
import 'unistd.dart';
import 'ioctl.dart';

typedef void_void_native_t = Void Function();
typedef int_void_native_t = Int32 Function();

class TermLib {
  DynamicLibrary stdlib;
  TermIOS orig_termios;

  var ioctl;

  int Function(int fildes, Pointer<TermIOS> termios) tcgetattr;
  int Function(int fildes, int optional_actions, Pointer<TermIOS> termios)
      tcsetattr;

  int getWindowHeight() {
    Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
    final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
    final winSize = winSizePointer.load<WinSize>();
    return winSize.ws_row;
  }

  int getWindowWidth() {
    Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
    final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
    final winSize = winSizePointer.load<WinSize>();
    return winSize.ws_col;
  }

  void enableRawMode() {
    Pointer<TermIOS> termiOSPointer = Pointer<TermIOS>.allocate();
    tcgetattr(STDIN_FILENO, termiOSPointer);
    // atexit(disableRawMode);

    orig_termios = termiOSPointer.load();
    var raw = orig_termios;
    raw.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    raw.c_oflag &= ~(OPOST);
    raw.c_cflag |= (CS8);
    raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);

    tcsetattr(STDIN_FILENO, TCSAFLUSH, raw.addressOf);
  }

  void disableRawMode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, orig_termios.addressOf);
  }

  TermLib() {
    stdlib = dlopenPlatformSpecific('System');

    ioctl = stdlib.lookupFunction<ioctlNative, ioctlDart>('ioctl');
    tcgetattr = stdlib
        .lookup<NativeFunction<tcgetattr_native_t>>('tcgetattr')
        .asFunction();

    tcsetattr = stdlib
        .lookup<NativeFunction<tcsetattr_native_t>>('tcsetattr')
        .asFunction();
  }
}
