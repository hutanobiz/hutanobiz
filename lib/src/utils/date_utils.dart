
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateConstants {
  static const String dateFormat1 = "yyyy-MM-dd HH:mm:ss";
  static const String dateFormat2 = "hh:mm:ss";
  static const String dateFormat = "yyyy-MM-dd";
  static const String displayDateFormat = "dd MMMM yyyy";
  static const String threadDateFormat = "dd MMM yyyy";
  static const String timeFormat = "hh:mm a";
  static const String notificationDateFormat = "dd/MM";
  static const String notificationTimeFormat = "H:mm";
  static const String fullDateFormat = "E d MMM yyyy, HH:mm";
  static const String notificationFullDate = "HH:mm dd/MM/yyyy";
}

String getLocalDate(String dateUtc,
    {String inputFormat = DateConstants.dateFormat1,
    String outputFormat = DateConstants.dateFormat1}) {
  var dateTime = DateFormat(inputFormat).parse(dateUtc, true);
  var dateLocal = dateTime.toLocal();
  return DateFormat(outputFormat).format(dateLocal);
}

String formatDate(String date,
    {
    String inputFormat = "",
    String resultFormat = ""}) {
      initializeDateFormatting('en');
  if (date != null && date.isNotEmpty) {
    var finaldate = date;
    
      finaldate = getLocalDate(date,
          inputFormat: inputFormat, outputFormat: inputFormat);
    
    var dateTime = DateFormat(inputFormat).parse(finaldate, false);
    var dateLocal = dateTime.toLocal();
    return DateFormat(resultFormat).format(dateLocal);
  }
  return "";
}