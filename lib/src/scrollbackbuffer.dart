/// The ScrollbackBuffer class is a utility for handling multi-line user
/// input in readline(). It doesn't support history editing a la bash,
/// but it should handle the most common use cases.
class ScrollbackBuffer {
  final lineList = <String>[];
  int? lineIndex;
  String? currentLineBuffer;
  bool recordBlanks;

  // called by Console.scolling()
  ScrollbackBuffer({required this.recordBlanks});

  /// Add a new line to the scrollback buffer. This would normally happen
  /// when the user finishes typing/editing the line and taps the 'enter'
  /// key.
  void add(String buffer) {
    // don't add blank line to scrollback history if !recordBlanks
    if (buffer == '' && !recordBlanks) {
      return;
    }
    lineList.add(buffer);
    lineIndex = lineList.length;
    currentLineBuffer = null;
  }

  /// Scroll 'up' -- Replace the user-input buffer with the contents of the
  /// previous line. ScrollbackBuffer tracks which lines are the 'current'
  /// and 'previous' lines. The up() method stores the current line buffer
  /// so that the contents will not be lost in the event the user starts
  /// typing/editing the line and then wants to review a previous line.
  String up(String buffer) {
    // Handle the case of the user tapping 'up' before there is a
    // scrollback buffer to scroll through.
    if (lineIndex == null) {
      return buffer;
    } else {
      // Only store the current line buffer once while scrolling up
      currentLineBuffer ??= buffer;
      lineIndex = lineIndex! - 1;
      lineIndex = lineIndex! < 0 ? 0 : lineIndex;
      return lineList[lineIndex!];
    }
  }

  /// Scroll 'down' -- Replace the user-input buffer with the contents of
  /// the next line. The final 'next line' is the original contents of the
  /// line buffer.
  String? down() {
    // Handle the case of the user tapping 'down' before there is a
    // scrollback buffer to scroll through.
    if (lineIndex == null) {
      return null;
    } else {
      lineIndex = lineIndex! + 1;
      lineIndex = lineIndex! > lineList.length ? lineList.length : lineIndex;
      if (lineIndex == lineList.length) {
        // Once the user scrolls to the bottom, reset the current line
        // buffer so that up() can store it again: The user might have
        // edited it between down() and up().
        final temp = currentLineBuffer;
        currentLineBuffer = null;
        return temp;
      } else {
        return lineList[lineIndex!];
      }
    }
  }
}
