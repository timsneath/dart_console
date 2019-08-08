import 'dart:io';

import 'package:dart_console/dart_console.dart';

final console = Console();

main() {
  var key = console.readKey();

  while (!(key.isControl && key.controlChar == ControlCharacter.ctrlQ)) {
    if (key.isControl) {
      switch (key.controlChar) {
        case ControlCharacter.ctrlQ:
          console.clearScreen();
          console.resetCursorPosition();
          console.disableRawMode();
          exit(0);
          break;
        case ControlCharacter.arrowLeft:
        case ControlCharacter.arrowUp:
        case ControlCharacter.arrowRight:
        case ControlCharacter.arrowDown:
        case ControlCharacter.pageUp:
        case ControlCharacter.pageDown:
        case ControlCharacter.home:
        case ControlCharacter.end:
          print(key.controlChar);
          break;
        default:
      }
    }
    key = console.readKey();
  }
}
