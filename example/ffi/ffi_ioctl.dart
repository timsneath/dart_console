import 'dart:ffi';
import 'dart:io';

// int ioctl(int, unsigned long, ...);
typedef ioctlVoidNative = Int32 Function(Int32, Int32, Pointer<Void>);
typedef ioctlVoidDart = int Function(int, int, Pointer<Void>);

final TIOCGWINSZ = Platform.isMacOS ? 0x40087468 : 0x5413;
const STDIN_FILENO = 0;
const STDOUT_FILENO = 1;
const STDERR_FILENO = 2;

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class WinSize extends Struct<WinSize> {
  @Int16()
  int ws_row;

  @Int16()
  int ws_col;

  @Int16()
  int ws_xpixel;

  @Int16()
  int ws_ypixel;

  factory WinSize.allocate(
          int ws_row, int ws_col, int ws_xpixel, int ws_ypixel) =>
      Pointer<WinSize>.allocate().load<WinSize>()
        ..ws_row = ws_row
        ..ws_col = ws_col
        ..ws_xpixel = ws_xpixel
        ..ws_ypixel = ws_ypixel;
}

main() {
  final DynamicLibrary libc = Platform.isMacOS
      ? DynamicLibrary.open('libSystem.dylib')
      : DynamicLibrary.open("libc-2.28.so");

  final ioctl = libc.lookupFunction<ioctlVoidNative, ioctlVoidDart>("ioctl");

  Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
  final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer.cast());
  print('result is $result');

  final winSize = winSizePointer.load<WinSize>();
  print('Per ioctl, this console window has ${winSize.ws_col} cols and '
      '${winSize.ws_row} rows.');

  winSizePointer.free();
}
