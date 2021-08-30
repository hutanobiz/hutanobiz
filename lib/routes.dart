import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/add_insurance/add_insruance.dart';
import 'package:hutano/screens/add_insurance/add_insruance_complete.dart';
import 'package:hutano/screens/appointments/all_documents_tabs.dart';
import 'package:hutano/screens/appointments/all_images_tabs.dart';
import 'package:hutano/screens/appointments/appointment_complete.dart';
import 'package:hutano/screens/appointments/appointment_detail_screen.dart';
import 'package:hutano/screens/appointments/cancel_appointment.dart';
import 'package:hutano/screens/appointments/consent_to_treat_screen.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/office_direction.dart';
import 'package:hutano/screens/appointments/office_track_treatment.dart';
import 'package:hutano/screens/appointments/rate_doctor_screen.dart';
import 'package:hutano/screens/appointments/request_detail_screen.dart';
import 'package:hutano/screens/appointments/seeking_cure.dart';
import 'package:hutano/screens/appointments/telemedicine_track_treatment.dart';
import 'package:hutano/screens/appointments/track_office_appointment.dart';
import 'package:hutano/screens/appointments/track_onsite_appointment.dart';
import 'package:hutano/screens/appointments/track_telemedicine_appointment.dart';
import 'package:hutano/screens/appointments/track_treatment.dart';
import 'package:hutano/screens/appointments/treatment_summary.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/screens/appointments/video_call.dart';
import 'package:hutano/screens/appointments/view_medical_history.dart';
import 'package:hutano/screens/appointments/virtual_waiting_room.dart';
import 'package:hutano/screens/book_appointment/booking_summary.dart';
import 'package:hutano/screens/book_appointment/conditiontime/condition_time.dart';
import 'package:hutano/screens/book_appointment/confirm_book_appointment.dart';
import 'package:hutano/screens/book_appointment/diagnosis/test_diagnosis.dart';
import 'package:hutano/screens/book_appointment/diagnosis/upload_diagnostic_new.dart';
import 'package:hutano/screens/book_appointment/diagnosis/upload_diagnostic_result.dart';
import 'package:hutano/screens/book_appointment/effect_ability.dart';
import 'package:hutano/screens/book_appointment/morecondition/more_condition.dart';
import 'package:hutano/screens/book_appointment/morecondition/welcome_new_followup.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/abnormal_sensation.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/bone_muscle_issue.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/breathing_issue.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/immunization_screen.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/makes_condition_better_worst.dart';
import 'package:hutano/screens/book_appointment/onsite_address.dart';
import 'package:hutano/screens/book_appointment/onsite_edit_address.dart';
import 'package:hutano/screens/book_appointment/review_appointment.dart';
import 'package:hutano/screens/book_appointment/review_appointment_detail.dart';
import 'package:hutano/screens/book_appointment/select_appointment_time_screen.dart';
import 'package:hutano/screens/book_appointment/select_parking_screen.dart';
import 'package:hutano/screens/book_appointment/select_services.dart';
import 'package:hutano/screens/book_appointment/vitals/vital_reviews.dart';
import 'package:hutano/screens/chat/chat.dart';
import 'package:hutano/screens/dashboard/all_reviews_screen.dart';
import 'package:hutano/screens/dashboard/all_tiltes_specialties_screen.dart';
import 'package:hutano/screens/dashboard/appointment_type_screen.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/available_timings_screen.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/screens/dashboard/choose_specialities.dart';
import 'package:hutano/screens/dashboard/dashboard_search_screen.dart';
import 'package:hutano/screens/dashboard/profile/activity_notification.dart';
import 'package:hutano/screens/dashboard/profile/my_providers.dart';
import 'package:hutano/screens/dashboard/profile/payment_history.dart';
import 'package:hutano/screens/dashboard/provider_filters.dart';
import 'package:hutano/screens/dashboard/provider_list_screen.dart';
import 'package:hutano/screens/dashboard/provider_profile_image.dart';
import 'package:hutano/screens/dashboard/provider_profile_screen.dart';
import 'package:hutano/screens/dashboard/see_all_searches.dart';
import 'package:hutano/screens/dashboard/update_medical_history.dart';
import 'package:hutano/screens/familynetwork/add_family_member/add_family_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/invite_family_complete.dart';
import 'package:hutano/screens/familynetwork/familycircle/family_circle.dart';
import 'package:hutano/screens/familynetwork/member_message/member_message.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/home_main.dart';
import 'package:hutano/screens/invite/invite_text.dart';
import 'package:hutano/screens/medical_history/body_symptoms.dart';
import 'package:hutano/screens/medical_history/checkout.dart';
import 'package:hutano/screens/medical_history/current_medical_history.dart';
import 'package:hutano/screens/medical_history/generalized_pain_symptoms.dart';
import 'package:hutano/screens/medical_history/medicine_information.dart';
import 'package:hutano/screens/medical_history/my_medical_history.dart';
import 'package:hutano/screens/medical_history/pain_symptoms.dart';
import 'package:hutano/screens/medical_history/payment_methods.dart';
import 'package:hutano/screens/medical_history/symptoms_information.dart';
import 'package:hutano/screens/medical_history/test_documents_list.dart';
import 'package:hutano/screens/medical_history/upload_insurance_image.dart';
import 'package:hutano/screens/medical_history/upload_symptoms_images.dart';
import 'package:hutano/screens/medical_history/upload_test_documents.dart';
import 'package:hutano/screens/payment/add_new_card.dart';
import 'package:hutano/screens/payment/insurance_list.dart';
import 'package:hutano/screens/payment/payments_methods.dart';
import 'package:hutano/screens/payment/saved_cards.dart';
import 'package:hutano/screens/payment/upload_insurance_images.dart';
import 'package:hutano/screens/pharmacy/add_pharmacy.dart';
import 'package:hutano/screens/providercicle/add_provider_complete.dart';
import 'package:hutano/screens/providercicle/create_group/create_provider_group.dart';
import 'package:hutano/screens/providercicle/my_provider_network/my_provider_network.dart';
import 'package:hutano/screens/providercicle/provider_add_network/provider_add_network.dart';
import 'package:hutano/screens/providercicle/provider_search/provider_search.dart';
import 'package:hutano/screens/providercicle/search/search_screen.dart';
import 'package:hutano/screens/providercicle/search_member/search_member.dart';
import 'package:hutano/screens/registration/add_provider/add_provider.dart';
import 'package:hutano/screens/registration/email_verification/email_verification.dart';
import 'package:hutano/screens/registration/email_verification/email_verification_complete.dart';
import 'package:hutano/screens/registration/forgotpassword/forgot_password.dart';
import 'package:hutano/screens/registration/invite_family/invite_family.dart';
import 'package:hutano/screens/registration/invite_family/invite_family_success.dart';
import 'package:hutano/screens/registration/login_pin/login_pin.dart';
import 'package:hutano/screens/registration/otp_verification/model/otp_verification.dart';
import 'package:hutano/screens/registration/payment/add_payment_option.dart';
import 'package:hutano/screens/registration/payment/card_complete/add_card_complete.dart';
import 'package:hutano/screens/registration/register.dart';
import 'package:hutano/screens/registration/register/register.dart';
import 'package:hutano/screens/registration/register_phone/register_number.dart';
import 'package:hutano/screens/registration/reset_pin.dart';
import 'package:hutano/screens/registration/resetpassword/reset_password.dart';
import 'package:hutano/screens/registration/resetpassword/reset_password_success.dart';
import 'package:hutano/screens/registration/signin/signin_screen.dart';
import 'package:hutano/screens/registration/signin/web_view.dart';
import 'package:hutano/screens/registration/welcome_screen.dart';
import 'package:hutano/screens/setup_pin/set_pin.dart';
import 'package:hutano/screens/setup_pin/set_pin_complete.dart';
import 'package:hutano/utils/constants/key_constant.dart';
// import 'package:hutano/utils/argument_const.dart';

class Routes {
  static const String loginRoute = '/login';
  static const String dashboardScreen = '/dashboardScreen';
  // static const String forgotPasswordRoute = '/forgotPassword';
  // static const String registerEmailRoute = '/registerEmail';
  // static const String verifyOtpRoute = '/verifyOtp';
  static const String verifyEmailOtpRoute = '/verifyEmailOtp';
  // static const String registerRoute = '/register';
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
  static const String telemedicineTrackTreatmentScreen =
      '/telemedicineTrackTreatmentScreen';
  static const String virtualWaitingRoom = '/virtualWaitingRoom';
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
  static const String officeTrackTreatmentScreen =
      '/officeTrackTreatmentScreen';
  static const String homeMain = '/homeMain';
  static const String activityNotification = '/activityNotification';
  static const String myProviders = '/myProviders';
  static const String paymentHistory = '/paymentHistory';
  static const String trackOfficeAppointment = '/trackOfficeAppointment';
  static const String trackOnsiteAppointment = '/trackOnsiteAppointment';
  static const String trackTelemedicineAppointment =
      '/trackTelemedicineAppointment';
  static const String welcome = '/welcome';
  static const String addInsurance = '/addInsurance';
  static const String addFamilyMember = '/addFamilyMember';
  static const String providerSearch = '/providerSearch';
  static const String myProviderNetwork = '/myProviderNetwork';
  static const String memberMessage = '/memberMessage';
  static const String providerAddNetwork = '/providerAddNetwork';
  static const String createProviderGroup = '/createProviderGroup';

  static const String inviteSuccess = '/inviteSuccess';
  static const String addProviderSuccess = '/addProviderSuccess';
  static const String emailVerificationComplete = '/emailVerificationComplete';
  static const String addCardComplete = '/addCardComplete';
  static const String loginPin = '/loginPin';
  static const String resetPasswordSuccess = '/resetPasswordSuccess';
  static const String pinSetupSuccess = '/pinSetupSuccess';
  static const String addInsuranceComplete = '/addInsuranceComplete';
  static const String familyCircle = '/familyCircle';
  static const String inviteFamilyComplete = '/inviteFamilyComplete';
  static const String inviteFamilyMember = '/inviteFamilyMember';
  static const String searchMember = '/searchMember';
  static const String routeSearch = '/routeSearch';
  static const String setupPin = '/setupPin';
  static const String addPaymentOption = '/addPaymentOption';
  static const String setPinComplete = '/setPinComplete';
  static const String routePinVerification = '/routePinVerification';
  static const String routeForgotPassword = '/routeForgotPassword';
  static const String routeResetPin = '/routeResetPin';
  static const String routeResetPasswordSuccess = '/routeResetPasswordSuccess';
  static const String routeRegisterNumber = '/routeRegisterNumber';
  static const String routeWebView = '/routeWebView';
  static const String routeRegister = '/routeRegister';
  static const String routeInviteByText = '/routeInviteByText';
  static const String routeAddProvider = '/routeAddProvider';
  static const String editProfileRoute = '/editProfileRoute';
  static const String routeMoreCondition = '/routeMoreCondition';
  static const String routeWelcomeNewFollowup = '/routeWelcomeNewFollowup';
  static const String routeBoneAndMuscle = '/routeBoneAndMuscle';
  static const String routeImmunization = '/routeImmunization';
  static const String routeEffectAbility = '/routeEffectAbility';
  static const String routeAbnormal = '/routeAbnormal';
  static const String routeBreathingIssue = '/routeBreathingIssue';
  static const String routeVitalReviews = '/routeVitalReviews';
  static const String routeTestDiagnosis = '/routeTestDiagnosis';
  static const String routeConditionTimeScreen = '/routeConditionTimeScreen';
  static const String routeMyMedicalHistory = '/routeMyMedicalHistory';
  static const String routeBodySymptoms = '/routeBodySymptoms';
  static const String routePainSymptoms = '/routePainSymptoms';
  static const String routeGeneralizedPainSymptoms =
      '/routeGeneralizedPainSymptoms';
  static const String routeSymptomsInformation = '/routeSymptomsInformation';
  static const String routeMedicineInformation = '/routeMedicineInformation';
  static const String routeUploadTestDocuments = '/routeUploadTestDocuments';
  static const String routeCurrentMedicalHistory =
      '/routeCurrentMedicalHistory';
  static const String routeUploadDiagnosticResult =
      '/routeUploadDiagnosticResult';
  static const String routeTestDocumentsList = '/routeTestDocumentsList';
  static const String routeUploadSymptomsImages = '/routeUploadSymptomsImages';
  static const String routeNotificationScreen = '/routeNotificationScreen';
  static const String routePaymentMethods = '/routePaymentMethods';
  static const String routeCheckout = '/routeCheckout';
  static const String routeUploadInsuranceImage = '/routeUploadInsuranceImage';
  static const String allImagesTabsScreen = '/allImagesTabsScreen';
  static const String routeAddPharmacy = '/routeAddPharmacy';
  static const String viewMedicalHistory = '/viewMedicalHistory';
  static const String routeConditionBetterWorst = '/routeConditionBetterWorst';
  static const String allDocumentsTabsScreen = '/allDocumentsTabsScreen';
  static const String chat = '/chat';
  static const String routeUploadDiagnosticNew = '/routeUploadDiagnosticNew';
  static const String appointmentConfirmation = '/appointmentConfirmation';
  static const String reviewAppointmentScreenDetail =
      '/reviewAppointmentScreenDetail';
  static const String bookingSummary = '/bookingSummary';
  static const String routeTrackAppointment = '/routeTrackAppointment';
  static const String routeOnSiteTrackAppointment =
      '/routeOnSiteTrackAppointment';
  static const String routeVirtualTrackAppointment =
      '/routeVirtualTrackAppointment';
  static const String officeDirectionScreen = '/officeDirectionScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        // if (args is bool) {
        return _buildRoute(settings, SignInScreen());
        // }
        return _errorRoute();
        break;
      case dashboardScreen:
        if (args is int) {
          return _buildRoute(settings, HomeScreen(currentIndex: args));
        }
        return _errorRoute();
        break;
      case homeMain:
        return _buildRoute(settings, HomeMain());
        break;

      // case forgotPasswordRoute:
      //   return _buildRoute(settings, ForgetPassword());
      //   break;
      // case registerEmailRoute:
      //   return _buildRoute(settings, RegisterEmail());
      //   break;
      // case verifyOtpRoute:
      //   if (args is RegisterArguments) {
      //     return _buildRoute(settings, VerifyOTP(args: args));
      //   }
      //   return _errorRoute();
      //   break;
      case verifyEmailOtpRoute:
        // if (args is Map) {
        // return _buildRoute(settings, EmailVerificationScreen());
        return MaterialPageRoute(builder: (_) => EmailVerificationScreen());
        break;
      // }
      // return _errorRoute();

      case editProfileRoute:
        if (args is RegisterArguments) {
          return _buildRoute(settings, Register(args: args));
        }
        return _errorRoute();
        break;
      case resetPasswordRoute:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) =>
                ResetPassword(verificationModel: verificationModel));
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
        break;
      case selectAppointmentTimeScreen:
        if (args is SelectDateTimeArguments) {
          return _buildRoute(
              settings, SelectAppointmentTimeScreen(arguments: args));
        }
        return _errorRoute();
        break;
      case appointmentConfirmation:
        return _buildRoute(settings, ConfirmBookAppointmentScreen());
        break;
      case reviewAppointmentScreen:
        return _buildRoute(settings, ReviewAppointmentScreen());
        break;
      case reviewAppointmentScreenDetail:
        return _buildRoute(settings, ReviewAppointmentDetail());
      case bookingSummary:
        return _buildRoute(settings, Bookingsummary());
      case providerProfileScreen:
        return _buildRoute(
            settings,
            ProviderProfileScreen(
              providerId: args,
            ));
        break;
      case appointmentDetailScreen:
        return _buildRoute(
          settings,
          AppointmentDetailScreen(
            appointmentId: args,
          ),
        );
        break;
      case rateDoctorScreen:
        if (args is Map) {
          return _buildRoute(
            settings,
            RateDoctorScreen(
              rateFromAppointmentId: args,
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
            appointmentId: args,
          ),
        );
        break;
      case trackTreatmentScreen:
        return _buildRoute(
          settings,
          TrackTreatmentScreen(
            appointmentId: args,
          ),
        );
        break;

      case officeDirectionScreen:
        return _buildRoute(
          settings,
          OfficeDirectionScreen(
            trackOfficeModel: args,
          ),
        );
        break;

      case telemedicineTrackTreatmentScreen:
        return _buildRoute(
          settings,
          TelemedicineTrackTreatmentScreen(
            appointmentId: args,
          ),
        );
        break;
      case virtualWaitingRoom:
        return _buildRoute(
          settings,
          VirtualWaingRoom(
            appointmentId: args,
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

      case viewMedicalHistory:
        return _buildRoute(
          settings,
          ViewMedicalHistoryScreen(isBottomButtonsShow: args),
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
            appointmentId: args,
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
      case activityNotification:
        return _buildRoute(settings, ActivityNotifications());
        break;
      case myProviders:
        return _buildRoute(settings, MyProviders());
        break;
      case paymentHistory:
        return _buildRoute(settings, PaymentHistory());
        break;
      case trackOfficeAppointment:
        return _buildRoute(
            settings,
            TrackOfficeAppointment(
              appointmentId: args,
            ));
        break;
      case trackOnsiteAppointment:
        return _buildRoute(
            settings,
            TrackOnsiteAppointment(
              appointmentId: args,
            ));
        break;
      case trackTelemedicineAppointment:
        return _buildRoute(
            settings,
            TrackTelemedicineAppointment(
              appointmentId: args,
            ));
        break;
      case welcome:
        return _buildRoute(settings, WelcomeScreen());
        break;
      case addInsurance:
        if (args == null) {
          return _buildRoute(settings, AddInsurance());
        }
        final insuranceType = args[ArgumentConstant.argsinsuranceType];
        return _buildRoute(
            settings,
            AddInsurance(
              insuranceType: insuranceType,
            ));
        break;
      case addFamilyMember:
        return _buildRoute(settings, AddFamilyMember());
        break;
      case providerSearch:
        if (args == null) {
          return _buildRoute(settings, ProviderSearch());
        }
        final searchText = args[ArgumentConstant.searchText];
        return _buildRoute(
            settings,
            ProviderSearch(
              serachText: searchText,
            ));
        break;
      case myProviderNetwork:
        return _buildRoute(settings, MyProviderNetwrok());
        break;
      case memberMessage:
        return _buildRoute(
            settings,
            MemberMessage(
                member: args[ArgumentConstant.member],
                message: args[ArgumentConstant.shareMessage]));
        break;

      case providerAddNetwork:
        return MaterialPageRoute(
            builder: (_) => ProivderAddNetwork(
                doctorId: args[ArgumentConstant.doctorId],
                doctorName: args[ArgumentConstant.doctorName],
                doctorAvatar: args[ArgumentConstant.doctorAvatar]));
        break;
      case createProviderGroup:
        return MaterialPageRoute(builder: (_) => CreateProviderGroup());
        break;
      case inviteSuccess:
        return MaterialPageRoute(builder: (_) => InviteFamilySuccess());
        break;
      case addProviderSuccess:
        return MaterialPageRoute(builder: (_) => AddProviderComplete());
        break;
      case emailVerificationComplete:
        return MaterialPageRoute(builder: (_) => EmailVerifiCompleteScreen());
        break;
      case addCardComplete:
        return MaterialPageRoute(builder: (_) => AddCardComplete());
        break;
      case routePinVerification:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) =>
                OtpVerification(verificationModel: verificationModel));
      case loginPin:
        return MaterialPageRoute(builder: (_) => LoginPin());
      case resetPasswordSuccess:
        return MaterialPageRoute(builder: (_) => ResetPasswordSuccess());
      // case pinSetupSuccess:
      //   return MaterialPageRoute(builder: (_) => PinSetupSuccess());
      case addInsuranceComplete:
        return MaterialPageRoute(builder: (_) => AddInsuranceComplete());
        break;
      case familyCircle:
        return MaterialPageRoute(builder: (_) => FamilyCircle());
        break;
      case inviteFamilyComplete:
        return MaterialPageRoute(builder: (_) => InviteFamilyComplete());
        break;
      case inviteFamilyMember:
        return MaterialPageRoute(builder: (_) => InviteFamilyScreen());
        break;
      case searchMember:
        final shareMessage = args[ArgumentConstant.shareMessage];
        final loadAllData = args.containsKey(ArgumentConstant.loadAllData)
            ? args[ArgumentConstant.loadAllData]
            : false;
        return MaterialPageRoute(
            builder: (_) => SearchMember(
                  message: shareMessage,
                  loadAllData: loadAllData,
                ));
        break;
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
        break;

      case setupPin:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => SetupPin());
        }
        final setPinScreen = args[ArgumentConstant.setPinScreen];
        return MaterialPageRoute(
            builder: (_) => SetupPin(
                  setupScreen: setPinScreen,
                ));
        break;

      case addPaymentOption:
        return MaterialPageRoute(builder: (_) => AddPaymentScreen());
        break;
      case setPinComplete:
        return MaterialPageRoute(builder: (_) => SetPinComplete());
        break;
      case routeForgotPassword:
        final verificationScreen = args[ArgumentConstant.verificationScreen];
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordScreen(verificationScreen));
      case routeResetPin:
        final verificationModel = args[ArgumentConstant.verificationModel];
        return MaterialPageRoute(
            builder: (_) => ResetPin(verificationModel: verificationModel));
        break;
      case routeResetPasswordSuccess:
        return MaterialPageRoute(builder: (_) => ResetPasswordSuccess());
      case routeRegisterNumber:
        return MaterialPageRoute(builder: (_) => RegisterNumber());
      case routeWebView:
        return MaterialPageRoute(builder: (_) => WebView());
      case routeRegister:
        final String number = args[ArgumentConstant.number];
        final String countryCode = args[ArgumentConstant.countryCode];
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(number, countryCode));
      case routeInviteByText:
        final String sms = args[ArgumentConstant.sms];
        final String shareMessage = args[ArgumentConstant.shareMessage];
        return MaterialPageRoute(
            builder: (_) => InviteByTextScreen(
                  sms,
                  shareMessage: shareMessage,
                ));
      case routeAddProvider:
        return MaterialPageRoute(builder: (_) => AddProvider());
      case routeMoreCondition:
        return MaterialPageRoute(builder: (_) => MoreCondition());
      case routeWelcomeNewFollowup:
        return MaterialPageRoute(builder: (_) => WelcomeNewFollowUp());
      case routeBoneAndMuscle:
        String problemId = args[ArgumentConstant.problemIdKey];
        String problemName = args[ArgumentConstant.problemNameKey];
        String problemImage = args[ArgumentConstant.problemImageKey];
        return MaterialPageRoute(
            builder: (_) => BoneMuscleIssue(
                problemId: problemId,
                problemName: problemName,
                problemImage: problemImage));
      case routeConditionBetterWorst:
        String problemId = args[ArgumentConstant.problemIdKey];
        return MaterialPageRoute(
            builder: (_) => MakesConditionBetterWorst(
                  problemId: problemId,
                ));

      case routeImmunization:
        return MaterialPageRoute(builder: (_) => ImmunizationScreen());
      case routeEffectAbility:
        return MaterialPageRoute(builder: (_) => EffectAbilityScreen());
      case routeAbnormal:
        bool abnormal = args[ArgumentConstant.isAbnormalKey];
        bool maleHealth = args[ArgumentConstant.isMaleHealthKey];
        bool femaleHealth = args[ArgumentConstant.isFemaleHealthKey];
        bool woundSkin = args[ArgumentConstant.isWoundSkinKey];
        bool dentalCare = args[ArgumentConstant.isDentalCareKey];
        bool hearingSight = args[ArgumentConstant.isHearingSightKey];
        return MaterialPageRoute(
            builder: (_) => AbnormalSensation(
                abnormal: abnormal,
                maleHealth: maleHealth,
                femaleHealth: femaleHealth,
                woundSkin: woundSkin,
                dentalCare: dentalCare,
                hearingSight: hearingSight));
      case routeBreathingIssue:
        bool isAntiAging = args[ArgumentConstant.isAntiAgingKey];
        bool stomach = args[ArgumentConstant.isStomachKey];
        bool breathing = args[ArgumentConstant.isBreathingKey];
        bool healthChest = args[ArgumentConstant.isHealthChestKey];
        bool nutrition = args[ArgumentConstant.isNutritionKey];
        return MaterialPageRoute(
            builder: (_) => BreathingIssue(
                isAntiAging: isAntiAging,
                stomach: stomach,
                breathing: breathing,
                healthChest: healthChest,
                nutrition: nutrition));
      case routeVitalReviews:
        return MaterialPageRoute(builder: (_) => VitalReviews());
      case routeTestDiagnosis:
        return MaterialPageRoute(builder: (_) => TestDiagnosisScreen());
      case routeConditionTimeScreen:
        bool isForProblem = args[ArgumentConstant.isForProblemKey];
        return MaterialPageRoute(
            builder: (_) => ConditionTimeScreen(isForProblem: isForProblem));
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
      case routeCurrentMedicalHistory:
        return MaterialPageRoute(builder: (_) => CurrentMedicalHistory());
      case routeUploadDiagnosticResult:
        return MaterialPageRoute(builder: (_) => UploadDiagnosticResult());
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
      case routeAddPharmacy:
        return MaterialPageRoute(builder: (_) => AddPharmacy());
      case allImagesTabsScreen:
        return _buildRoute(settings, AllImagesTabs());
        break;
      case allDocumentsTabsScreen:
        return _buildRoute(settings, AllDocumentsTabs());
        break;
      case chat:
        return _buildRoute(settings, Chat(appointment: args));
        break;
      case routeUploadDiagnosticNew:
        return MaterialPageRoute(builder: (_) => UploadDiagnosticNew());

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

class SelectDateTimeArguments {
  final String appointmentId;
  final int fromScreen;

  SelectDateTimeArguments({this.fromScreen, this.appointmentId});
}
