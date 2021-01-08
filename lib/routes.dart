import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/appointments/appointment_complete.dart';
import 'package:hutano/screens/appointments/appointment_detail_screen.dart';
import 'package:hutano/screens/appointments/cancel_appointment.dart';
import 'package:hutano/screens/appointments/consent_to_treat_screen.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/office_track_treatment.dart';
import 'package:hutano/screens/appointments/rate_doctor_screen.dart';
import 'package:hutano/screens/appointments/request_detail_screen.dart';
import 'package:hutano/screens/appointments/seeking_cure.dart';
import 'package:hutano/screens/appointments/track_treatment.dart';
import 'package:hutano/screens/appointments/treatment_summary.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/screens/appointments/video_call.dart';
import 'package:hutano/screens/book_appointment/onsite_address.dart';
import 'package:hutano/screens/book_appointment/onsite_edit_address.dart';
import 'package:hutano/screens/book_appointment/review_appointment.dart';
import 'package:hutano/screens/book_appointment/select_appointment_time_screen.dart';
import 'package:hutano/screens/book_appointment/select_parking_screen.dart';
import 'package:hutano/screens/book_appointment/select_services.dart';
import 'package:hutano/screens/dashboard/all_reviews_screen.dart';
import 'package:hutano/screens/dashboard/all_tiltes_specialties_screen.dart';
import 'package:hutano/screens/dashboard/appointment_type_screen.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/available_timings_screen.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/screens/dashboard/choose_specialities.dart';
import 'package:hutano/screens/dashboard/dashboard_search_screen.dart';
import 'package:hutano/screens/dashboard/provider_filters.dart';
import 'package:hutano/screens/dashboard/provider_list_screen.dart';
import 'package:hutano/screens/dashboard/provider_profile_image.dart';
import 'package:hutano/screens/dashboard/provider_profile_screen.dart';
import 'package:hutano/screens/dashboard/see_all_searches.dart';
import 'package:hutano/screens/dashboard/update_medical_history.dart';
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
  static const String availableTimingsScreen = '/availableTimingsScreen';
  static const String providerFiltersScreen = '/providerFiltersScreen';
  static const String providerImageScreen = '/providerImageScreen';
  static const String allReviewsScreen = '/allReviewsScreen';
  static const String updateMedicalHistory = '/updateMedicalHistory';
  static const String allTitlesSpecialtesScreen = '/allTitlesSpecialtesScreen';
  static const String onsiteAddresses = '/onsiteAddresses';
  static const String onsiteEditAddress = '/onsiteEditAddress';
  static const String parkingScreen = '/parkingScreen';
  static const String cancelAppointmentScreen = '/cancelAppointmentScreen';
  static const String requestDetailScreen = '/requestDetailScreen';
  static const String callPage = '/callPage';
  static const String officeTrackTreatmentScreen = '/officeTrackTreatmentScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return _buildRoute(settings, LoginScreen());
        break;
      case dashboardScreen:
      if (args is int) {
          return _buildRoute(settings, HomeScreen(currentIndex: args));
        }
        return _errorRoute();
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
        return _buildRoute(
          settings,
          ChooseSpecialities(professionaltitleId: args),
        );
        break;
      case appointmentTypeScreen:
        return _buildRoute(
          settings,
          AppointmentTypeScreen(
            appointmentTypeMap: args,
          ),
        );
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
        return _buildRoute(
            settings, DashboardSearchScreen(topSpecialtiesList: args));
        break;
      case seeAllSearchScreeen:
        if (args is SearchArguments) {
          return _buildRoute(settings, SeeAllSearchScreeen(arguments: args));
        }
        return _errorRoute();

      case selectAppointmentTimeScreen:
        return _buildRoute(
          settings,
          SelectAppointmentTimeScreen(
            isEditDateTime: args,
          ),
        );
        break;
      case reviewAppointmentScreen:
        return _buildRoute(settings, ReviewAppointmentScreen());
        break;
      case providerProfileScreen:
        return _buildRoute(
            settings,
            ProviderProfileScreen(
              selectedAppointmentType: args,
            ));
        break;
      case appointmentDetailScreen:
        return _buildRoute(
          settings,
          AppointmentDetailScreen(
            args: args,
          ),
        );
        break;
      case rateDoctorScreen:
        if (args is String) {
          return _buildRoute(
            settings,
            RateDoctorScreen(
              rateFrom: args,
            ),
          );
        }
        return _errorRoute();
        break;
      case paymentMethodScreen:
        if (args is bool) {
          return _buildRoute(
            settings,
            PaymentMethodScreen(
              isPayment: args,
            ),
          );
        }
        return _errorRoute();
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
        return _buildRoute(
          settings,
          InsuranceListScreen(
            insuranceMap: args,
          ),
        );
        break;
      case uploadInsuranceImagesScreen:
        return _buildRoute(
          settings,
          UploadInsuranceImagesScreen(
            insuranceViewMap: args,
          ),
        );
        break;
      case treatmentSummaryScreen:
        return _buildRoute(
          settings,
          TreatmentSummaryScreen(
            appointmentMap: args,
          ),
        );
        break;
      case appointmentsScreen:
        return _buildRoute(settings, AppointmentsScreen());
        break;
      case officeTrackTreatmentScreen:
      return _buildRoute(
          settings,
          OfficeTrackTreatmentScreen(
            appointmentType: args,
          ),
        );
        break;
      case trackTreatmentScreen:
        return _buildRoute(
          settings,
          TrackTreatmentScreen(
            appointmentType: args,
          ),
        );
        break;
      case appointmentCompleteConfirmation:
        if (args is Map) {
          return _buildRoute(
            settings,
            AppointmentCompleteConfirmation(
              appointmentCompleteMap: args,
            ),
          );
        }
        return _errorRoute();
        break;
      case availableTimingsScreen:
        return _buildRoute(settings, AvailableTimingsScreen());
        break;
      case providerFiltersScreen:
        return _buildRoute(
          settings,
          ProviderFiltersScreen(
            filterMap: args,
          ),
        );
        break;
      case providerImageScreen:
        return _buildRoute(
            settings,
            ProviderImageScreen(
              avatar: args,
            ));
        break;
      case allReviewsScreen:
        return _buildRoute(
          settings,
          AllReviewsScreen(
            reviewMap: args,
          ),
        );
        break;
      case updateMedicalHistory:
        return _buildRoute(
          settings,
          UpdateMedicalHistory(isBottomButtonsShow: args),
        );
        break;
      case allTitlesSpecialtesScreen:
        return _buildRoute(settings, AllTitlesSpecialtesScreen());
        break;
      case onsiteAddresses:
        return _buildRoute(
            settings,
            OnsiteAddresses(
              isBookAppointment: args,
            ));
        break;
      case onsiteEditAddress:
        return _buildRoute(
          settings,
          OnsiteEditAddress(
            addressObject: args,
          ),
        );
        break;
      case parkingScreen:
        return _buildRoute(
          settings,
          SelectParkingScreen(),
        );
        break;
      case cancelAppointmentScreen:
        return _buildRoute(
          settings,
          CancelAppointmentScreen(
            appointmentData: args,
          ),
        );
        break;
      case requestDetailScreen:
        return _buildRoute(
          settings,
          RequestDetailScreen(
            detailData: args,
          ),
        );
        break;
      case callPage:
        return _buildRoute(settings, CallPage(channelName: args,));
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
    settings: settings,
    maintainState: true,
    builder: (_) => builder,
  );
}

class RegisterArguments {
  final String phoneNumber;
  final bool isForgot;
  final bool isProfileUpdate;

  RegisterArguments(this.phoneNumber, this.isForgot, {this.isProfileUpdate});
}

class SearchArguments {
  final List<dynamic> list;
  final String title;
  final int type;

  SearchArguments({this.list, this.title, this.type});
}
