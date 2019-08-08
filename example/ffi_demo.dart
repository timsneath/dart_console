import 'dart:ffi';
import 'package:dart_console/src/ffi/dylib_utils.dart';

typedef ioctlNative = Int32 Function(Int32, Int32, Pointer<Void>);
typedef ioctlDart = int Function(int, int, Pointer<Void>);

main() {
  final DynamicLibrary libc = dlopenPlatformSpecific("System");
  Pointer<Int8> char = Pointer.allocate();
  final ioctl = libc.lookupFunction<ioctlNative, ioctlDart>("ioctl");

  // Assuming the string is ASCII -- don't know whether TIOCSTI can handle Utf8.
  // It seems that TIOCSTI can only handle one character at a time.
  for (int unit in "dart ffi_demo.dart\n".codeUnits) {
    char.store(unit);
    ioctl(/*fd=*/ 0, /*request, TIOCSTI=*/ 21522, char.cast());
  }
}
