import 'package:flutter/material.dart';
import 'package:hutano/screens/register.dart';
import 'package:hutano/utils/shared_prefrences.dart';

import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/register_email.dart';
import 'screens/verify_otp.dart';

class Routes {
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String registerEmailRoute = '/registerEmail';
  static const String verifyOtpRoute = '/verifyOtp';
  static const String registerRoute = '/register';

  static WidgetBuilder widgetBuilder;

  static final routes = {
    loginRoute: (context) => LoginScreen(),
    homeRoute: (context) => HomeScreen(),
    forgotPasswordRoute: (context) => ForgetPassword(),
    registerEmailRoute: (context) => RegisterEmail(),
    verifyOtpRoute: (context) => VerifyOTP(),
    registerRoute: (context) => Register(),
  };

  // static Widget setInitialRoute() {
  //   // bool value = false;

  //   // SharedPref().getToken().then((String token) {
  //   //   if (token == null) {
  //   //     return false;
  //   //     // print("empty");
  //   //   } else {
  //   //     return true;
  //   //     // print(token);
  //   //   }
  //   //   // print("value1: $value");
  //   // });

  //   SharedPref().checkValue("token").then((bool present) {
  //     print("Present: $present");

  //     if (present)
  //       return HomeScreen();
  //     else
  //       return LoginScreen();
  //   });

  //   // print("value: $value");
  //   // return value;
  // }
}
