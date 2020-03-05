import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/dashboard/appointment_type_screen.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/screens/dashboard/choose_specialities.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/screens/registration/forgot_password.dart';
import 'package:hutano/screens/registration/register.dart';
import 'package:hutano/screens/registration/register_email.dart';
import 'package:hutano/screens/registration/reset_password.dart';
import 'package:hutano/screens/registration/verify_otp.dart';

class Routes {
  static const String loginRoute = '/login';
  static const String dashboardScreen = '/dashboardScreen';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String registerEmailRoute = '/registerEmail';
  static const String verifyOtpRoute = '/verifyOtp';
  static const String registerRoute = '/register';
  static const String resetPasswordRoute = '/resetPassword';
  static const String chooseSpecialities = '/chooseSpecialities';
  static const String appointmentTypeScreen = '/appointmentTypeScreen';
  static const String chooseLocation = '/chooseLocation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return _buildRoute(settings, LoginScreen());
        break;
      case dashboardScreen:
        return _buildRoute(settings, DashboardScreen());
        break;
      case forgotPasswordRoute:
        return _buildRoute(settings, ForgetPassword());
        break;
      case registerEmailRoute:
        return _buildRoute(settings, RegisterEmail());
        break;
      case verifyOtpRoute:
        if (args is RegisterArguments) {
          return _buildRoute(settings, VerifyOTP(args: args));
        }
        return _errorRoute();
        break;
      case registerRoute:
        if (args is RegisterArguments) {
          return _buildRoute(settings, Register(args: args));
        }
        return _errorRoute();
        break;
      case resetPasswordRoute:
        if (args is RegisterArguments) {
          return _buildRoute(settings, ResetPassword(args: args));
        }
        return _errorRoute();
        break;
      case chooseSpecialities:
        if (args is MapArguments) {
          return _buildRoute(settings,
              ChooseSpecialities(professionalId: args.map["professionalId"]));
        }
        return _errorRoute();
        break;
      case appointmentTypeScreen:
        return _buildRoute(settings, AppointmentTypeScreen());
        break;
      case chooseLocation:
        if (args is LatLng) {
          return _buildRoute(
            settings,
            ChooseLocationScreen(latLng: args),
          );
        }
        return _errorRoute();
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

CupertinoPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return CupertinoPageRoute(
      settings: settings, maintainState: true, builder: (_) => builder
      // builder: (_) => AnnotatedRegion<SystemUiOverlayStyle>(
      //   value: SystemUiOverlayStyle(
      //       statusBarIconBrightness: Brightness.dark,
      //       statusBarColor: AppColors.snow),
      //   child: builder,
      // ),
      );
}

class RegisterArguments {
  final String email;
  final bool isForgot;

  RegisterArguments(this.email, this.isForgot);
}

class MapArguments {
  final Map map;

  MapArguments(this.map);
}
