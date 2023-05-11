import 'dart:io';

import 'package:dart_console/dart_console.dart';

void main() {
  final calendar = Calendar(DateTime(1969, 08, 15));
  // or
  // final calendar = Calendar.now();

  print(calendar);

  File('golden.txt').writeAsStringSync(calendar.toString());
}
