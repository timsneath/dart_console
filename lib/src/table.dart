import 'dart:math' show max;

import 'enums.dart';
import 'console.dart';

class ConsoleTable {
  List<List<String>> table = [[]];

  int get columns => table[0].length;

  void addColumn([String header = '']) {
    table[0].add(header);

    // TODO: handle adding a column after one or more rows have been added
  }

  void addRow(List<String> row) {
    if (row.length == columns) {
      table.add(row);
    } else {
      // TODO: sparse populate
    }
  }

  void printTable() {
    final console = Console();

    final columnWidths = List<int>.generate(columns, (column) {
      int maxLength = 0;
      for (final row in table) {
        maxLength = max(maxLength, row[column].length);
      }
      return maxLength;
    }, growable: false);

    // print table rows
    for (int row = 0; row < table.length; row++) {
      for (int column = 0; column < table[row].length; column++) {
        console.writeAligned(
            table[row][column], columnWidths[column] + 1, TextAlignment.left);
      }
      console.writeLine();
    }
  }
}
