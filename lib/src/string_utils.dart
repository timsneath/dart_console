import 'enums.dart';

extension StringUtils on String {
  /// Take an input string and wrap it across multiple lines.
  String wrapText([int wrapLength = 76]) {
    if (isEmpty) {
      return '';
    }

    final words = split(' ');
    final textLine = StringBuffer(words.first);
    final outputText = StringBuffer();

    for (final word in words.skip(1)) {
      if ((textLine.length + word.length) > wrapLength) {
        textLine.write('\n');
        outputText.write(textLine);
        textLine
          ..clear()
          ..write(word);
      } else {
        textLine.write(' $word');
      }
    }

    outputText.write(textLine);
    return outputText.toString().trimRight();
  }

  String alignText(
      {required int width, TextAlignment alignment = TextAlignment.left}) {
    // We can't use the padLeft() and padRight() methods here, since they
    // don't account for ANSI escape sequences.
    switch (alignment) {
      case TextAlignment.center:
        // By using ceil _and_ floor, we ensure that the target width is reached
        // even if the padding is uneven (e.g. a single character wrapped in a 4
        // character width should be wrapped as '··c·' rather than '··c··').
        final leftPadding = ' ' * ((width - displayWidth) / 2).ceil();
        final rightPadding = ' ' * ((width - displayWidth) / 2).floor();
        return leftPadding + this + rightPadding;
      case TextAlignment.right:
        final padding = ' ' * (width - displayWidth);
        return padding + this;
      case TextAlignment.left:
      default:
        final padding = ' ' * (width - displayWidth);
        return this + padding;
    }
  }

  String stripEscapeCharacters() {
    return replaceAll(RegExp(r'\x1b\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]'), '')
        .replaceAll(RegExp(r'\x1b[PX^_].*?\x1b\\'), '')
        .replaceAll(RegExp(r'\x1b\][^\a]*(?:\a|\x1b\\)'), '')
        .replaceAll(RegExp(r'\x1b[\[\]A-Z\\^_@]'), '');
  }

  /// The number of displayed character cells that are represented by the
  /// string.
  ///
  /// This should never be more than the length of the string; it excludes ANSI
  /// control characters.
  int get displayWidth => stripEscapeCharacters().length;
}
