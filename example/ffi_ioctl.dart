import 'dart:ffi';

typedef ioctlVoidNative = Int32 Function(Int32, Int32, Pointer<Void>);
typedef ioctlVoidDart = int Function(int, int, Pointer<Void>);

const int TIOCGWINSZ = 0x5413;

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class WinSize extends Struct<WinSize> {
  @Int32()
  int ws_row;

  @Int32()
  int ws_col;

  @Int32()
  int ws_xpixel;

  @Int32()
  int ws_ypixel;

  factory WinSize.allocate(
          int ws_row, int ws_col, int ws_xpixel, int ws_ypixel) =>
      Pointer<WinSize>.allocate().load<WinSize>()
        ..ws_row = ws_row
        ..ws_col = ws_col
        ..ws_xpixel = ws_xpixel
        ..ws_ypixel = ws_ypixel;
}

// int ioctl(int, unsigned long, ...);
typedef ioctlNative = Int32 Function(
    Int32 fd, Int32 cmd, Pointer<WinSize> winsize);
typedef ioctlDart = int Function(int fd, int cmd, Pointer<WinSize> ws);

// int getWindowHeight() {
//   Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
//   final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
//   final winSize = winSizePointer.load<WinSize>();
//   return winSize.ws_row;
// }

// int getWindowWidth() {
//   Pointer<WinSize> winSizePointer = Pointer<WinSize>.allocate();
//   final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer);
//   final winSize = winSizePointer.load<WinSize>();
//   return winSize.ws_col;
// }

main() {
  final DynamicLibrary libc = DynamicLibrary.open("libc-2.28.so");
  Pointer<Int8> char = Pointer.allocate();
  final ioctl = libc.lookupFunction<ioctlVoidNative, ioctlVoidDart>("ioctl");

  // Assuming the string is ASCII -- don't know whether TIOCSTI can handle Utf8.
  // It seems that TIOCSTI can only handle one character at a time.
  for (int unit in "dart ffi_ioctl.dart\n".codeUnits) {
    char.store(unit);
    ioctl(/*fd=*/ 0, /*request, TIOCSTI=*/ 21522, char.cast());
  }
}
