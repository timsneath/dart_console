import 'dart:ffi';

import 'dylib_utils.dart';

typedef void_void_native_t = Void Function();
typedef int_void_native_t = Int32 Function();

// int ioctl(int, unsigned long, ...);
typedef ioctl_native_t = Int16 Function(
    Int16 fd, Int32 cmd, Pointer<WinSize> winsize);

const STDIN_FILENO = 0;
const STDOUT_FILENO = 1;
const STDERR_FILENO = 2;

const TIOCGWINSZ = 0x5413;

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class WinSize extends Struct<WinSize> {
  @Int8()
  int ws_row;

  @Int8()
  int ws_col;

  @Int8()
  int ws_xpixel;

  @Int8()
  int ws_ypixel;

  factory WinSize.allocate(
      int ws_row, int ws_col, int ws_xpixel, int ws_ypixel) {
    Pointer<WinSize>.allocate().load<WinSize>()
      ..ws_row = ws_row
      ..ws_col = ws_col
      ..ws_xpixel = ws_xpixel
      ..ws_ypixel = ws_ypixel;
  }
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
      Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
      ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
      final winSize = winSizePointer.load();
      return winSize.ws_row;
    };

    getWindowWidth = () {
      Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
      ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
      final winSize = winSizePointer.load();
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
