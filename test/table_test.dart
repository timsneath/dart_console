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

const planets = [
  ['Mercury', '5.7909227 × 10⁷'],
  ['Venus', '1.0820948 × 10⁸'],
  ['Earth', '1.4959826 × 10⁸'],
  ['Mars', '2.2794382 × 10⁸'],
  ['Jupiter', '7.7834082 × 10⁸'],
  ['Saturn', '1.4266664 × 10⁹'],
  ['Uranus', '2.8706582 × 10⁹'],
  ['Neptune', '4.4983964 × 10⁹'],
  // sorry Pluto :(
];

void main() {
  group('Table operations', () {
    test('Empty table should not render', () {
      final table = Table();
      expect(table.toString(), isEmpty);
    });

    test('Table with no column defs should not render header', () {
      final table = Table()..addRows(earlyPresidents);
      expect(table.toString(), equals('''
╭───┬────────────────────────────────┬───────────────────┬───────────────────────╮
│ 1 │ April 30, 1789 - March 4, 1797 │ George Washington │ unaffiliated          │
│ 2 │ March 4, 1797 - March 4, 1801  │ John Adams        │ Federalist            │
│ 3 │ March 4, 1801 - March 4, 1809  │ Thomas Jefferson  │ Democratic-Republican │
│ 4 │ March 4, 1809 - March 4, 1817  │ James Madison     │ Democratic-Republican │
│ 5 │ March 4, 1817 - March 4, 1825  │ James Monroe      │ Democratic-Republican │
╰───┴────────────────────────────────┴───────────────────┴───────────────────────╯
'''));
    });

    test('Can add columns and make other changes after table is defined', () {
      final table = Table()
        ..insertColumn(header: 'Planet')
        ..insertColumn(
            header: 'Orbital Distance', alignment: TextAlignment.right)
        ..addRows(planets)
        ..borderStyle = BorderStyle.square;

      table
        ..insertColumn(header: 'Mass')
        ..insertColumn(header: 'Radius', index: 1)
        ..insertColumn(header: 'Density')
        ..borderStyle = BorderStyle.rounded;

      expect(table.toString(), equals('''
╭─────────┬────────┬──────────────────┬──────┬─────────╮
│ Planet  │ Radius │ Orbital Distance │ Mass │ Density │
├─────────┼────────┼──────────────────┼──────┼─────────┤
│ Mercury │        │  5.7909227 × 10⁷ │      │         │
│ Venus   │        │  1.0820948 × 10⁸ │      │         │
│ Earth   │        │  1.4959826 × 10⁸ │      │         │
│ Mars    │        │  2.2794382 × 10⁸ │      │         │
│ Jupiter │        │  7.7834082 × 10⁸ │      │         │
│ Saturn  │        │  1.4266664 × 10⁹ │      │         │
│ Uranus  │        │  2.8706582 × 10⁹ │      │         │
│ Neptune │        │  4.4983964 × 10⁹ │      │         │
╰─────────┴────────┴──────────────────┴──────┴─────────╯
'''));
    });

    test('Removing all columns should leave an empty table', () {
      final table = Table()..addRows(planets);
      table
        ..deleteColumn(index: 1)
        ..deleteColumn(index: 0);
      expect(table.toString(), isEmpty);
    });

    test('Not possible to remove more columns than exist', () {
      final table = Table()..addRows(planets);
      table
        ..deleteColumn(index: 1)
        ..deleteColumn(index: 0);
      expect(() => table.deleteColumn(index: 0), throwsArgumentError);
    });

    test('Add rows without column definitions should give a sane result', () {
      final table = Table()..addRows(planets);
      expect(table.toString(), equals('''
╭─────────┬─────────────────╮
│ Mercury │ 5.7909227 × 10⁷ │
│ Venus   │ 1.0820948 × 10⁸ │
│ Earth   │ 1.4959826 × 10⁸ │
│ Mars    │ 2.2794382 × 10⁸ │
│ Jupiter │ 7.7834082 × 10⁸ │
│ Saturn  │ 1.4266664 × 10⁹ │
│ Uranus  │ 2.8706582 × 10⁹ │
│ Neptune │ 4.4983964 × 10⁹ │
╰─────────┴─────────────────╯
'''));
    });
  });

  group('Table formatting', () {
    test('None', () {
      final table = Table()
        ..borderStyle = BorderStyle.none
        ..headerStyle = FontStyle.underscore
        ..insertColumn(header: 'Fruit')
        ..insertColumn(header: 'Qty', alignment: TextAlignment.right)
        ..addRows([
          ['apples', 10],
          ['bananas', 5],
          ['apricots', 7]
        ]);
      expect(table.toString(), equals('''
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
        ..insertColumn(header: 'Fruit')
        ..insertColumn(header: 'Qty', alignment: TextAlignment.right)
        ..insertColumn(header: 'Notes')
        ..addRows([
          ['apples', '10'],
          ['bananas', '5'],
          ['apricots', '7']
        ])
        ..addRow(['dates', '10000', 'a big number'])
        ..addRow(['kumquats', '59']);
      expect(table.toString(), equals('''
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
        ..insertColumn(header: 'Fruit')
        ..insertColumn(header: 'Qty', alignment: TextAlignment.right)
        ..insertColumn(header: 'Notes')
        ..addRows([
          ['apples', '10'],
          ['bananas', '5'],
          ['apricots', '7']
        ])
        ..addRow(['dates', '10000', 'a big number'])
        ..addRow(['kumquats', '59']);
      expect(table.toString(), equals('''
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
        ..insertColumn(header: 'Fruit')
        ..insertColumn(header: 'Qty', alignment: TextAlignment.right)
        ..addRows([
          ['apples', 10],
          ['bananas', 5],
          ['apricots', 7]
        ]);
      expect(table.toString(), equals('''
----------------
| Fruit    Qty |
|              |
| apples    10 |
| bananas    5 |
| apricots   7 |
----------------
'''));
    });

    test('Borderless table', () {
      final table = Table()
        ..borderStyle = BorderStyle.none
        ..borderType = BorderType.header
        ..insertColumn(header: 'Fruit')
        ..insertColumn(header: 'Qty', alignment: TextAlignment.right)
        ..insertColumn(header: 'Notes')
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
      expect(table.toString(), equals(golden));

      // Changing border type shouldn't have any impact if there's no border
      table.borderType = BorderType.grid;
      expect(table.toString(), equals(golden));

      table.borderType = BorderType.outline;
      expect(table.toString(), equals(golden));
    });

    test('Glyphs', () {
      final table = Table()
        ..insertColumn(header: 'Number', alignment: TextAlignment.right)
        ..insertColumn(header: 'Presidency')
        ..insertColumn(header: 'President')
        ..insertColumn(header: 'Party')
        ..addRows(earlyPresidents)
        ..borderStyle = BorderStyle.square;

      expect(table.toString(), equals('''
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

    test('Color border', () {
      final table = Table()
        ..borderColor = ConsoleColor.brightCyan
        ..borderStyle = BorderStyle.bold
        ..insertColumn(header: 'Number', alignment: TextAlignment.right)
        ..insertColumn(header: 'Presidency')
        ..insertColumn(header: 'President')
        ..insertColumn(header: 'Party')
        ..addRows(earlyPresidents);

      expect(table.toString(), equals('''
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

    test('Horizontal double border', () {
      final table = Table()
        ..borderColor = ConsoleColor.blue
        ..borderStyle = BorderStyle.double
        ..borderType = BorderType.horizontal
        ..insertColumn(header: 'Number', alignment: TextAlignment.center)
        ..insertColumn(header: 'Presidency', alignment: TextAlignment.right)
        ..insertColumn(header: 'President')
        ..insertColumn(header: 'Party')
        ..addRows(earlyPresidents);

      expect(table.toString(), equals('''
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

    test('Rounded border vertical', () {
      final table = Table();
      table
        ..borderColor = ConsoleColor.green
        ..borderStyle = BorderStyle.rounded
        ..borderType = BorderType.vertical
        ..insertColumn(header: 'Number', alignment: TextAlignment.right)
        ..insertColumn(header: 'Presidency')
        ..insertColumn(header: 'President')
        ..addRows(earlyPresidents.take(3).toList());

      expect(table.toString(), equals('''
[32m╭────────┬────────────────────────────────┬───────────────────╮[m
[32m│ [mNumber[32m │ [mPresidency                    [32m │ [mPresident        [32m │[m
[32m│        │                                │                   │[m
[32m│ [m     1[32m │ [mApril 30, 1789 - March 4, 1797[32m │ [mGeorge Washington[32m │[m
[32m│ [m     2[32m │ [mMarch 4, 1797 - March 4, 1801 [32m │ [mJohn Adams       [32m │[m
[32m│ [m     3[32m │ [mMarch 4, 1801 - March 4, 1809 [32m │ [mThomas Jefferson [32m │[m
[32m╰────────┴────────────────────────────────┴───────────────────╯[m
'''));
    });

    test('Wrapped text', () {
      final table = Table()
        ..borderStyle = BorderStyle.rounded
        ..borderType = BorderType.grid
        ..insertColumn(header: 'Number', alignment: TextAlignment.center)
        ..insertColumn(
            header: 'Presidency', alignment: TextAlignment.right, width: 18)
        ..insertColumn(header: 'President')
        ..insertColumn(header: 'Party')
        ..addRows(earlyPresidents);

      expect(table.toString(), equals('''
╭────────┬────────────────────────────────┬───────────────────┬───────────────────────╮
│ Number │                     Presidency │ President         │ Party                 │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    1   │               April 30, 1789 - │ George Washington │ unaffiliated          │
│        │                  March 4, 1797 │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    2   │                March 4, 1797 - │ John Adams        │ Federalist            │
│        │                  March 4, 1801 │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    3   │                March 4, 1801 - │ Thomas Jefferson  │ Democratic-Republican │
│        │                  March 4, 1809 │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    4   │                March 4, 1809 - │ James Madison     │ Democratic-Republican │
│        │                  March 4, 1817 │                   │                       │
├────────┼────────────────────────────────┼───────────────────┼───────────────────────┤
│    5   │                March 4, 1817 - │ James Monroe      │ Democratic-Republican │
│        │                  March 4, 1825 │                   │                       │
╰────────┴────────────────────────────────┴───────────────────┴───────────────────────╯
'''));
    });

    test('Borders do not render when style is none', () {
      final table = Table()
        ..insertColumn(header: 'Planet')
        ..insertColumn(
            header: 'Orbital Distance', alignment: TextAlignment.right)
        ..addRows(planets)
        ..headerStyle = FontStyle.boldUnderscore
        ..borderStyle = BorderStyle.none
        ..borderColor = ConsoleColor.brightRed
        ..borderType = BorderType.vertical;

      expect(table.toString(), equals('''
[1;4mPlanet [m [1;4mOrbital Distance[m
Mercury  5.7909227 × 10⁷
Venus    1.0820948 × 10⁸
Earth    1.4959826 × 10⁸
Mars     2.2794382 × 10⁸
Jupiter  7.7834082 × 10⁸
Saturn   1.4266664 × 10⁹
Uranus   2.8706582 × 10⁹
Neptune  4.4983964 × 10⁹
'''));
    });

    test('Outline table has rule line with right colors', () {
      final table = Table()
        ..insertColumn(header: 'Planet')
        ..insertColumn(
            header: 'Orbital Distance', alignment: TextAlignment.right)
        ..addRows(planets)
        ..headerStyle = FontStyle.bold
        ..borderColor = ConsoleColor.brightRed
        ..borderType = BorderType.outline;

      expect(table.toString(), equals('''
[91m╭──────────────────────────╮[m
[91m│ [m[1mPlanet [m [1mOrbital Distance[m[91m │[m
[91m│                          │[m
[91m│ [mMercury  5.7909227 × 10⁷[91m │[m
[91m│ [mVenus    1.0820948 × 10⁸[91m │[m
[91m│ [mEarth    1.4959826 × 10⁸[91m │[m
[91m│ [mMars     2.2794382 × 10⁸[91m │[m
[91m│ [mJupiter  7.7834082 × 10⁸[91m │[m
[91m│ [mSaturn   1.4266664 × 10⁹[91m │[m
[91m│ [mUranus   2.8706582 × 10⁹[91m │[m
[91m│ [mNeptune  4.4983964 × 10⁹[91m │[m
[91m╰──────────────────────────╯[m
'''));
    });

    test('Can strip out ANSI formatting successfully', () {
      final table = Table()
        ..insertColumn(header: 'Number', alignment: TextAlignment.right)
        ..insertColumn(header: 'Presidency')
        ..insertColumn(header: 'President')
        ..insertColumn(header: 'Party')
        ..addRows(earlyPresidents)
        ..borderStyle = BorderStyle.square
        ..borderColor = ConsoleColor.brightBlue
        ..borderType = BorderType.vertical
        ..headerStyle = FontStyle.bold;

      expect(table.render(plainText: true), equals('''
┌────────┬────────────────────────────────┬───────────────────┬───────────────────────┐
│ Number │ Presidency                     │ President         │ Party                 │
│        │                                │                   │                       │
│      1 │ April 30, 1789 - March 4, 1797 │ George Washington │ unaffiliated          │
│      2 │ March 4, 1797 - March 4, 1801  │ John Adams        │ Federalist            │
│      3 │ March 4, 1801 - March 4, 1809  │ Thomas Jefferson  │ Democratic-Republican │
│      4 │ March 4, 1809 - March 4, 1817  │ James Madison     │ Democratic-Republican │
│      5 │ March 4, 1817 - March 4, 1825  │ James Monroe      │ Democratic-Republican │
└────────┴────────────────────────────────┴───────────────────┴───────────────────────┘
'''));
    });
  });
}
