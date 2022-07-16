// Ignore these lints, since these are UNIX identifiers that we're replicating
//
// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// int ioctl(int, unsigned long, ...);
typedef IOCtlNative = Int32 Function(Int32, Int64, Pointer<Void>);
typedef IOCtlDart = int Function(int, int, Pointer<Void>);

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

void main() {
  final libc = Platform.isMacOS
      ? DynamicLibrary.open('/usr/lib/libSystem.dylib')
      : DynamicLibrary.open('libc-2.28.so');

  final ioctl = libc.lookupFunction<IOCtlNative, IOCtlDart>('ioctl');

  final winSizePointer = calloc<WinSize>();
  final result = ioctl(STDOUT_FILENO, TIOCGWINSZ, winSizePointer.cast());
  print('result is $result');

  final winSize = winSizePointer.ref;
  print('Per ioctl, this console window has ${winSize.ws_col} cols and '
      '${winSize.ws_row} rows.');

  calloc.free(winSizePointer);
}
