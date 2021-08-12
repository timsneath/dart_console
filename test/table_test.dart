import 'package:test/test.dart';
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
  test('ASCII grid', () {
    final table = Table()
      ..borderStyle = BorderStyle.ascii
      ..borderType = BorderType.grid
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
      ..borderStyle = BorderStyle.ascii
      ..borderType = BorderType.header
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
      ..borderStyle = BorderStyle.ascii
      ..borderType = BorderType.outline
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
      ..borderStyle = BorderStyle.none
      ..borderType = BorderType.header
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

    // Changing border type shouldn't have any impact if there's no border
    table.borderType = BorderType.grid;
    expect(table.render(), equals(golden));

    table.borderType = BorderType.outline;
    expect(table.render(), equals(golden));
  });

  test('glyphs', () {
    final table = Table()
      ..addColumnDefinition(header: 'Number', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Presidency')
      ..addColumnDefinition(header: 'President')
      ..addColumnDefinition(header: 'Party')
      ..addRows(earlyPresidents);

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

  test('color border', () {
    final table = Table()
      ..borderColor = ConsoleColor.brightCyan
      ..borderStyle = BorderStyle.bold
      ..addColumnDefinition(header: 'Number', alignment: TextAlignment.right)
      ..addColumnDefinition(header: 'Presidency')
      ..addColumnDefinition(header: 'President')
      ..addColumnDefinition(header: 'Party')
      ..addRows(earlyPresidents);

    expect(table.render(), equals('''
[96m┏━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━┓[m
[96m┃ [mNumber[96m ┃ [mPresidency                    [96m ┃ [mPresident        [96m ┃ [mParty                [96m ┃[m
[96m┣━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━┫[m
[96m┃ [m     1[96m ┃ [mApril 30, 1789 - March 4, 1797[96m ┃ [mGeorge Washington[96m ┃ [munaffiliated         [96m ┃[m
[96m┃ [m     2[96m ┃ [mMarch 4, 1797 - March 4, 1801 [96m ┃ [mJohn Adams       [96m ┃ [mFederalist           [96m ┃[m
[96m┃ [m     3[96m ┃ [mMarch 4, 1801 - March 4, 1809 [96m ┃ [mThomas Jefferson [96m ┃ [mDemocratic-Republican[96m ┃[m
[96m┃ [m     4[96m ┃ [mMarch 4, 1809 - March 4, 1817 [96m ┃ [mJames Madison    [96m ┃ [mDemocratic-Republican[96m ┃[m
[96m┃ [m     5[96m ┃ [mMarch 4, 1817 - March 4, 1825 [96m ┃ [mJames Monroe     [96m ┃ [mDemocratic-Republican[96m ┃[m
[96m┗━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━┛[m
'''));
  });
}
