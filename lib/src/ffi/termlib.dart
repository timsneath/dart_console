import 'dart:ffi';

import 'dylib_utils.dart';

typedef void_void_native_t = Void Function();
typedef int_void_native_t = Int32 Function();
typedef ioctl_native_t = Int32 Function(
    Int32 fd, Int32 cmd, Pointer<WinSize> winsize);

const STDIN_FILENO = 0;
const TIOCGWINSZ = 0x5413;

class WinSize extends Struct<WinSize> {
  @Int8()
  int ws_row; // rows, in characters

  @Int8()
  int ws_col; // columns, in characters

  @Int8()
  int ws_xpixel; // horizontal size, pixels

  @Int8()
  int ws_ypixel; // vertical size, pixels
}

class TermLib {
  DynamicLibrary libc;

  void Function() enableRawMode;
  void Function() disableRawMode;

  int Function() getWindowHeight;
  int Function() getWindowWidth;

  int Function(int fd, int cmd, Pointer<WinSize> ws) ioctl;

  TermLib() {
    libc = dlopenPlatformSpecific('System');

    ioctl = libc.lookup<NativeFunction<ioctl_native_t>>('ioctl').asFunction();

    getWindowHeight = () {
      Pointer<WinSize> ws = Pointer.allocate();
      ioctl(STDIN_FILENO, TIOCGWINSZ, ws);
      final winSize = ws.load();
      return winSize.ws_row;
    };

    getWindowWidth = () {
      Pointer<WinSize> ws = Pointer.allocate();
      ioctl(STDIN_FILENO, TIOCGWINSZ, ws);
      final winSize = ws.load();
      return winSize.ws_col;
    };

    // enableRawMode = termlib
    //     .lookup<NativeFunction<void_void_native_t>>('enableRawMode')
    //     .asFunction();

    // disableRawMode = termlib
    //     .lookup<NativeFunction<void_void_native_t>>('disableRawMode')
    //     .asFunction();

    // getWindowHeight = termlib
    //     .lookup<NativeFunction<int_void_native_t>>('getWindowHeight')
    //     .asFunction();

    // getWindowWidth = termlib
    //     .lookup<NativeFunction<int_void_native_t>>('getWindowWidth')
    //     .asFunction();
  }
}
