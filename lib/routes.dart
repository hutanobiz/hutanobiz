import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/all_appointments/all_appointments.dart';
import 'package:hutano/screens/appointments/appointment_complete.dart';
import 'package:hutano/screens/appointments/appointment_detail_screen.dart';
import 'package:hutano/screens/appointments/cancel_appointment.dart';
import 'package:hutano/screens/appointments/consent_to_treat_screen.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/rate_doctor_screen.dart';
import 'package:hutano/screens/appointments/request_detail_screen.dart';
import 'package:hutano/screens/appointments/seeking_cure.dart';
import 'package:hutano/screens/appointments/track_treatment.dart';
import 'package:hutano/screens/appointments/treatment_summary.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/screens/appointments/video_call.dart';
import 'package:hutano/screens/book_appointment/confirm_book_appointment.dart';
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
import 'package:hutano/screens/registration/verify_otp.dart';
import 'package:hutano/src/ui/add_insurance/add_insruance.dart';
import 'package:hutano/src/ui/add_insurance/add_insruance_complete.dart';
import 'package:hutano/src/ui/appointments/my_appointments/my_appointments.dart';
import 'package:hutano/src/ui/auth/forgotpassword/forgot_password.dart';
import 'package:hutano/src/ui/auth/login_pin/login_pin.dart';
import 'package:hutano/src/ui/auth/otp_verification/model/otp_verification.dart';
import 'package:hutano/src/ui/auth/register/insurance_picker.dart';
import 'package:hutano/src/ui/auth/register/register.dart';
import 'package:hutano/src/ui/auth/register_phone/register_number.dart';
import 'package:hutano/src/ui/auth/reset_pin.dart';
import 'package:hutano/src/ui/auth/resetpassword/reset_password.dart';
import 'package:hutano/src/ui/auth/resetpassword/reset_password_success.dart';
import 'package:hutano/src/ui/auth/signin/signin_screen.dart';
import 'package:hutano/src/ui/auth/signin/web_view.dart';
import 'package:hutano/src/ui/auth/splash.dart';
import 'package:hutano/src/ui/familynetwork/add_family_member/add_family_member.dart';
import 'package:hutano/src/ui/familynetwork/familycircle/family_circle.dart';
import 'package:hutano/src/ui/familynetwork/member_message/member_message.dart';
import 'package:hutano/src/ui/invite/invite_email.dart';
import 'package:hutano/src/ui/invite/invite_text.dart';
import 'package:hutano/src/ui/medical_history/body_symptoms.dart';
import 'package:hutano/src/ui/medical_history/checkout.dart';
import 'package:hutano/src/ui/medical_history/generalized_pain_symptoms.dart';
import 'package:hutano/src/ui/medical_history/medicine_information.dart';
import 'package:hutano/src/ui/medical_history/my_medical_history.dart';
import 'package:hutano/src/ui/medical_history/pain_symptoms.dart';
import 'package:hutano/src/ui/medical_history/payment_methods.dart';
import 'package:hutano/src/ui/medical_history/symptoms_information.dart';
import 'package:hutano/src/ui/medical_history/test_documents_list.dart';
import 'package:hutano/src/ui/medical_history/upload_insurance_image.dart';
import 'package:hutano/src/ui/medical_history/upload_symptoms_images.dart';
import 'package:hutano/src/ui/medical_history/upload_test_documents.dart';
import 'package:hutano/src/ui/provider/create_group/create_provider_group.dart';
import 'package:hutano/src/ui/provider/my_provider_network/my_provider_network.dart';
import 'package:hutano/src/ui/provider/provider_add_network/provider_add_network.dart';
import 'package:hutano/src/ui/provider/provider_search/provider_search.dart';
import 'package:hutano/src/ui/provider/search/search_screen.dart';
import 'package:hutano/src/ui/provider/search_member/search_member.dart';
import 'package:hutano/src/ui/reedm_points/redeem_points.dart';
import 'package:hutano/src/ui/registration_steps/add_provider/add_provider.dart';
import 'package:hutano/src/ui/registration_steps/email_verification/email_verification.dart';
import 'package:hutano/src/ui/registration_steps/email_verification/email_verification_complete.dart';
import 'package:hutano/src/ui/registration_steps/home/home.dart';
import 'package:hutano/src/ui/registration_steps/invite_family/invite_family.dart';
import 'package:hutano/src/ui/registration_steps/invite_family/invite_family_success.dart';
import 'package:hutano/src/ui/registration_steps/payment/add_payment_option.dart';
import 'package:hutano/src/ui/registration_steps/payment/card_complete/add_card_complete.dart';
import 'package:hutano/src/ui/registration_steps/setup_pin/pin_setup_success.dart';
import 'package:hutano/src/ui/registration_steps/setup_pin/set_pin.dart';
import 'package:hutano/src/ui/welcome/welcome_screen.dart';
import 'package:hutano/src/utils/constants/key_constant.dart';

import 'src/utils/constants/constants.dart';

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
  static const String allAppointmentsScreen = '/allAppointmentScreen';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    var args;
    if (settings.arguments == Map) {
      args = settings.arguments;
    } else {
      args = settings.arguments;
    }

    switch (settings.name) {
      //TODO : Verify : New app route

      case routeRegister:
        final String number = args[ArgumentConstant.number];
        final String countryCode = args[ArgumentConstant.countryCode];
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(number, countryCode));
      case routeRegisterNumber:
        return MaterialPageRoute(builder: (_) => RegisterNumber());
      case routeLogin:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case routeLaunch:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case routeForgotPassword:
        final verificationScreen = args[ArgumentConstant.verificationScreen];
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordScreen(verificationScreen));
      case routeResetPin:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) => ResetPin(verificationModel: verificationModel));
      case routeFamilyCircle:
        return MaterialPageRoute(builder: (_) => FamilyCircle());
      case routePinVerification:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) =>
                OtpVerification(verificationModel: verificationModel));
      case routeWelcomeScreen:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case routeLoginPin:
        return MaterialPageRoute(builder: (_) => LoginPin());
      case routeEmailVerification:
        return MaterialPageRoute(builder: (_) => EmailVerificationScreen());
      case routeResetPasswordSuccess:
        return MaterialPageRoute(builder: (_) => ResetPasswordSuccess());
      case routePinSetupSuccess:
        return MaterialPageRoute(builder: (_) => PinSetupSuccess());
      case routeAddInsuranceComplete:
        return MaterialPageRoute(builder: (_) => AddInsuranceComplete());
      case routeAddInsurance:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => AddInsurance());
        }
        final insuranceType = args[ArgumentConstant.argsinsuranceType];
        return MaterialPageRoute(
            builder: (_) => AddInsurance(
                  insuranceType: insuranceType,
                ));
      case routeInviteSuccess:
        return MaterialPageRoute(builder: (_) => InviteFamilySuccess());
      case routeEmailVerificationComplete:
        return MaterialPageRoute(builder: (_) => EmailVerifiCompleteScreen());
      case routeAddCardComplete:
        return MaterialPageRoute(builder: (_) => AddCardComplete());
      case routeMyMedicalHistory:
        return MaterialPageRoute(builder: (_) => MyMedicalHistory());
      case routeBodySymptoms:
        return MaterialPageRoute(builder: (_) => BodySymptoms());
      case routePainSymptoms:
        return MaterialPageRoute(
          builder: (_) => PainSymptoms(
            selectedBodyTypeIndex: args[ArgumentConstant.argselectedBodyType],
            selectedBodyPart: args[ArgumentConstant.argsselectBodyPart],
          ),
        );
      case routeGeneralizedPainSymptoms:
        return MaterialPageRoute(builder: (_) => GeneralizedPainSymptoms());
      case routeSymptomsInformation:
        return MaterialPageRoute(
          builder: (_) => SymptomsInformation(
            selectedSymtomsType: args[ArgumentConstant.argSeletedSymptomsType],
          ),
        );
      case routeMedicineInformation:
        return MaterialPageRoute(
          builder: (_) => MedicineInformation(),
        );
      case routeUploadTestDocuments:
        return MaterialPageRoute(builder: (_) => UploadTestDocuments());
      case routeTestDocumentsList:
        return MaterialPageRoute(
            builder: (_) => TestDocumentsList(
                  type: args[ArgumentConstant.documentType],
                ));
      case routeUploadSymptomsImages:
        return MaterialPageRoute(builder: (_) => UploadSymptomsImages());
      case routePaymentMethods:
        return MaterialPageRoute(builder: (_) => PaymentMethods());
      case routeCheckout:
        final card = args[ArgumentConstant.card];
        return MaterialPageRoute(builder: (_) => Checkout(card: card));
      case routeUploadInsuranceImage:
        return MaterialPageRoute(
            builder: (_) => UploadInsuranceImage(
                  insuranceId: args[ArgumentConstant.insuranceId],
                ));
      case routeAddPaymentOption:
        return MaterialPageRoute(builder: (_) => AddPaymentScreen());
      case routeInviteFamilyMember:
        return MaterialPageRoute(builder: (_) => InviteFamilyScreen());
      case routeProviderSearch:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => ProviderSearch());
        }
        final searchText = args[ArgumentConstant.searchText];
        return MaterialPageRoute(
            builder: (_) => ProviderSearch(
                  serachText: searchText,
                ));
      case routeMemberMessage:
        final member = args[ArgumentConstant.member];
        final shareMessage = args[ArgumentConstant.shareMessage];
        return MaterialPageRoute(
            builder: (_) => MemberMessage(
                  member: member,
                  message: shareMessage,
                ));
      case routeSearchMember:
        final shareMessage = args[ArgumentConstant.shareMessage];
        final loadAllData = args.containsKey(ArgumentConstant.loadAllData)
            ? args[ArgumentConstant.loadAllData]
            : false;
        return MaterialPageRoute(
            builder: (_) => SearchMember(
                  message: shareMessage,
                  loadAllData: loadAllData,
                ));
      case routeProviderAddNetwork:
        final doctorName = args[ArgumentConstant.doctorName];
        final doctorId = args[ArgumentConstant.doctorId];
        final doctorAvatar = args[ArgumentConstant.doctorAvatar];
        return MaterialPageRoute(
            builder: (_) => ProivderAddNetwork(
                doctorId: doctorId,
                doctorName: doctorName,
                doctorAvatar: doctorAvatar));
      case routeInviteByEmail:
        final String email = args[ArgumentConstant.email];
        return MaterialPageRoute(builder: (_) => InviteByEmailScreen(email));
      case routeInviteByText:
        final String sms = args[ArgumentConstant.sms];
        final String shareMessage = args[ArgumentConstant.shareMessage];
        return MaterialPageRoute(
            builder: (_) => InviteByTextScreen(
                  sms,
                  shareMessage: shareMessage,
                ));
      case routeReedmPoints:
        return MaterialPageRoute(builder: (_) => ReedomPointsScreen());
      case routeMyAppointments:
        return MaterialPageRoute(builder: (_) => MyAppointments());
      case routeAddProvider:
        return MaterialPageRoute(builder: (_) => AddProvider());
      case routeSearch:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => SearchScreen());
        }
        final searchScreen = args[ArgumentConstant.searchScreen];
        final number = args[ArgumentConstant.number];
        return MaterialPageRoute(
            builder: (_) => SearchScreen(
                  searchScreen: searchScreen,
                  number: number,
                ));
      case routeAddFamilyMember:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => AddFamilyMember());
        }
        final member = args[ArgumentConstant.member];
        return MaterialPageRoute(
            builder: (_) => AddFamilyMember(member: member));
      case routeResetPassword:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) =>
                ResetPassword(verificationModel: verificationModel));
      case routeMyProviderNetwork:
        return MaterialPageRoute(builder: (_) => MyProviderNetwrok());
      case routeSetupPin:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => SetupPin());
        }
        final setPinScreen = args[ArgumentConstant.setPinScreen];
        return MaterialPageRoute(
            builder: (_) => SetupPin(
                  setupScreen: setPinScreen,
                ));
      case routeHome:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => Home());
        }
        final searchText = args[ArgumentConstant.searchText];
        return MaterialPageRoute(
            builder: (_) => Home(
                  searchText: searchText,
                ));
      case routeCreateGroup:
        return MaterialPageRoute(builder: (_) => CreateProviderGroup());
      case routeInsuranceList:
        return MaterialPageRoute(builder: (_) => InsuranceList());
      case routeWebView:
        return MaterialPageRoute(builder: (_) => WebView());

      //TODO : Verify Client app route
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
      // case resetPasswordRoute:
      //   if (args is RegisterArguments) {
      //     return _buildRoute(settings, ResetPassword(args: args));
      //   }
      //   return _errorRoute();
      //   break;
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
        if (args is List) {
          return _buildRoute(
              settings,
              DashboardSearchScreen(
                topSpecialtiesList: args,
              ));
        } else if (args['searchParam'] != null) {
          return _buildRoute(settings,
              DashboardSearchScreen(searchParam: args['searchParam']));
        }
        return _buildRoute(
            settings,
            DashboardSearchScreen(
              topSpecialtiesList: args,
            ));
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
        return _buildRoute(settings, ConfirmBookAppointmentScreen());
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
      case allAppointmentsScreen:
        return _buildRoute(settings, AllAppointments());
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
        return _buildRoute(
            settings,
            CallPage(
              channelName: args,
            ));
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

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
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
