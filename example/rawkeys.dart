// rawkeys.dart
//
// Diagnostic test for tracking down differences in raw key input from different
// platforms.

import 'dart:io';

import 'package:dart_console/dart_console.dart';

final console = Console();

main() {
  console.rawMode = true;

  while (true) {
    final codeUnit = stdin.readByteSync();

    if (codeUnit < 0x20 || codeUnit == 0x7F) {
      print('${codeUnit.toRadixString(16)}\r');
    } else {
      print(
          '${codeUnit.toRadixString(16)} (${String.fromCharCode(codeUnit)})\r');
    }

    if (String.fromCharCode(codeUnit) == 'q') {
      console.rawMode = false;
      exit(0);
    }
  }
}
