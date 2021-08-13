import 'dart:io';

import 'package:dart_console/dart_console.dart';

const earlyPresidents = [
  [
    1,
    'April 30, 1789 - March 4, 1797',
    'George Washington',
    'unaffiliated',
  ],
  [
    2,
    'March 4, 1797 - March 4, 1801',
    'John Adams',
    'Federalist',
  ],
  [
    3,
    'March 4, 1801 - March 4, 1809',
    'Thomas Jefferson',
    'Democratic-Republican',
  ],
  [
    4,
    'March 4, 1809 - March 4, 1817',
    'James Madison',
    'Democratic-Republican',
  ],
  [
    5,
    'March 4, 1817 - March 4, 1825',
    'James Monroe',
    'Democratic-Republican',
  ],
];

void main() {
  final table = Table()
    ..addColumnDefinition(header: 'Number', alignment: TextAlignment.right)
    ..addColumnDefinition(header: 'Presidency')
    ..addColumnDefinition(header: 'President')
    ..addColumnDefinition(header: 'Party')
    ..addRows(earlyPresidents)
    ..borderStyle = BorderStyle.square;
  print(table.render());

  final golden = File('golden.txt').openSync(mode: FileMode.writeOnly);
  golden.writeStringSync(table.render());
  golden.closeSync();
}
