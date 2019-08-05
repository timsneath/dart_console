enum ControlCharacter {
  None,
  ArrowLeft,
  ArrowRight,
  ArrowUp,
  ArrowDown,
  PageUp,
  PageDown,
  Home,
  End,
  Delete,
  Backspace,
  Unknown
}

class Key {
  bool isControl;
  String char;
  ControlCharacter controlChar;
}
