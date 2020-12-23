import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'localization/localization.dart';

class Utils {
  static bool isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  static InputDecoration styleInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: styleTextStyleTextField(),
      counterText: "",
      border: OutlineInputBorder(),
    );
  }

  static TextStyle styleTextStyleTextField() {
    return TextStyle(
      fontSize: 20,
    );
  }

  static String isValidEmail(BuildContext context, String value) {
    if (value.isEmpty) {
      return Localization.of(context).msgEnterAddress;
    } else if (Utils.isEmailValid(value)) {
      return Localization.of(context).msgEnterValidAddress;
    } else {
      return null;
    }
  }

  static String isEmpty(BuildContext context, String value, String message) {
    if (value.isEmpty) {
      return message;
    } else {
      return null;
    }
  }


}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
