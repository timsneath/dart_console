import 'package:test/test.dart';
import 'package:dart_console/dart_console.dart';

void main() {
  test('ASCII grid', () {
    final table = Table()
      ..setBorderStyle(BorderStyle.ascii)
      ..setBorderType(BorderType.grid)
      ..addColumnDefinition(header: 'Fruit')
      ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Notes')
      ..addRows([
        ['apples', '10'],
        ['bananas', '5'],
        ['apricots', '7']
      ])
      ..addRow(['dates', '10000', 'a big number'])
      ..addRow(['kumquats', '59']);
    expect(table.render(), equals('''
-----------------------------------
| Fruit    |   Qty | Notes        |
|----------+-------+--------------|
| apples   |    10 |              |
|----------+-------+--------------|
| bananas  |     5 |              |
|----------+-------+--------------|
| apricots |     7 |              |
|----------+-------+--------------|
| dates    | 10000 | a big number |
|----------+-------+--------------|
| kumquats |    59 |              |
-----------------------------------
'''));
  });

  test('ASCII header', () {
    final table = Table()
      ..setBorderStyle(BorderStyle.ascii)
      ..setBorderType(BorderType.header)
      ..addColumnDefinition(header: 'Fruit')
      ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Notes')
      ..addRows([
        ['apples', '10'],
        ['bananas', '5'],
        ['apricots', '7']
      ])
      ..addRow(['dates', '10000', 'a big number'])
      ..addRow(['kumquats', '59']);
    expect(table.render(), equals('''
-----------------------------------
| Fruit    |   Qty | Notes        |
|----------+-------+--------------|
| apples   |    10 |              |
| bananas  |     5 |              |
| apricots |     7 |              |
| dates    | 10000 | a big number |
| kumquats |    59 |              |
-----------------------------------
'''));
  });
  test('ASCII outline', () {
    final table = Table()
      ..setBorderStyle(BorderStyle.ascii)
      ..setBorderType(BorderType.outline)
      ..addColumnDefinition(header: 'Fruit')
      ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
      ..addRows([
        ['apples', 10],
        ['bananas', 5],
        ['apricots', 7]
      ]);
    expect(table.render(), equals('''
----------------
| Fruit    Qty |
| apples    10 |
| bananas    5 |
| apricots   7 |
----------------
'''));
  });
  test('borderless', () {
    final table = Table()
      ..setBorderStyle(BorderStyle.none)
      ..setBorderType(BorderType.header)
      ..addColumnDefinition(header: 'Fruit')
      ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Notes')
      ..addRows([
        ['apples', '10'],
        ['bananas', '5'],
        ['apricots', '7']
      ])
      ..addRow(['dates', '10000', 'a big number'])
      ..addRow(['kumquats', '59']);

    final golden = '''
Fruit      Qty Notes       
apples      10             
bananas      5             
apricots     7             
dates    10000 a big number
kumquats    59             
''';
    expect(table.render(), equals(golden));

    table.setBorderType(BorderType.grid);
    expect(table.render(), equals(golden));

    table.setBorderType(BorderType.outline);
    expect(table.render(), equals(golden));
  });
  test('glyphs', () {
    final table = Table()
      ..addColumnDefinition(header: 'Number', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Presidency')
      ..addColumnDefinition(header: 'President')
      ..addColumnDefinition(header: 'Party')
      ..addRows([
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
      ]);

    expect(table.render(), equals('''
┌────────┬────────────────────────────────┬───────────────────┬───────────────────────┐
│ Number │ Presidency                     │ President         │ Party                 │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│      1 │ April 30, 1789 - March 4, 1797 │ George Washington │ unaffiliated          │
│      2 │ March 4, 1797 - March 4, 1801  │ John Adams        │ Federalist            │
│      3 │ March 4, 1801 - March 4, 1809  │ Thomas Jefferson  │ Democratic-Republican │
│      4 │ March 4, 1809 - March 4, 1817  │ James Madison     │ Democratic-Republican │
│      5 │ March 4, 1817 - March 4, 1825  │ James Monroe      │ Democratic-Republican │
└────────┴────────────────────────────────┴───────────────────┴───────────────────────┘
'''));
  });
}
