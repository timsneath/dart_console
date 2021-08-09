import 'package:dart_console/dart_console.dart';

void main() {
  final table = ConsoleTable()
    ..addColumn(header: 'Fruit')
    ..addColumn(header: 'Quantity', alignment: TextAlignment.right)
    ..addRow(['apples', '10'])
    ..addRow(['bananas', '5'])
    ..addRow(['apricots', '1'])
    ..addRow(['dates', '10000'])
    ..addRow(['kumquats', '59']);

  table.printTable();
}
