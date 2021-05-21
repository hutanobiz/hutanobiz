import 'package:hutano/strings.dart';

class Validations {
  static String validateEmpty(String value) {
    if (value.isEmpty) {
      return "Field Can't be empty";
    } else
      return null;
  }

  static String requiredValue(String value) {
    if (value.trim().isEmpty) {
      return "";
    } else
      return null;
  }

  static String validateEmail(String value) {
    if (value.isEmpty) {
      return '';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return Strings.enterValidEmail;
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return '';
    } else if (value.length < 6)
      return Strings.enterValidPassword;
    else
      return null;
  }

  static String validateLoginPassword(String value) {
    if (value.isEmpty) {
      return null;
    } else if (value.length < 6)
      return Strings.enterValidPassword;
    else
      return null;
  }

  static String validatePhone(String value) {
    if (value.isEmpty) {
      return null;
    } else if (getCleanedNumber(value).length < 10)
      return "Please enter a valid phone number";
    else
      return null;
  }

  static String getCleanedNumber(String text) {
    return text.replaceAll(RegExp('[^0-9]+'), '');
  }

  static String validateCardNumber(String input) {
    if (input.isEmpty) {
      return null;
    }

    String number = getCleanedNumber(input);
    if (!_creditCard.hasMatch(number)) {
      return "Invalid Card. Please enter a valid card";
    }

    if (number.length < 8) {
      return "Invalid Card. Please enter a valid card";
    }

    int sum = 0;
    int length = number.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(number[length - i - 1]);

      if (i % 2 == 1) {
        digit *= 2;
      }

      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return "Invalid Card. Please enter a valid card";
  }

  static String validateCVV(String value) {
    if (value.isEmpty) {
      return null;
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String validateDate(String value) {
    if (value.isEmpty) {
      return null;
    }

    int year;
    int month;
    if (value.contains(RegExp(r'(\/)'))) {
      var split = value.split(RegExp(r'(\/)'));
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      month = int.parse(value.substring(0, value.length));
      year = -1;
    }

    if ((month < 1) || (month > 12)) {
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();

    return fourDigitsYear < now.year;
  }
}

RegExp _creditCard = RegExp(
    r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');
