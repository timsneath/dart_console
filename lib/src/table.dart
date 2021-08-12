import 'dart:math' show max;

import 'enums.dart';
import 'string_utils.dart';

enum BorderStyle { none, ascii, normal, bold, double }
enum BorderType { outline, header, grid }

class BorderGlyphSet {
  final String? glyphs;
  const BorderGlyphSet(this.glyphs);

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

  factory BorderGlyphSet.none() {
    return BorderGlyphSet(null);
  }

  factory BorderGlyphSet.ascii() {
    return BorderGlyphSet('-|----+--||');
  }

  factory BorderGlyphSet.normal() {
    return BorderGlyphSet('─│┌┐└┘┼┴┬┤├');
  }

  factory BorderGlyphSet.bold() {
    return BorderGlyphSet('━┃┏┓┗┛╋┻┳┫┣');
  }

  factory BorderGlyphSet.double() {
    return BorderGlyphSet('═║╔╗╚╝╬╩╦╣╠');
  }
}

class Table {
  // Row 0 is the header row
  final List<List<Object>> _table = [[]];

  int get columns => _table[0].length;

  BorderGlyphSet borderGlyphs = BorderGlyphSet.normal();
  bool hasBorder = true;
  BorderType borderType = BorderType.header;

  final List<TextAlignment> _columnAlignments = [];

  List<int> get _maxColumnLengths => List<int>.generate(columns, (column) {
        int maxLength = 0;
        for (final row in _table) {
          maxLength = max(maxLength, row[column].toString().length);
        }
        return maxLength;
      }, growable: false);

  void addColumnDefinition(
      {String header = '', TextAlignment alignment = TextAlignment.left}) {
    _table[0].add(header);
    _columnAlignments.add(alignment);

    // TODO: handle adding a column after one or more rows have been added
  }

  void addRow(List<Object> row) {
    // Take as many elements as available, but pad as necessary
    final fullRow = [...row, for (var i = row.length; i < columns; i++) ''];
    _table.add(fullRow);
  }

  void addRows(List<List<Object>> rows) {
    for (final row in rows) {
      addRow(row);
    }
  }

  void setBorderStyle(BorderStyle borderStyle) {
    hasBorder = true;

    switch (borderStyle) {
      case BorderStyle.none:
        borderGlyphs = BorderGlyphSet.none();
        hasBorder = false;
        break;
      case BorderStyle.ascii:
        borderGlyphs = BorderGlyphSet.ascii();
        break;
      case BorderStyle.bold:
        borderGlyphs = BorderGlyphSet.bold();
        break;
      case BorderStyle.double:
        borderGlyphs = BorderGlyphSet.double();
        break;
      default:
        borderGlyphs = BorderGlyphSet.normal();
    }
  }

  void setBorderType(BorderType borderType) {
    this.borderType = borderType;
  }

  int _calculateTableWidth() {
    final columnWidths =
        _maxColumnLengths.reduce((value, element) => value + element);

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

  String _tablePrologue(int tableWidth, List<int> columnWidths) {
    if (!hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = borderGlyphs.horizontalLine;
    } else {
      delimiter = '${borderGlyphs.horizontalLine}'
          '${borderGlyphs.teeDown}'
          '${borderGlyphs.horizontalLine}';
    }

    return [
      borderGlyphs.topLeftCorner,
      borderGlyphs.horizontalLine,
      [for (final column in columnWidths) borderGlyphs.horizontalLine * column]
          .join(delimiter),
      borderGlyphs.horizontalLine,
      borderGlyphs.topRightCorner,
      '\n',
    ].join();
  }

  String _tableRule(int tableWidth, List<int> columnWidths) {
    if (!hasBorder) return '';

    final delimiter = '${borderGlyphs.horizontalLine}'
        '${borderGlyphs.cross}'
        '${borderGlyphs.horizontalLine}';

    return [
      borderGlyphs.teeRight,
      borderGlyphs.horizontalLine,
      [for (final column in columnWidths) borderGlyphs.horizontalLine * column]
          .join(delimiter),
      borderGlyphs.horizontalLine,
      borderGlyphs.teeLeft,
      '\n',
    ].join();
  }

  String _tableEpilogue(int tableWidth, List<int> columnWidths) {
    if (!hasBorder) return '';

    String delimiter;

    if (borderType == BorderType.outline) {
      delimiter = borderGlyphs.horizontalLine;
    } else {
      delimiter = '${borderGlyphs.horizontalLine}'
          '${borderGlyphs.teeUp}'
          '${borderGlyphs.horizontalLine}';
    }

    return [
      borderGlyphs.bottomLeftCorner,
      borderGlyphs.horizontalLine,
      [for (final column in columnWidths) borderGlyphs.horizontalLine * column]
          .join(delimiter),
      borderGlyphs.horizontalLine,
      borderGlyphs.bottomRightCorner,
      '\n',
    ].join();
  }

  String _rowStart() {
    if (hasBorder) {
      return '${borderGlyphs.verticalLine} ';
    } else {
      return '';
    }
  }

  String _rowDelimiter() {
    if (hasBorder && borderType != BorderType.outline) {
      return ' ${borderGlyphs.verticalLine} ';
    } else {
      return ' ';
    }
  }

  String _rowEnd() {
    if (hasBorder) {
      return ' ${borderGlyphs.verticalLine}\n';
    } else {
      return '\n';
    }
  }

  String render() {
    final buffer = StringBuffer();

    final columnWidths = _maxColumnLengths;
    var tableWidth = _calculateTableWidth();

    buffer.write(_tablePrologue(tableWidth, columnWidths));

    // print table rows
    for (int row = 0; row < _table.length; row++) {
      buffer.write(_rowStart());

      for (int column = 0; column < columns; column++) {
        final cell = _table[row][column].toString();

        buffer.write(cell.alignText(
            width: columnWidths[column], alignment: _columnAlignments[column]));

        if (column < columns - 1) {
          buffer.write(_rowDelimiter());
        }
      }

      buffer.write(_rowEnd());

      // Print a rule line underneath the header only
      if (borderType == BorderType.header && row == 0) {
        buffer.write(_tableRule(tableWidth, columnWidths));
      }

      // Print a rule line after all internal rows for grid type
      if (borderType == BorderType.grid && row != _table.length - 1) {
        buffer.write(_tableRule(tableWidth, columnWidths));
      }
    }
    buffer.write(_tableEpilogue(tableWidth, columnWidths));

    return buffer.toString();
  }
}
