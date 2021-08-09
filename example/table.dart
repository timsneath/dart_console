import 'package:dart_console/dart_console.dart';

void main() {
  final table = ConsoleTable()
    ..addColumn('0')
    ..addColumn('1')
    ..addRow(['dog', 'cat'])
    ..addRow(['caterpillar', 'table']);

  table.printTable();
}
