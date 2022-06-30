import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/file_constants.dart';
import '../../../../utils/localization/localization.dart';

String? validateCVV(String value, BuildContext context) {
  if (value.isEmpty) {
    return Localization.of(context)!.errorEnterField;
  }

  if (value.length < 3 || value.length > 4) {
    return Localization.of(context)!.msgCVV;
  }
  return null;
}

String? validateDate(String value, BuildContext context) {
  if (value.isEmpty) {
    return Localization.of(context)!.errorEnterField;
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
    return Localization.of(context)!.msgMonth;
  }

  var fourDigitsYear = convertYearTo4Digits(year);
  if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
    return Localization.of(context)!.msgYear;
  }

  if (!hasDateExpired(month, year)) {
    return Localization.of(context)!.cardExpired;
  }
  return null;
}

bool hasDateExpired(int month, int year) {
  return !(month == null || year == null) && isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently is more than card's
  // year
  return fourDigitsYear < now.year;
}

int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}

CardType getBrandType(String? brand) {
  if (brand?.toLowerCase() == "Visa".toLowerCase()) {
    return CardType.Visa;
  } else if (brand?.toLowerCase() == "Master".toLowerCase()) {
    return CardType.Master;
  } else if (brand?.toLowerCase() == "Verve".toLowerCase()) {
    return CardType.Verve;
  } else if (brand?.toLowerCase() == "Discover".toLowerCase()) {
    return CardType.Discover;
  } else if (brand?.toLowerCase() == "AmericanExpress".toLowerCase()) {
    return CardType.AmericanExpress;
  } else if (brand?.toLowerCase() == "DinersClub".toLowerCase()) {
    return CardType.DinersClub;
  } else if (brand?.toLowerCase() == "Jcb".toLowerCase()) {
    return CardType.Jcb;
  } else {
    return CardType.Others;
  }
}

CardType getCardTypeFrmNumber(String input) {
  CardType cardType;
  if (input.startsWith(new RegExp(
      r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
    cardType = CardType.Master;
  } else if (input.startsWith(new RegExp(r'[4]'))) {
    cardType = CardType.Visa;
  } else if (input.startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
    cardType = CardType.Verve;
  } else if (input.startsWith(new RegExp(r'((34)|(37))'))) {
    cardType = CardType.AmericanExpress;
  } else if (input.startsWith(new RegExp(r'((6[45])|(6011))'))) {
    cardType = CardType.Discover;
  } else if (input.startsWith(new RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
    cardType = CardType.DinersClub;
  } else if (input.startsWith(new RegExp(r'(352[89]|35[3-8][0-9])'))) {
    cardType = CardType.Jcb;
  } else if (input.length <= 8) {
    cardType = CardType.Others;
  } else {
    cardType = CardType.Invalid;
  }
  return cardType;
}

String getCardNumber(String text) {
  return text.replaceAll(RegExp('[^0-9]+'), '');
}

String? validateCardNumber(String input, BuildContext context) {
  RegExp _creditCard = RegExp(
      r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');
  if (input.isEmpty) {
    return Localization.of(context)!.errorEnterField;
  }

  String number = getCleanedNumber(input);
  if (!_creditCard.hasMatch(number)) {
    return Localization.of(context)!.invalidCard;
  }

  if (number.length < 8) {
    return Localization.of(context)!.invalidCard;
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

  return Localization.of(context)!.invalidCard;
}

String getCleanedNumber(String text) {
  return text.replaceAll(RegExp('[^0-9]+'), '');
}

Widget? getCardIcon(CardType cardType) {
  String img = "";
  Icon? icon;
  switch (cardType) {
    case CardType.Master:
      img = FileConstants.icMasterCard;
      break;
    case CardType.Visa:
      img = FileConstants.icVisa;
      break;
    case CardType.Verve:
      img = FileConstants.icVerse;
      break;
    case CardType.AmericanExpress:
      img = FileConstants.icAmericanExpress;
      break;
    case CardType.Discover:
      img = FileConstants.icDiscover;
      break;
    case CardType.DinersClub:
      img = FileConstants.icDinnerClub;
      break;
    case CardType.Jcb:
      img = FileConstants.icDinnerClub;
      break;
    case CardType.Others:
      icon = Icon(
        Icons.credit_card,
        size: 28.0,
        color: Colors.grey[600],
      );
      break;
    case CardType.Invalid:
      icon = Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.grey[600],
      );
      break;
  }
  Widget? widget;
  if (img.isNotEmpty) {
    widget = Image.asset(
      img,
      width: 28,
      height: 28,
    );
  } else {
    widget = icon;
  }
  return widget;
}
