import 'enums.dart';

extension StringUtils on String {
  String wrapText(int width) {
    final words = split(' ');
    final textLine = StringBuffer();
    final outputText = StringBuffer();

    for (final word in words) {
      if ((textLine.length + word.length) >= width) {
        textLine.write('\n');
        outputText.write(textLine);
        textLine.clear();
        textLine.write('$word ');
      } else {
        textLine.write('$word ');
      }
    }
    return outputText.toString();
  }

  String alignText(
      {required int width, TextAlignment alignment = TextAlignment.left}) {
    switch (alignment) {
      case TextAlignment.center:
        final padding = ((width - length) / 2).round();
        return padLeft(length + padding).padRight(width);
      case TextAlignment.right:
        return padLeft(width);
      default:
        return padRight(width);
    }
  }
}
