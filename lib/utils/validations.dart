import 'package:hutano/strings.dart';

class Validations {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return null;
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
      return null;
    } else if (value.length < 6)
      return Strings.enterValidPassword;
    else
      return null;
  }
}
