import 'package:dart_console/dart_console.dart';

void main() {
  final table = Table()
    ..setBorderStyle(BorderStyle.ascii)
    ..setBorderType(BorderType.header)
    ..addColumnDefinition(header: 'Fruit')
    ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
    ..addColumnDefinition(header: 'Notes')
    ..addRow(['apples', '10'])
    ..addRow(['bananas', '5'])
    ..addRow(['apricots', '7'])
    ..addRow(['dates', '10000', 'a big number'])
    ..addRow(['kumquats', '59']);

  table.render();
}
