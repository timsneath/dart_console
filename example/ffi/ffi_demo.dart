import 'dart:ffi';
import 'dart:io';

typedef ioctlNative = Int32 Function(Int32, Int32, Pointer<Void>);
typedef ioctlDart = int Function(int, int, Pointer<Void>);

main() {
  DynamicLibrary libc;
  if (Platform.isMacOS) {
    libc = DynamicLibrary.open("libSystem.dylib");
  } else {
    libc = DynamicLibrary.open("libc-2.28.so");
  }
  Pointer<Int8> char = Pointer.allocate();
  final ioctl = libc.lookupFunction<ioctlNative, ioctlDart>("ioctl");

  int TIOCSTI;
  if (Platform.isMacOS) {
    TIOCSTI = 2147578994;
  } else {
    TIOCSTI = 21522;
  }

  // Assuming the string is ASCII -- don't know whether TIOCSTI can handle Utf8.
  // It seems that TIOCSTI can only handle one character at a time.
  for (int unit in "dart ffi_demo.dart\n".codeUnits) {
    char.store(unit);
    ioctl(/*fd=*/ 0, TIOCSTI, char.cast());
  }
}
