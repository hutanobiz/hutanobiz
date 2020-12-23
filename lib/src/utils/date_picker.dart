
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<DateTime> showCustomDatePicker(
    {BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
    bool showMaterialPicker = false}) {
  return showMaterialPicker
      ? showDatePicker(
          context: context,
          initialDate: lastDate,
          firstDate: firstDate,
          lastDate: lastDate)
      : DatePicker.showDatePicker(context,
          // showTitleActions: true,
          minTime: firstDate,
          maxTime: lastDate,
          locale: LocaleType.en);
}

String formattedDate(DateTime date, String format) {
  initializeDateFormatting('en');
  final formatter = DateFormat(format);
  return formatter.format(date);
}
