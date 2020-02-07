import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/register_email.dart';
import 'screens/verify_otp.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String registerEmailRoute = '/registerEmail';
  static const String verifyOtpRoute = '/verifyOtp';

  static final routes = {
    initialRoute: (context) => LoginScreen(),
    homeRoute: (context) => HomeScreen(),
    forgotPasswordRoute: (context) => ForgetPassword(),
    registerEmailRoute: (context) => RegisterEmail(),
    verifyOtpRoute: (context) => VerifyOTP(),
  };
}
