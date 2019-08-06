import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

String _platformPath(String name, {String path}) {
  if (path == null) path = "";

  if (Platform.isLinux || Platform.isAndroid) {
    return path + "lib" + name + ".so";
  }
  if (Platform.isMacOS) {
    return path + "lib" + name + ".dylib";
  }
  if (Platform.isWindows) {
    return path + name + ".dll";
  }
  throw Exception("Platform not implemented");
}

ffi.DynamicLibrary dlopenPlatformSpecific(String name, {String path}) {
  String fullPath = _platformPath(name, path: path);
  return ffi.DynamicLibrary.open(fullPath);
}
