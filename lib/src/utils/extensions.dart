import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'localization/localization.dart';

extension StringExtension on String {
  static String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';

  String format(List replacements) {
    var template = this;
    var regExp = RegExp(placeholderPattern);
    assert(regExp.allMatches(template).length == replacements.length,
        "Template and Replacements length are incompatible");

    for (var replacement in replacements) {
      template = template.replaceFirst(regExp, replacement.toString());
    }
    return template;
  }

  String isValidEmail(BuildContext context) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);

    if (isEmpty) {
      return Localization.of(context).msgEnterAddress;
    } else if (!regex.hasMatch(trim())) {
      return Localization.of(context).msgEnterValidAddress;
    } else {
      return null;
    }
  }

  String isValidNumber(BuildContext context) {
    if (trim().isEmpty) {
      return Localization.of(context).msgEnterMobile;
    } else if (trim().length < 10) {
      return Localization.of(context).msgEnterValidMobile;
    } else {
      return null;
    }
  }

  String isValidUSNumber(BuildContext context) {
    if (trim().isEmpty) {
      return Localization.of(context).msgEnterMobile;
    } else if (trim().length < 14) {
      return Localization.of(context).msgEnterValidMobile;
    } else {
      return null;
    }
  }

  static bool isPasswordValidate(String value) {
    var pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    var regex = RegExp(pattern);
    if (value.length == 0 || value.isEmpty) {
      return false;
    } else if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  String isValidPassword(BuildContext context) {
    if (trim().isEmpty) {
      return Localization.of(context).errorPassword;
    } else if (trim().length < 6) {
      return Localization.of(context).errorValidPassword;
    } else {
      return null;
    }
  }

  bool isValidPin(BuildContext context, String target) {
    if (trim().isEmpty || target.isEmpty) {
      return false;
    } else if (trim().length < 4 || target.trim().length < 4) {
      return false;
    } else {
      return true;
    }
  }

  String isBlank(BuildContext context, String msg) {
    return trim().isEmpty ? msg : null;
  }

  String rawNumber() {
    return replaceAll(RegExp(r'[^\w]+'), '');
  }

  String getInitials() {
    var names = split(" ");
    var initials = "";
    var numWords = names.length;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0].toUpperCase()}';
    }
    return initials;
  }

  String getYearCount() {
    var parsedDate = DateTime.parse(this);
    var dur = DateTime.now().difference(parsedDate);
    return (dur.inDays / 365).floor().toString();
  }

  String getYear() {
    var parsedDate = DateTime.parse(this);
    return parsedDate.year.toString();
  }

  String getDate() {
    var parsedDate = DateTime.parse(this);
    initializeDateFormatting('en');
    return DateFormat('EEEE, d MMMM, hh:mm a')
        .format(parsedDate)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'PM');
  }

  String getUsFormatNumber() {
    return "(${substring(0, 3)}) ${substring(3, 6)}-${substring(6, length)}";
  }
}
