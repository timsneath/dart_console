import 'enums.dart';

extension AlignString on String {
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
