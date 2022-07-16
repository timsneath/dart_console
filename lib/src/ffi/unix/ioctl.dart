// ioctl.dart
//
// Dart representations of functions and constants used in ioctl.h

// Ignore this lint, since these are UNIX identifiers that we're replicating.
//
// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';

final TIOCGWINSZ = Platform.isMacOS ? 0x40087468 : 0x5413;
final TIOCSWINSZ = Platform.isMacOS ? 0x80087467 : 0x5414;

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class WinSize extends Struct {
  @Int16()
  external int ws_row;

  @Int16()
  external int ws_col;

  @Int16()
  external int ws_xpixel;

  @Int16()
  external int ws_ypixel;
}

// int ioctl(int, unsigned long, ...);
typedef IOCtlNative = Int32 Function(Int32, Int64, Pointer<Void>);
typedef IOCtlDart = int Function(int, int, Pointer<Void>);
