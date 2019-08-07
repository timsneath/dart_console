import 'dart:ffi';

typedef ioctlNative = Int32 Function(Int32, Int32, Pointer<Void>);
typedef ioctlDart = int Function(int, int, Pointer<Void>);

main() {
  final DynamicLibrary libc = DynamicLibrary.open("libc-2.28.so");
  Pointer<Int8> char = Pointer.allocate();
  final ioctl = libc.lookupFunction<ioctlNative, ioctlDart>("ioctl");

  // Assuming the string is ASCII -- don't know whether TIOCSTI can handle Utf8.
  // It seems that TIOCSTI can only handle one character at a time.
  for (int unit in "dart test.dart\n".codeUnits) {
    char.store(unit);
    ioctl(/*fd=*/ 0, /*request, TIOCSTI=*/ 21522, char.cast());
  }
}
