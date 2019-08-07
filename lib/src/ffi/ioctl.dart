import 'dart:ffi';

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
typedef ioctl_native_t = Int32 Function(
    Int32 fd, Int32 cmd, Pointer<WinSize> winsize);
