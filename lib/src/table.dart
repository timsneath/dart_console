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

class Table {
  // Row 0 is the header row
  final List<List<Object>> _table = [[]];

  int get columns => _table[0].length;

  ConsoleColor? borderColor;
  BorderType borderType = BorderType.header;
  BorderStyle borderStyle = BorderStyle.rounded;
  String title = '';
  FontStyle headerStyle = FontStyle.normal;

  final List<TextAlignment> _columnAlignments = <TextAlignment>[];
  final List<int> _wrapWidths = <int>[];

  void addColumnDefinition(
      {String header = '',
      TextAlignment alignment = TextAlignment.left,
      int wrapWidth = 0}) {
    _table[0].add(header);
    _columnAlignments.add(alignment);
    _wrapWidths.add(wrapWidth);

    // TODO: handle adding a column after one or more rows have been added
  }

  void addRow(List<Object> row) {
    // If rows added without a header definition, then we treat this as a
    // headerless table, and add an empty header row.
    if (_table[0].isEmpty) {
      _table[0] = List<String>.filled(row.length, '');
    }

    // Take as many elements as available, but pad as necessary
    final fullRow = [...row, for (var i = row.length; i < columns; i++) ''];
    _table.add(fullRow);
  }

  void addRows(List<List<Object>> rows) => rows.forEach(addRow);

  bool get hasBorder => borderStyle != BorderStyle.none;
  bool get hasHeader => _columnAlignments.isNotEmpty;

  BoxGlyphSet get borderGlyphs {
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
    if (!hasBorder) {
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
        maxLength = max(maxLength, row[column].toString().length);
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
    if (!hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = borderGlyphs.horizontalLine;
    } else {
      delimiter = [
        borderGlyphs.horizontalLine,
        borderType == BorderType.horizontal
            ? borderGlyphs.horizontalLine
            : borderGlyphs.teeDown,
        borderGlyphs.horizontalLine,
      ].join();
    }

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      borderGlyphs.topLeftCorner,
      borderGlyphs.horizontalLine,
      [for (final column in columnWidths) borderGlyphs.horizontalLine * column]
          .join(delimiter),
      borderGlyphs.horizontalLine,
      borderGlyphs.topRightCorner,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _tableRule(int tableWidth, List<int> columnWidths) {
    if (!hasBorder) return '';

    if (borderType == BorderType.outline) {
      return [
        if (borderColor != null)
          ansiSetColor(ansiForegroundColors[borderColor]!),
        borderGlyphs.verticalLine,
        ' ' * (tableWidth - 2),
        borderGlyphs.verticalLine,
        if (borderColor != null) ansiResetColor,
        '\n'
      ].join();
    }

    final delimiter = [
      borderType == BorderType.vertical ? ' ' : borderGlyphs.horizontalLine,
      if (borderType == BorderType.horizontal)
        borderGlyphs.horizontalLine
      else if (borderType == BorderType.vertical)
        borderGlyphs.verticalLine
      else
        borderGlyphs.cross,
      borderType == BorderType.vertical ? ' ' : borderGlyphs.horizontalLine,
    ].join();

    final horizontalLine =
        borderType == BorderType.vertical ? ' ' : borderGlyphs.horizontalLine;

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      borderType == BorderType.vertical
          ? borderGlyphs.verticalLine
          : borderGlyphs.teeRight,
      horizontalLine,
      [for (final column in columnWidths) horizontalLine * column]
          .join(delimiter),
      horizontalLine,
      borderType == BorderType.vertical
          ? borderGlyphs.verticalLine
          : borderGlyphs.teeLeft,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _tableEpilogue(int tableWidth, List<int> columnWidths) {
    if (!hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = borderGlyphs.horizontalLine;
    } else {
      delimiter = [
        borderGlyphs.horizontalLine,
        borderType == BorderType.horizontal
            ? borderGlyphs.horizontalLine
            : borderGlyphs.teeUp,
        borderGlyphs.horizontalLine,
      ].join();
    }

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      borderGlyphs.bottomLeftCorner,
      borderGlyphs.horizontalLine,
      [for (final column in columnWidths) borderGlyphs.horizontalLine * column]
          .join(delimiter),
      borderGlyphs.horizontalLine,
      borderGlyphs.bottomRightCorner,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String _rowStart() {
    if (!hasBorder) return '';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      borderGlyphs.verticalLine,
      ' ',
      if (borderColor != null) ansiResetColor,
    ].join();
  }

  String _rowDelimiter() {
    if (!hasBorder) return ' ';

    if (borderType == BorderType.outline) return ' ';
    if (borderType == BorderType.horizontal) return '   ';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      ' ',
      borderGlyphs.verticalLine,
      ' ',
      if (borderColor != null) ansiResetColor,
    ].join();
  }

  String _rowEnd() {
    if (!hasBorder) return '\n';

    return [
      if (borderColor != null) ansiSetColor(ansiForegroundColors[borderColor]!),
      ' ',
      borderGlyphs.verticalLine,
      if (borderColor != null) ansiResetColor,
      '\n',
    ].join();
  }

  String setFontStyle(FontStyle style) {
    return ansiSetTextStyles(
        bold: (style == FontStyle.bold || style == FontStyle.boldUnderscore),
        underscore: (style == FontStyle.underscore ||
            style == FontStyle.boldUnderscore));
  }

  String resetFontStyle() => ansiResetColor;

  String render() {
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
    final startRow = hasHeader ? 0 : 1;
    for (int row = startRow; row < _table.length; row++) {
      final wrappedRow = <String>[];
      for (int column = 0; column < columns; column++) {
        // Wrap the text if there's a viable width
        if (column < _wrapWidths.length && _wrapWidths[column] > 0) {
          wrappedRow.add(
              _table[row][column].toString().wrapText(_wrapWidths[column]));
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
            buffer.write(setFontStyle(headerStyle));
          }
          buffer.write(cell.alignText(
              width: columnWidths[column], alignment: columnAlignment));
          if (row == 0 && headerStyle != FontStyle.normal) {
            buffer.write(resetFontStyle());
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

    return buffer.toString();
  }
}
