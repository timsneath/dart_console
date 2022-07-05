import 'enums.dart';

extension StringUtils on String {
  String wrapText(int width) {
    final words = split(' ');
    final textLine = StringBuffer();
    final outputText = StringBuffer();

    for (final word in words) {
      if ((textLine.length + word.displayWidth) >= width) {
        textLine.write('\n');
        outputText.write(textLine);
        textLine.clear();
        textLine.write('$word ');
      } else {
        textLine.write('$word ');
      }
    }
    outputText.write(textLine.toString());
    return outputText.toString();
  }

  String alignText(
      {required int width, TextAlignment alignment = TextAlignment.left}) {
    switch (alignment) {
      case TextAlignment.center:
        final padding = ((width - displayWidth) / 2).round();
        return padLeft(displayWidth + padding).padRight(width);
      case TextAlignment.right:
        return padLeft(width);
      default:
        return padRight(width);
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
