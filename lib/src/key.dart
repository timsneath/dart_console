// key.dart
//
// Representation of keyboard input and control characters.

/// Non-printable characters that can be entered from the keyboard.
enum ControlCharacter {
  none,

  ctrlA,
  ctrlB,
  ctrlC, // Break
  ctrlD, // End of File
  ctrlE,
  ctrlF,
  ctrlG, // Bell
  ctrlH, // Backspace
  tab,
  ctrlJ,
  ctrlK,
  ctrlL,
  enter,
  ctrlN,
  ctrlO,
  ctrlP,
  ctrlQ,
  ctrlR,
  ctrlS,
  ctrlT,
  ctrlU,
  ctrlV,
  ctrlW,
  ctrlX,
  ctrlY,
  ctrlZ, // Suspend

  arrowLeft,
  arrowRight,
  arrowUp,
  arrowDown,
  pageUp,
  pageDown,
  wordLeft,
  wordRight,

  home,
  end,
  escape,
  delete,
  backspace,

  F1,
  F2,
  F3,
  F4,

  unknown
}

/// A representation of a keystroke.
class Key {
  bool isControl;
  String char;
  ControlCharacter controlChar;

  Key.printable(String char) {
    assert(char.length == 1);

    this.char = char;
    isControl = false;
    controlChar = ControlCharacter.none;
  }

  Key.control(ControlCharacter controlChar) {
    char = '';
    isControl = true;
    this.controlChar = controlChar;
  }

  @override
  String toString() => isControl ? controlChar.toString() : char.toString();
}
