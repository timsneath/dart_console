import 'dart:math' show max;

import 'package:dart_console/src/ansi.dart';

import 'enums.dart';
import 'string_utils.dart';

enum BorderStyle { none, ascii, square, rounded, bold, double }

enum BorderType { outline, header, grid, vertical, horizontal }

enum FontStyle { normal, bold, underscore, boldUnderscore }

class BoxGlyphSet {
  final String? glyphs;
  const BoxGlyphSet(this.glyphs);

  String get horizontalLine => glyphs?[0] ?? '';
  String get verticalLine => glyphs?[1] ?? '';
  String get topLeftCorner => glyphs?[2] ?? '';
  String get topRightCorner => glyphs?[3] ?? '';
  String get bottomLeftCorner => glyphs?[4] ?? '';
  String get bottomRightCorner => glyphs?[5] ?? '';
  String get cross => glyphs?[6] ?? '';
  String get teeUp => glyphs?[7] ?? '';
  String get teeDown => glyphs?[8] ?? '';
  String get teeLeft => glyphs?[9] ?? '';
  String get teeRight => glyphs?[10] ?? '';

  factory BoxGlyphSet.none() {
    return BoxGlyphSet(null);
  }

  factory BoxGlyphSet.ascii() {
    return BoxGlyphSet('-|----+--||');
  }

  factory BoxGlyphSet.square() {
    return BoxGlyphSet('─│┌┐└┘┼┴┬┤├');
  }

  factory BoxGlyphSet.rounded() {
    return BoxGlyphSet('─│╭╮╰╯┼┴┬┤├');
  }

  factory BoxGlyphSet.bold() {
    return BoxGlyphSet('━┃┏┓┗┛╋┻┳┫┣');
  }

  factory BoxGlyphSet.double() {
    return BoxGlyphSet('═║╔╗╚╝╬╩╦╣╠');
  }
}

/// An experimental class for drawing tables. The API is not final yet.
class Table {
  // The data model for table layout consists of three primary objects:
  //
  // - _table contains the cell data in rows.
  // - _columnAlignments contains text justification settings for each column.
  // - _columnWidths contains the width of each column. By default, columns size
  //   to content, but by setting a custom column width the table should wrap at
  //   that point.
  //
  // It is important that _columnAlignments and _columnWidths have the same
  // number of elements as _table[n], and that _table is not a ragged array. A
  // consumer of the table will not directly manipulate these members, but will
  // instead call methods like insertColumn, deleteRow, etc. to ensure that the
  // internal data structure remains consistent.
  final List<List<Object>> _table = [[]];
  final List<TextAlignment> _columnAlignments = <TextAlignment>[];
  final List<int> _columnWidths = <int>[];

  // Class members that manage the style and formatting of the table follow.
  // These may be manipulated directly.

  /// A title to be displayed above the table.
  String title = '';

  /// The font formatting for the table header row.
  ///
  /// By default, headers are rendered in the same way as the rest of the table,
  /// but you can specify a different format.
  FontStyle headerStyle = FontStyle.normal;

  // TODO: Add headerColor

  /// The color to be used for rendering the table border.
  ConsoleColor? borderColor;

  /// Whether line separators should be drawn between rows and columns, and
  /// whether the table should include a border.
  ///
  /// Options available:
  ///
  /// - `grid`: draw an outline box and a rule line between each row
  ///   and column.
  /// - `header`: draw a line border around the table with a rule line between
  ///   the table header and the rows,
  /// - `horizontal`: draw rule lines between each row only.
  /// - `vertical`: draw rule lines between each column only.
  /// - `outline`: draw an outline box, with no rule lines between rows
  ///   and columns.
  ///
  /// The default is `header`, drawing outline box and header borders only.
  ///
  /// To display a table with no borders, instead set the [borderStyle] property
  /// to [BorderStyle.none].
  // TODO: Add BorderType.interior that is grid without outline
  BorderType borderType = BorderType.header;

  /// Which line drawing characters are used to display boxes.
  ///
  /// Options available:
  ///
  /// - `ascii`: use simple ASCII characters. Suitable for a very limited
  ///   terminal environment: ------
  /// - `bold`: use bold line drawing characters: ┗━━━━┛
  /// - `double`: use double border characters: ╚════╝
  /// - `none`: do not draw any borders
  /// - `rounded`: regular thickness borders with rounded corners: ╰────╯
  /// - `square`: regular thickness borders that have sharp corners: └────┘
  ///
  /// The default is to draw rounded borders.
  BorderStyle borderStyle = BorderStyle.rounded;

  // Properties

  /// Returns the number of columns in the table.
  ///
  /// To add a new column, use [insertColumn].
  int get columns => _table[0].length;

  /// Returns the number of rows in the table.
  int get rows => _table.length - 1;

  // Methods to manipulate the table structure.

  /// Insert a new column into the table.
  ///
  /// If a width is specified, this is used to wrap the table contents. If no
  /// width is specified, the column will be set to the maximum width of content
  /// in the cell.
  ///
  /// An index may be specified with a value from 0..[columns] to insert the
  /// column in a specific location.
  void insertColumn(
      {String header = '',
      TextAlignment alignment = TextAlignment.left,
      int width = 0,
      int? index}) {
    final insertIndex = index ?? _table[0].length;
    _table[0].insert(insertIndex, header);
    _columnAlignments.insert(insertIndex, alignment);
    _columnWidths.insert(insertIndex, width);

    // Skip header and add empty cells
    for (var i = 1; i < _table.length; i++) {
      _table[i].insert(insertIndex, '');
    }
  }

  /// Removes the column with given index.
  ///
  /// The index must be in the range 0..[columns]-1.
  void deleteColumn({required int index}) {
    if (index >= _table[0].length || index < 0) {
      throw ArgumentError('index must be a valid column index');
    }

    for (var row in _table) {
      row.removeAt(index);
    }

    if (_columnAlignments.isNotEmpty) _columnAlignments.removeAt(index);
    if (_columnWidths.isNotEmpty) _columnWidths.removeAt(index);
  }

  /// Adds a new row to the table.
  void addRow(List<Object> row) {
    // If rows added without a header definition, then we treat this as a
    // headerless table, and add an empty header row.
    if (_table[0].isEmpty) {
      _table[0] = List<String>.filled(row.length, '', growable: true);
    }

    // TODO: If when a row is first added, no column definitions exist, add
    //       default definitions. Then remove the check in deleteColumn.

    // Take as many elements as available, but pad as necessary
    final fullRow = [...row, for (var i = row.length; i < columns; i++) ''];
    _table.add(fullRow);
  }

  void addRows(List<List<Object>> rows) => rows.forEach(addRow);

  bool get _hasBorder => borderStyle != BorderStyle.none;
  bool get _hasHeader => _columnAlignments.isNotEmpty;

  BoxGlyphSet get _borderGlyphs {
    switch (borderStyle) {
      case BorderStyle.none:
        return BoxGlyphSet.none();
      case BorderStyle.ascii:
        return BoxGlyphSet.ascii();
      case BorderStyle.square:
        return BoxGlyphSet.square();
      case BorderStyle.bold:
        return BoxGlyphSet.bold();
      case BorderStyle.double:
        return BoxGlyphSet.double();
      default:
        return BoxGlyphSet.rounded();
    }
  }

  int _calculateTableWidth() {
    if (_table[0].isEmpty) return 0;

    final columnWidths =
        _calculateColumnWidths().reduce((value, element) => value + element);

    // Allow padding: either a single space between columns if no border, or
    // a padded vertical marker between columns.
    if (!_hasBorder) {
      return columnWidths + columns - 1;
    } else {
      if (borderType == BorderType.outline) {
        return columnWidths + 4 + columns - 1;
      } else {
        return columnWidths + 4 + (3 * (columns - 1));
      }
    }
  }

  List<int> _calculateColumnWidths() {
    return List<int>.generate(columns, (column) {
      int maxLength = 0;
      for (final row in _table) {
        maxLength = max(
            maxLength, row[column].toString().stripEscapeCharacters().length);
      }
      return maxLength;
    }, growable: false);
  }

  int _calculateRowHeight(List<String> row) {
    int maxHeight = 1;
    for (final column in row) {
      maxHeight = max(maxHeight, column.toString().split('\n').length);
    }
    return maxHeight;
  }

  String _tablePrologue(int tableWidth, List<int> columnWidths) {
    if (!_hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = _borderGlyphs.horizontalLine;
    } else {
      delimiter = [
        _borderGlyphs.horizontalLine,
        borderType == BorderType.horizontal
            ? _borderGlyphs.horizontalLine
            : _borderGlyphs.teeDown,
        _borderGlyphs.horizontalLine,
      ].join();
    }

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      _borderGlyphs.topLeftCorner,
      _borderGlyphs.horizontalLine,
      [for (final column in columnWidths) _borderGlyphs.horizontalLine * column]
          .join(delimiter),
      _borderGlyphs.horizontalLine,
      _borderGlyphs.topRightCorner,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _tableRule(int tableWidth, List<int> columnWidths) {
    if (!_hasBorder) return '';

    if (borderType == BorderType.outline) {
      return [
        if (borderColor != null)
          ansiSetColor(ansiForegroundColors[borderColor]!),
        _borderGlyphs.verticalLine,
        ' ' * (tableWidth - 2),
        _borderGlyphs.verticalLine,
        if (borderColor != null) ansiResetColor,
        '\n'
      ].join();
    }

    final delimiter = [
      borderType == BorderType.vertical ? ' ' : _borderGlyphs.horizontalLine,
      if (borderType == BorderType.horizontal)
        _borderGlyphs.horizontalLine
      else if (borderType == BorderType.vertical)
        _borderGlyphs.verticalLine
      else
        _borderGlyphs.cross,
      borderType == BorderType.vertical ? ' ' : _borderGlyphs.horizontalLine,
    ].join();

    final horizontalLine =
        borderType == BorderType.vertical ? ' ' : _borderGlyphs.horizontalLine;

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      borderType == BorderType.vertical
          ? _borderGlyphs.verticalLine
          : _borderGlyphs.teeRight,
      horizontalLine,
      [for (final column in columnWidths) horizontalLine * column]
          .join(delimiter),
      horizontalLine,
      borderType == BorderType.vertical
          ? _borderGlyphs.verticalLine
          : _borderGlyphs.teeLeft,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _tableEpilogue(int tableWidth, List<int> columnWidths) {
    if (!_hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = _borderGlyphs.horizontalLine;
    } else {
      delimiter = [
        _borderGlyphs.horizontalLine,
        borderType == BorderType.horizontal
            ? _borderGlyphs.horizontalLine
            : _borderGlyphs.teeUp,
        _borderGlyphs.horizontalLine,
      ].join();
    }

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      _borderGlyphs.bottomLeftCorner,
      _borderGlyphs.horizontalLine,
      [for (final column in columnWidths) _borderGlyphs.horizontalLine * column]
          .join(delimiter),
      _borderGlyphs.horizontalLine,
      _borderGlyphs.bottomRightCorner,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _rowStart() {
    if (!_hasBorder) return '';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      _borderGlyphs.verticalLine,
      ' ',
      if (borderColor != null) ansiResetColor,
    ].join();
  }

  String _rowDelimiter() {
    if (!_hasBorder) return ' ';

    if (borderType == BorderType.outline) return ' ';
    if (borderType == BorderType.horizontal) return '   ';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      ' ',
      _borderGlyphs.verticalLine,
      ' ',
      if (borderColor != null) ansiResetColor,
    ].join();
  }

  String _rowEnd() {
    if (!_hasBorder) return '\n';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      ' ',
      _borderGlyphs.verticalLine,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _setFontStyle(FontStyle style) {
    return ansiSetTextStyles(
        bold: (style == FontStyle.bold || style == FontStyle.boldUnderscore),
        underscore: (style == FontStyle.underscore ||
            style == FontStyle.boldUnderscore));
  }

  String _resetFontStyle() => ansiResetColor;

  /// Renders the table as a string, for printing or further manipulation.
  String render({bool plainText = false}) {
    if (_table[0].isEmpty) return '';

    final buffer = StringBuffer();

    final tableWidth = _calculateTableWidth();
    final columnWidths = _calculateColumnWidths();

    // Title
    if (title != '') {
      buffer.writeln([
        ansiSetTextStyles(bold: true),
        title.alignText(width: tableWidth, alignment: TextAlignment.center),
        ansiResetColor,
      ].join());
    }

    // Top line of table bounding box
    buffer.write(_tablePrologue(tableWidth, columnWidths));

    // Print table rows
    final startRow = _hasHeader ? 0 : 1;
    for (int row = startRow; row < _table.length; row++) {
      final wrappedRow = <String>[];
      for (int column = 0; column < columns; column++) {
        // Wrap the text if there's a viable width
        if (column < _columnWidths.length && _columnWidths[column] > 0) {
          wrappedRow.add(
              _table[row][column].toString().wrapText(_columnWidths[column]));
        } else {
          wrappedRow.add(_table[row][column].toString());
        }
      }
      // Count number of lines in each row
      final rowHeight = _calculateRowHeight(wrappedRow);

      for (int line = 0; line < rowHeight; line++) {
        buffer.write(_rowStart());

        for (int column = 0; column < columns; column++) {
          final lines = wrappedRow[column].toString().split('\n');
          final cell = line < lines.length ? lines[line] : '';
          final columnAlignment = column < _columnAlignments.length
              ? _columnAlignments[column]
              : TextAlignment.left;

          // Write text, with header formatting if appropriate
          if (row == 0 && headerStyle != FontStyle.normal) {
            buffer.write(_setFontStyle(headerStyle));
          }
          buffer.write(cell.alignText(
              width: columnWidths[column], alignment: columnAlignment));
          if (row == 0 && headerStyle != FontStyle.normal) {
            buffer.write(_resetFontStyle());
          }

          if (column < columns - 1) {
            buffer.write(_rowDelimiter());
          }
        }

        buffer.write(_rowEnd());
      }

      // Print a rule line underneath the header only
      if (row == 0) {
        buffer.write(_tableRule(tableWidth, columnWidths));
      }

      // Print a rule line after all internal rows for grid type
      else if (borderType == BorderType.grid && row != _table.length - 1) {
        buffer.write(_tableRule(tableWidth, columnWidths));
      }
    }
    buffer.write(_tableEpilogue(tableWidth, columnWidths));

    if (plainText) {
      return buffer.toString().stripEscapeCharacters();
    } else {
      return buffer.toString();
    }
  }

  @override
  String toString() => render();
}
