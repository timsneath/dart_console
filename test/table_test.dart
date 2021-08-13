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
  group('Table operations', () {
    test('Empty table should not render', () {
      final table = Table();
      expect(table.render(), isEmpty);
    });

    test('Table with no column defs should not render header', () {
      final table = Table()..addRows(earlyPresidents);
      expect(table.render(), equals('''
╭───┬────────────────────────────────┬───────────────────┬───────────────────────╮
│ 1 │ April 30, 1789 - March 4, 1797 │ George Washington │ unaffiliated          │
│ 2 │ March 4, 1797 - March 4, 1801  │ John Adams        │ Federalist            │
│ 3 │ March 4, 1801 - March 4, 1809  │ Thomas Jefferson  │ Democratic-Republican │
│ 4 │ March 4, 1809 - March 4, 1817  │ James Madison     │ Democratic-Republican │
│ 5 │ March 4, 1817 - March 4, 1825  │ James Monroe      │ Democratic-Republican │
╰───┴────────────────────────────────┴───────────────────┴───────────────────────╯
'''));
    });
  });

  group('Table formatting', () {
    test('none', () {
      final table = Table()
        ..borderStyle = BorderStyle.none
        ..headerStyle = FontStyle.underscore
        ..addColumnDefinition(header: 'Fruit')
        ..addColumnDefinition(header: 'Qty', alignment: TextAlignment.right)
        ..addRows([
          ['apples', 10],
          ['bananas', 5],
          ['apricots', 7]
        ]);
      expect(table.render(), equals('''
[4mFruit   [m [4mQty[m
apples    10
bananas    5
apricots   7
'''));
    });

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
|              |
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
        ..addRows(earlyPresidents)
        ..borderStyle = BorderStyle.square;

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

    test('horizontal double border', () {
      final table = Table()
        ..borderColor = ConsoleColor.blue
        ..borderStyle = BorderStyle.double
        ..borderType = BorderType.horizontal
        ..addColumnDefinition(header: 'Number', alignment: TextAlignment.center)
        ..addColumnDefinition(
            header: 'Presidency', alignment: TextAlignment.right)
        ..addColumnDefinition(header: 'President')
        ..addColumnDefinition(header: 'Party')
        ..addRows(earlyPresidents);

      expect(table.render(), equals('''
[34m╔═════════════════════════════════════════════════════════════════════════════════════╗[m
[34m║ [mNumber                       Presidency   President           Party                [34m ║[m
[34m╠═════════════════════════════════════════════════════════════════════════════════════╣[m
[34m║ [m   1     April 30, 1789 - March 4, 1797   George Washington   unaffiliated         [34m ║[m
[34m║ [m   2      March 4, 1797 - March 4, 1801   John Adams          Federalist           [34m ║[m
[34m║ [m   3      March 4, 1801 - March 4, 1809   Thomas Jefferson    Democratic-Republican[34m ║[m
[34m║ [m   4      March 4, 1809 - March 4, 1817   James Madison       Democratic-Republican[34m ║[m
[34m║ [m   5      March 4, 1817 - March 4, 1825   James Monroe        Democratic-Republican[34m ║[m
[34m╚═════════════════════════════════════════════════════════════════════════════════════╝[m
'''));
    });

    test('rounded border vertical', () {
      final table = Table();
      table
        ..borderColor = ConsoleColor.green
        ..borderStyle = BorderStyle.rounded
        ..borderType = BorderType.vertical
        ..addColumnDefinition(header: 'Number', alignment: TextAlignment.right)
        ..addColumnDefinition(header: 'Presidency')
        ..addColumnDefinition(header: 'President')
        ..addRows(earlyPresidents.take(3).toList());

      expect(table.render(), equals('''
[32m╭────────┬────────────────────────────────┬───────────────────╮[m
[32m│ [mNumber[32m │ [mPresidency                    [32m │ [mPresident        [32m │[m
[32m│        │                                │                   │[m
[32m│ [m     1[32m │ [mApril 30, 1789 - March 4, 1797[32m │ [mGeorge Washington[32m │[m
[32m│ [m     2[32m │ [mMarch 4, 1797 - March 4, 1801 [32m │ [mJohn Adams       [32m │[m
[32m│ [m     3[32m │ [mMarch 4, 1801 - March 4, 1809 [32m │ [mThomas Jefferson [32m │[m
[32m╰────────┴────────────────────────────────┴───────────────────╯[m
'''));
    });

    test('wrapped text', () {
      final table = Table()
        ..borderStyle = BorderStyle.rounded
        ..borderType = BorderType.grid
        ..addColumnDefinition(header: 'Number', alignment: TextAlignment.center)
        ..addColumnDefinition(
            header: 'Presidency', alignment: TextAlignment.right, wrapWidth: 18)
        ..addColumnDefinition(header: 'President')
        ..addColumnDefinition(header: 'Party')
        ..addRows(earlyPresidents);

      expect(table.render(), equals('''
╭────────┬────────────────────────────────┬───────────────────┬───────────────────────╮
│ Number │                    Presidency  │ President         │ Party                 │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    1   │              April 30, 1789 -  │ George Washington │ unaffiliated          │
│        │                 March 4, 1797  │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    2   │               March 4, 1797 -  │ John Adams        │ Federalist            │
│        │                 March 4, 1801  │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    3   │               March 4, 1801 -  │ Thomas Jefferson  │ Democratic-Republican │
│        │                 March 4, 1809  │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    4   │               March 4, 1809 -  │ James Madison     │ Democratic-Republican │
│        │                 March 4, 1817  │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    5   │               March 4, 1817 -  │ James Monroe      │ Democratic-Republican │
│        │                 March 4, 1825  │                   │                       │
╰────────┴────────────────────────────────┴───────────────────┴───────────────────────╯
'''));
    });
  });
}
