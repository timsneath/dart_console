import 'package:dart_console/dart_console.dart';

import 'ansi.dart';

class TextSpan {
  final ConsoleColor? foregroundColor;
  final ConsoleColor? backgroundColor;
  final Object child;

  const TextSpan(this.child, {this.foregroundColor, this.backgroundColor});

  @override
  String toString() {
    // Because TextSpans can be nested, we have to make sure that a reset
    // doesn't actually reset the colors, but instead pops them back to what
    // they were before. We do this by replacing any reset sequence to instead
    // set the current colors.

    // The required sequence to set up the specified colors, or an empty string
    // if no colors are set.
    final setColorSequence =
        (foregroundColor?.ansiSetForegroundColorSequence ?? '') +
            (backgroundColor?.ansiSetBackgroundColorSequence ?? '');

    // If we don't have anything set, then leave things be. Else replace an ANSI
    // reset to set the old colors again.
    String text = setColorSequence.isEmpty
        ? child.toString()
        : child.toString().replaceAll('\x1b[m', setColorSequence);

    return setColorSequence + text + ansiResetColor;
  }
}
