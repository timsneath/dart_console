import 'dart:math' show max;

import 'enums.dart';
import 'console.dart';

class ConsoleTable {
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

  void addColumn(
      {String header = '', TextAlignment alignment = TextAlignment.left}) {
    _table[0].add(header);
    _columnAlignments.add(alignment);

    // TODO: handle adding a column after one or more rows have been added
  }

  void addRow(List<String> row) {
    if (row.length == columns) {
      _table.add(row);
    } else {
      // TODO: sparse populate
    }
  }

  void printTable() {
    final console = Console();

    final columnWidths = _maxColumnLengths;

    // print table rows
    for (int row = 0; row < _table.length; row++) {
      for (int column = 0; column < _table[row].length; column++) {
        console.writeAligned(_table[row][column], columnWidths[column] + 1,
            _columnAlignments[column]);
      }
      console.writeLine();
    }
  }
}
