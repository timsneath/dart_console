import 'package:dart_console/src/ansi.dart';
import 'package:intl/intl.dart';

import 'consolecolor.dart';
import 'table.dart';
import 'textalignment.dart';

class Calendar extends Table {
  final DateTime calendarDate;
  bool highlightTodaysDate = true;

  List<String> dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  Calendar(DateTime dateTime)
      : calendarDate = dateTime.subtract(Duration(days: dateTime.day - 1)) {
    for (final day in dayLabels) {
      insertColumn(header: day, alignment: TextAlignment.right);
    }

    // ISO format has 1..7 for Mon..Sun, so we adjust this to match the array
    final startDate = calendarDate.weekday == 7 ? 0 : calendarDate.weekday;

    final todayColor = ConsoleColor.brightYellow.ansiSetForegroundColorSequence;

    final calendarDates = <String>[
      for (int i = 0; i < startDate; i++) '',
      for (int i = 1; i <= 31; i++)
        if (calendarDate.add(Duration(days: i - 1)).month == calendarDate.month)
          if (calendarDate.year == DateTime.now().year &&
              calendarDate.month == DateTime.now().month &&
              i == DateTime.now().day)
            '$todayColor$i$ansiResetColor'
          else
            '$i',
    ];

    while (true) {
      insertRow(calendarDates.take(7).toList());
      if (calendarDates.length > 7) {
        calendarDates.removeRange(0, 7);
      } else {
        break;
      }
    }

    title = DateFormat('MMMM yyyy').format(calendarDate);
  }

  factory Calendar.now() => Calendar(DateTime.now());
}
