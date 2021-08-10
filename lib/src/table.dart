import 'dart:math' show max;

import 'enums.dart';
import 'console.dart';

enum BorderStyle { none, ascii }
enum BorderType { outline, header, grid }

class Table {
  late Console console;
  final List<List<String>> _table = [[]];

  int get columns => _table[0].length;

  BorderStyle borderStyle = BorderStyle.none;
  BorderType borderType = BorderType.header;

  final List<TextAlignment> _columnAlignments = [];

  List<int> get _maxColumnLengths => List<int>.generate(columns, (column) {
        int maxLength = 0;
        for (final row in _table) {
          maxLength = max(maxLength, row[column].length);
        }
        return maxLength;
      }, growable: false);

  void addColumnDefinition(
      {String header = '', TextAlignment alignment = TextAlignment.left}) {
    _table[0].add(header);
    _columnAlignments.add(alignment);

    // TODO: handle adding a column after one or more rows have been added
  }

  void addRow(List<String> row) {
    // Take as many elements as available, but pad as necessary
    final fullRow = <String>[
      ...row,
      for (var i = row.length; i < columns; i++) ''
    ];
    _table.add(fullRow);
  }

  void setBorderStyle(BorderStyle borderStyle) {
    this.borderStyle = borderStyle;
  }

  void setBorderType(BorderType borderType) {
    this.borderType = borderType;
  }

  int _calculateTableWidth() {
    final columnWidths =
        _maxColumnLengths.reduce((value, element) => value + element);

    // Allow padding: either a single space between columns if no border, or
    // a padded vertical marker between columns.
    if (borderStyle == BorderStyle.none) {
      return columnWidths + columns - 1;
    } else {
      if (borderType == BorderType.outline) {
        return columnWidths + 4 + columns - 1;
      } else {
        return columnWidths + 4 + (3 * (columns - 1));
      }
    }
  }

  void _printRule(int width) {
    if (borderStyle != BorderStyle.none) {
      console.writeLine('-' * width);
    }
  }

  void render() {
    final columnWidths = _maxColumnLengths;
    var tableWidth = _calculateTableWidth();
    print(columnWidths);

    _printRule(tableWidth);

    // print table rows
    for (int row = 0; row < _table.length; row++) {
      if (borderStyle != BorderStyle.none) {
        console.write('| ');
      }

      for (int column = 0; column < columns; column++) {
        console.writeAligned(_table[row][column], columnWidths[column],
            _columnAlignments[column]);

        if (column < columns - 1) {
          if (borderStyle != BorderStyle.none &&
              borderType != BorderType.outline) {
            console.write(' | ');
          } else {
            console.write(' ');
          }
        }
      }

      if (borderStyle != BorderStyle.none) {
        console.write(' |');
      }
      console.writeLine();

      // Print a rule line underneath the header only
      if (borderType == BorderType.header && row == 0) {
        _printRule(tableWidth);
      }

      // Print a rule line after all internal rows for grid type
      if (borderType == BorderType.grid && row != _table.length - 1) {
        _printRule(tableWidth);
      }
    }
    _printRule(tableWidth);
  }

  Table() {
    console = Console();
  }
}
