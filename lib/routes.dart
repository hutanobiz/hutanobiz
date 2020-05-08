import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/appointments/appointment_complete.dart';
import 'package:hutano/screens/appointments/appointment_detail_screen.dart';
import 'package:hutano/screens/appointments/consent_to_treat_screen.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/rate_doctor_screen.dart';
import 'package:hutano/screens/appointments/seeking_cure.dart';
import 'package:hutano/screens/appointments/track_treatment.dart';
import 'package:hutano/screens/appointments/treatment_summary.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/screens/book_appointment/review_appointment.dart';
import 'package:hutano/screens/book_appointment/select_appointment_time_screen.dart';
import 'package:hutano/screens/book_appointment/select_services.dart';
import 'package:hutano/screens/dashboard/appointment_type_screen.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/screens/dashboard/choose_specialities.dart';
import 'package:hutano/screens/dashboard/dashboard_search_screen.dart';
import 'package:hutano/screens/dashboard/provider_list_screen.dart';
import 'package:hutano/screens/dashboard/provider_profile_screen.dart';
import 'package:hutano/screens/dashboard/search_info.dart';
import 'package:hutano/screens/dashboard/see_all_searches.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/screens/payment/add_new_card.dart';
import 'package:hutano/screens/payment/insurance_list.dart';
import 'package:hutano/screens/payment/payments_methods.dart';
import 'package:hutano/screens/payment/saved_cards.dart';
import 'package:hutano/screens/payment/upload_insurance_images.dart';
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
  static const String providerListScreen = '/providerListScreen';
  static const String dashboardSearchScreen = '/dashboardSearchScreen';
  static const String seeAllSearchScreeen = '/seeAllSearchScreeen';
  static const String searchInfoScreen = '/searchInfoScreen';
  static const String selectAppointmentTimeScreen =
      '/selectAppointmentTimeScreen';
  static const String reviewAppointmentScreen = '/reviewAppointmentScreen';
  static const String providerProfileScreen = '/providerProfileScreen';
  static const String appointmentDetailScreen = '/appointmentDetailScreen';
  static const String rateDoctorScreen = '/rateDoctorScreen';
  static const String paymentMethodScreen = '/paymentMethodScreen';
  static const String addNewCardScreen = '/addNewCardScreen';
  static const String consentToTreatScreen = '/consentToTreatScreen';
  static const String medicalHistoryScreen = '/medicalHistoryScreen';
  static const String seekingCureScreen = '/seekingCureScreen';
  static const String uploadImagesScreen = '/uploadImagesScreen';
  static const String uploadDocumentsScreen = '/uploadDocumentsScreen';
  static const String savedCardsScreen = '/savedCardsScreen';
  static const String selectServicesScreen = '/selectServicesScreen';
  static const String insuranceListScreen = '/insuranceListScreen';
  static const String uploadInsuranceImagesScreen =
      '/uploadInsuranceImagesScreen';
  static const String treatmentSummaryScreen = '/treatmentSummaryScreen';
  static const String appointmentsScreen = '/appointmentsScreen';
  static const String trackTreatmentScreen = '/trackTreatmentScreen';
  static const String appointmentCompleteConfirmation =
      '/appointmentCompleteConfirmation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return _buildRoute(settings, LoginScreen());
        break;
      case dashboardScreen:
        return _buildRoute(settings, HomeScreen());
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
        if (args is String) {
          return _buildRoute(
              settings, ChooseSpecialities(professionalId: args));
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
      case providerListScreen:
        return _buildRoute(settings, ProviderListScreen());
        break;
      case dashboardSearchScreen:
        return _buildRoute(settings, DashboardSearchScreen());
        break;
      case seeAllSearchScreeen:
        if (args is SearchArguments) {
          return _buildRoute(settings, SeeAllSearchScreeen(arguments: args));
        }
        return _errorRoute();
      case searchInfoScreen:
        if (args is Map) {
          return _buildRoute(settings, SearchInfoScreen(map: args));
        }
        return _errorRoute();
        break;
      case selectAppointmentTimeScreen:
        return _buildRoute(settings, SelectAppointmentTimeScreen());
        break;
      case reviewAppointmentScreen:
        return _buildRoute(settings, ReviewAppointmentScreen());
        break;
      case providerProfileScreen:
        return _buildRoute(settings, ProviderProfileScreen());
        break;
      case appointmentDetailScreen:
        return _buildRoute(settings, AppointmentDetailScreen());
        break;
      case rateDoctorScreen:
        return _buildRoute(settings, RateDoctorScreen());
        break;
      case paymentMethodScreen:
        return _buildRoute(settings, PaymentMethodScreen());
        break;
      case addNewCardScreen:
        return _buildRoute(settings, AddNewCardScreen());
        break;
      case consentToTreatScreen:
        return _buildRoute(settings, ConsentToTreatScreen());
        break;
      case medicalHistoryScreen:
        return _buildRoute(settings, MedicalHistoryScreen());
        break;
      case seekingCureScreen:
        return _buildRoute(settings, SeekingCureScreen());
        break;
      case uploadImagesScreen:
        return _buildRoute(settings, UploadImagesScreen());
        break;
      case uploadDocumentsScreen:
        return _buildRoute(settings, UploadDocumentsScreen());
        break;
      case savedCardsScreen:
        return _buildRoute(settings, SavedCardsScreen());
        break;
      case selectServicesScreen:
        return _buildRoute(settings, SelectServicesScreen());
        break;
      case insuranceListScreen:
        return _buildRoute(settings, InsuranceListScreen());
        break;
      case uploadInsuranceImagesScreen:
        return _buildRoute(settings, UploadInsuranceImagesScreen());
        break;
      case treatmentSummaryScreen:
        return _buildRoute(settings, TreatmentSummaryScreen());
        break;
      case appointmentsScreen:
        return _buildRoute(settings, AppointmentsScreen());
        break;
      case trackTreatmentScreen:
        return _buildRoute(settings, TrackTreatmentScreen());
        break;
      case appointmentCompleteConfirmation:
        if (args is Map<String, String>) {
          return _buildRoute(
            settings,
            AppointmentCompleteConfirmation(
              appointmentCompleteMap: args,
            ),
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

class SearchArguments {
  final List<dynamic> list;
  final String title;
  final int type;

  SearchArguments({this.list, this.title, this.type});
}
