import 'package:dart_console/dart_console.dart';

void main() {
  final table = ConsoleTable()
    ..addColumnDefinition(header: 'Fruit')
    ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
    ..addColumnDefinition(header: 'Notes', alignment: TextAlignment.left)
    ..addRow(['apples', '10'])
    ..addRow(['bananas', '5'])
    ..addRow(['apricots', '7'])
    ..addRow(['dates', '10000000000', 'a big number'])
    ..addRow(['kumquats', '59']);

  table.printTable();
}
