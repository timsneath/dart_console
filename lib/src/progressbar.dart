// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Adapted from
// https://github.com/dart-lang/sdk/blob/main/pkg/nnbd_migration/lib/src/utilities/progress_bar.dart

import 'dart:math';

import 'package:dart_console/dart_console.dart';

/// A facility for drawing a progress bar in the terminal.
///
/// The bar is instantiated with the total number of "ticks" to be completed,
/// and progress is made by calling [tick]. The bar is drawn across one entire
/// line, like so:
///
///     [----------                                                   ]
///
/// The hyphens represent completed progress, and the whitespace represents
/// remaining progress.
///
/// If there is no terminal, the progress bar will not be drawn.
class ProgressBar {
  List<String> spinnerCharacters = ['/', '-', '\\', '|'];

  /// Whether the progress bar should be drawn.
  late bool _shouldDrawProgress;

  Coordinate? _startCoordinate;

  Coordinate? _currentCoordinate;

  /// The width of the terminal, in terms of characters.
  late int _width;

  /// The inner width of the terminal, in terms of characters.
  ///
  /// This represents the number of characters available for drawing progress.
  late int _innerWidth;

  /// The value that represents completion of the progress bar.
  ///
  /// By default, the progress bar shows a percentage value from 0 to 100.
  final int maxValue;

  int _tickCount = 0;

  final console = Console();

  ProgressBar(
      {this.maxValue = 100, Coordinate? startCoordinate, int? barWidth}) {
    if (!console.hasTerminal) {
      _shouldDrawProgress = false;
    } else {
      _shouldDrawProgress = true;
      _currentCoordinate = console.cursorPosition;
      _startCoordinate = startCoordinate ?? console.cursorPosition;
      _width = barWidth ?? console.windowWidth;
      _innerWidth = console.windowWidth - 2;
      _printProgressBar('[${' ' * _innerWidth}]');
    }
  }

  /// Clear the progress bar from the terminal, allowing other logging to be
  /// printed.
  void clear() {
    if (!_shouldDrawProgress) {
      return;
    }
    _printProgressBar(' ' * _width);
  }

  /// Draw the progress bar as complete.
  void complete() {
    if (!_shouldDrawProgress) {
      return;
    }

    _printProgressBar('[${'-' * _innerWidth}]');
  }

  /// Progress the bar by one tick.
  void tick() {
    if (!_shouldDrawProgress) {
      return;
    }
    _tickCount++;
    var fractionComplete = max(0, _tickCount * _innerWidth ~/ maxValue - 1);
    var remaining = _innerWidth - fractionComplete - 1;
    var spinner = spinnerCharacters[_tickCount % 4];

    _printProgressBar('[${'-' * fractionComplete}$spinner${' ' * remaining}]');
  }

  void _printProgressBar(String progressBar) {
    // Push current location, so we can restore it after we've printed the
    // progress bar.
    _currentCoordinate = console.cursorPosition;
    if (_startCoordinate != null) {
      console.cursorPosition = _startCoordinate;
    } else {
      console.write('\r');
    }
    console.write(progressBar);
    console.cursorPosition = _currentCoordinate;
  }
}
