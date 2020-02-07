import 'package:hutano/screens/register.dart';
import 'package:hutano/screens/reset_password.dart';

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
  static const String resetPasswordRoute = '/resetPassword';

  static final routes = {
    loginRoute: (context) => LoginScreen(),
    homeRoute: (context) => HomeScreen(),
    forgotPasswordRoute: (context) => ForgetPassword(),
    registerEmailRoute: (context) => RegisterEmail(),
    verifyOtpRoute: (context) => VerifyOTP(),
    registerRoute: (context) => Register(),
    resetPasswordRoute: (context) => ResetPassword(),
  };
}
