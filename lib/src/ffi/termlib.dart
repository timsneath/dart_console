import 'dart:ffi' as ffi;

typedef void_void_native_t = ffi.Void Function();
typedef int_void_native_t = ffi.Int32 Function();

class TermLib {
  ffi.DynamicLibrary termlib;

  void Function() enableRawMode;
  void Function() disableRawMode;

  int Function() getWindowHeight;
  int Function() getWindowWidth;

  TermLib() {
    termlib = ffi.DynamicLibrary.open('/mnt/c/git/dart_console/termlib.so');

    enableRawMode = termlib
        .lookup<ffi.NativeFunction<void_void_native_t>>('enableRawMode')
        .asFunction();

    disableRawMode = termlib
        .lookup<ffi.NativeFunction<void_void_native_t>>('disableRawMode')
        .asFunction();

    getWindowHeight = termlib
        .lookup<ffi.NativeFunction<int_void_native_t>>('getWindowHeight')
        .asFunction();

    getWindowWidth = termlib
        .lookup<ffi.NativeFunction<int_void_native_t>>('getWindowWidth')
        .asFunction();
  }
}
