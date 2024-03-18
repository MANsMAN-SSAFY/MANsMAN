import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        maximumDate: DateTime.now(),
        minimumYear: 1900,
        maximumYear: 2024,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime value){});
  }
}
