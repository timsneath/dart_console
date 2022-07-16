import 'package:dart_console/dart_console.dart';
import 'dart:io';

void main() {
  final calendar = Calendar(DateTime(1969, 08, 15));
  // or
  // final calendar = Calendar.now();

  print(calendar);

  final golden = File('golden.txt').openSync(mode: FileMode.writeOnly);
  golden.writeStringSync(calendar.toString());
  golden.closeSync();
}
