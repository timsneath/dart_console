import 'dart:math' show max;

import 'enums.dart';
import 'console.dart';

class Table {
  final List<List<String>> _table = [[]];

  int get columns => _table[0].length;

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

  void print() {
    final console = Console();

    final columnWidths = _maxColumnLengths;

    // print table rows
    for (int row = 0; row < _table.length; row++) {
      for (int column = 0; column < columns; column++) {
        console.writeAligned(_table[row][column], columnWidths[column],
            _columnAlignments[column]);
        console.write(' '); // padding
      }
      console.writeLine();
    }
  }
}
