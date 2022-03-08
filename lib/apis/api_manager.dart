import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:hutano/screens/add_insurance/model/req_add_insurace.dart';
import 'package:hutano/screens/add_insurance/model/res_get_my_insurance.dart';
import 'package:hutano/screens/appointments/model/model/res_disease_model.dart';
import 'package:hutano/screens/appointments/model/req_add_disease_model.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/appointments/model/req_communication_center_model.dart';
import 'package:hutano/screens/appointments/model/res_communication_center_model.dart';
import 'package:hutano/screens/appointments/model/res_medical_documents_model.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/screens/book_appointment/conditiontime/model/req_treated_condition_time.dart';
import 'package:hutano/screens/book_appointment/diagnosis/model/req_add_diagnostic_test_model.dart';
import 'package:hutano/screens/book_appointment/diagnosis/model/res_diagnostic_test_model.dart';
import 'package:hutano/screens/book_appointment/diagnosis/model/res_diagnostic_test_result.dart';
import 'package:hutano/screens/book_appointment/model/allergy.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/res_more_condition_model.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/req_selected_condition_model.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/res_selected_condition_model.dart';
import 'package:hutano/screens/book_appointment/vitals/model/req_add_vital_model.dart';
import 'package:hutano/screens/chat/models/chat_data_model.dart';
import 'package:hutano/screens/chat/models/recent_chat_model.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/screens/dashboard/model/res_invite_friends.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/req_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_relation_list.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_add_permission.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_add_permission_model.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_family_network.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_remove_family_member.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_network.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_user_permission_model.dart';
import 'package:hutano/screens/familynetwork/member_message/model/req_message_share.dart';
import 'package:hutano/screens/familynetwork/member_message/model/res_message_share.dart';
import 'package:hutano/screens/invite/model/req_invite.dart';
import 'package:hutano/screens/invite/model/res_invite.dart';
import 'package:hutano/screens/medical_history/model/req_add_current_medical_history.dart';
import 'package:hutano/screens/medical_history/model/req_add_my_insurace.dart';
import 'package:hutano/screens/medical_history/model/req_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/req_pay_appointment.dart';
import 'package:hutano/screens/medical_history/model/req_remove_medical_images.dart';
import 'package:hutano/screens/medical_history/model/req_upload_images.dart';
import 'package:hutano/screens/medical_history/model/req_upload_insurance_document.dart';
import 'package:hutano/screens/medical_history/model/res_body_part_model.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_medical_images_upload.dart';
import 'package:hutano/screens/medical_history/model/res_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_medicine.dart';
import 'package:hutano/screens/payment/model/res_reward_points.dart';
import 'package:hutano/screens/pharmacy/model/preferred_pharmacy.dart';
import 'package:hutano/screens/pharmacy/model/req_add_pharmacy_model.dart';
import 'package:hutano/screens/pharmacy/model/res_google_place_detail_pharmacy.dart';
import 'package:hutano/screens/pharmacy/model/res_preferred_pharmacy_list.dart'
    as Pha;
import 'package:hutano/screens/providercicle/my_provider_network/model/req_remove_provider.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/req_share_provider.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/res_my_provider_network.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/res_remove_provider.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/res_share_provider.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/req_add_provider.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/res_add_provider.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/res_provider_group.dart';
import 'package:hutano/screens/providercicle/provider_search/model/res_search_provider.dart';
import 'package:hutano/screens/providercicle/search/model/req_search_number.dart';
import 'package:hutano/screens/providercicle/search/model/res_search_number.dart';
import 'package:hutano/screens/registration/email_verification/model/req_email.dart';
import 'package:hutano/screens/registration/forgotpassword/model/req_reset_password.dart';
import 'package:hutano/screens/registration/forgotpassword/model/res_reset.dart';
import 'package:hutano/screens/registration/forgotpassword/model/res_reset_password.dart';
import 'package:hutano/screens/registration/login_pin/model/req_login_pin.dart';
import 'package:hutano/screens/registration/login_pin/model/res_login_pin.dart';
import 'package:hutano/screens/registration/payment/model/req_add_card.dart';
import 'package:hutano/screens/registration/payment/model/res_add_card.dart';
import 'package:hutano/screens/registration/payment/model/res_get_card.dart';
import 'package:hutano/screens/registration/register/model/req_register.dart';
import 'package:hutano/screens/registration/register/model/req_verify_address.dart';
import 'package:hutano/screens/registration/register/model/res_check_email.dart';
import 'package:hutano/screens/registration/register/model/res_google_address_suggetion.dart';
import 'package:hutano/screens/registration/register/model/res_google_place_detail.dart';
import 'package:hutano/screens/registration/register/model/res_google_place_suggetions.dart';
import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';
import 'package:hutano/screens/registration/register/model/res_my_insurancelist.dart';
import 'package:hutano/screens/registration/register/model/res_register.dart';
import 'package:hutano/screens/registration/register/model/res_states_list.dart';
import 'package:hutano/screens/registration/register/model/res_verify_address.dart';
import 'package:hutano/screens/registration/register_phone/model/req_register_number.dart';
import 'package:hutano/screens/registration/register_phone/model/res_register_number.dart';
import 'package:hutano/screens/registration/signin/model/req_login.dart';
import 'package:hutano/screens/registration/signin/model/res_login.dart';
import 'package:hutano/screens/setup_pin/model/req_setup_pin.dart';
import 'api_constants.dart';
import 'api_service.dart';
import 'common_res.dart';
import 'error_model.dart';
import 'google_service.dart';

class ApiManager {
  final ApiService _apiService = ApiService();
  final GoogleService _googleService = GoogleService();
  final auth = 'auth/api/';
  final patient = 'api/patient/';
  final api = 'api/';

  Future<ResLogin> login(ReqLogin model) async {
    try {
      final response = await _apiService.post(
        apiLogin,
        data: model.toJson(),
      );
      return ResLogin.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResDiseaseModel> getNewDisease() async {
    try {
      final response = await _apiService.get(getNewDiseaseEndPoint);
      return ResDiseaseModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<List<Disease>> searchDisease(searchString) async {
    try {
      final response = await _apiService
          .get('api/search-medical-history?searchString=$searchString');
      return ResDiseaseModel.fromJson(response.data).response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<List<Allergy>> searchAllergies(searchString) async {
    try {
      final response =
          await _apiService.get('api/search-allergy?search=$searchString');
      return AllergiesData.fromJson(response.data).response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<List<SearchAppointment>> searchAppointments(searchString) async {
    try {
      final response = await _apiService.get(
          'api/patient/search-doctor-appointment-list?searchString=$searchString');
      var aa = SearchAppointmentData.fromJson(response.data).response;
      return aa;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<RecentChatData> getRecentChats() async {
    try {
      final response = await _apiService.get('api/patient/recent-chats');
      var aa = RecentChatData.fromJson(response.data);
      return aa;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<MessagesData> getChatDetail(appointmentId) async {
    try {
      final response = await _apiService
          .get('api/patient/chat-details?appointmentId=$appointmentId');
      return MessagesData.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<PreferredPharmacyData> getMyPharmacies() async {
    try {
      final response = await _apiService.get('api/patient/preferred-Pharmacy');
      return PreferredPharmacyData.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> addPreferredPharmacy(Pha.Pharmacy pharmacyModel) async {
    try {
      final response = await _apiService.post('api/patient/preferred-Pharmacy',
          data: pharmacyModel.toJson());
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMedicalDocumentsModel> getMyDisease() async {
    try {
      final response = await _apiService.get('api/patient/medical-history');
      return ResMedicalDocumentsModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<List<Allergy>> getMyAllergies() async {
    try {
      final response = await _apiService.get('api/patient/medical-allergy');
      return MyAllergiesData.fromJson(response.data).response[0].allergy;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResCommunicationReasonModel> getCommunicationCenterReason() async {
    try {
      final response = await _apiService.get(getCommunicationReasonEndPoint);
      return ResCommunicationReasonModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addCommunicationReason(
      ReqCommunicationReasonModel reqCommunicationReasonModel) async {
    try {
      final response = await _apiService.post(addCommunicationReasonEndPoint,
          data: reqCommunicationReasonModel.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> updatePatientDisease(
      ReqAddDiseaseModel reqAddDiseaseModel) async {
    try {
      final response = await _apiService.post(
          'api/patient/medical-history-update',
          data: reqAddDiseaseModel.toJson());
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> addPatientDisease(
      ReqAddDiseaseModel reqAddDiseaseModel) async {
    try {
      final response = await _apiService.post('api/patient/medical-history',
          data: {'medicalHistory': reqAddDiseaseModel.toJson()});
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> addPatientAllergy(Allergy allergyModel) async {
    try {
      final response = await _apiService.post('api/patient/medical-allergy',
          data: allergyModel.toJson());
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addPharmacy(ReqAddPharmacyModel reqAddPharmacyModel) async {
    try {
      final response = await _apiService.post(addPharmacyEndPoint,
          data: reqAddPharmacyModel.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addVital(ReqAddVitalsModel reqAddVitalsModel) async {
    try {
      final response = await _apiService.post(addVitalsEndPoint,
          data: reqAddVitalsModel.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addDiagnosticsData(
      ReqAddDiagnosticTestModel reqAddDiagnosticTestModel) async {
    try {
      final response = await _apiService.post(addDiagnosticsPoint,
          data: reqAddDiagnosticTestModel.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addTreatedConditionTime(
      ReqTreatedConditionTimeModel reqTreatedConditionTimeModel) async {
    try {
      final response = await _apiService.post(addTreatedConditionTimePoint,
          data: reqTreatedConditionTimeModel.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addCurrentMedicalHistory(
      ReqAddCurrentMedicalHistory reqAddCurrentMedicalHistory) async {
    try {
      final response = await _apiService.post(currentMedicalHistoryEndPoint,
          data: reqAddCurrentMedicalHistory.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResUploadedDocumentImagesModel>
      getPatientUploadedDocumentImages() async {
    try {
      final response =
          await _apiService.get(getPatientUploadedDocumentsImagesEndPoint);
      return ResUploadedDocumentImagesModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResDiagnosticTestResult> getUploadedDiagnosticTestResults() async {
    try {
      final response = await _apiService.get(getDiagnosticTestEndPoint);
      return ResDiagnosticTestResult.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResBodyPartModel> getBodyPart() async {
    try {
      final response = await _apiService.get(getBodyPartEndPoint);
      return ResBodyPartModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> searchMedicine(String search) async {
    try {
      final response = await ApiService().get(
        "api/search-prescription?searchString=$search",
      );
      return response.data['response'];
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> addMedicationDetail(
      ReqMedicationDetail reqMedicationDetail) async {
    try {
      final response = await _apiService.post(addMedicationDetailEndPoint,
          data: reqMedicationDetail.toJson());
      return response.data['response'];
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> deleteMedication(String medicationId) async {
    try {
      final response = await _apiService
          .post('api/patient/delete-medications', data: {'id': medicationId});
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // https://dev.hutano.com/api/patient/delete-medications

  Future<PatientMedicationResponse> getMedicationDetails(
      String patientId, int page, String search, filters) async {
    try {
      final response = await _apiService.get(
          'api/user/patient/medication-timeline?user=$patientId&page=$page&search=$search$filters');
      return PatientMedicationResponseData.fromJson(response.data).response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // Future<ReqTest> getOnSiteAddressDetails() async {
  //   try {
  //     final response = await _apiService.get(onSiteAddressEndPoint);
  //     return ReqTest.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  // Future<ResNotificationsModel> getAllNotification() async {
  //   try {
  //     final response = await _apiService.get(notificationEndPoint);
  //     return ResNotificationsModel.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  // Future<ResNotificationRead> getAllNotificationRead() async {
  //   try {
  //     final response = await _apiService.get(notificationReadEndPoint);
  //     return ResNotificationRead.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  Future<ResMoreConditionModel> getMoreConditions() async {
    try {
      final response = await _apiService.get(getMoreConditionEndPoint);
      return ResMoreConditionModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResSelectConditionModel> getHealthConditionDetails(
      ReqSelectConditionModel reqSelectConditionModel) async {
    try {
      final response = await _apiService.post(getHealthConditionDetailsEndPoint,
          data: reqSelectConditionModel.toJson());
      return ResSelectConditionModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResDiagnositcTestModel> getDiagnosticTestTypeList() async {
    try {
      final response = await _apiService.get(getDiagnosticTestFromApiEndPoint);
      return ResDiagnositcTestModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<List<Pha.Pharmacy>> getPreferredPharmacyList(String input) async {
    try {
      final response =
          await _apiService.get("api/search-pharmacy?searchString=$input");
      return Pha.ResPreferredPharmacyList.fromJson(response.data).response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // Future<ResSearchMedicalHistory> getSearchedMedicalHistory(
  //     String input) async {
  //   try {
  //     final response = await _apiService
  //         .get("api/search-medical-history?searchString=$input");
  //     return ResSearchMedicalHistory.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  Future<CommonRes> emailVerification(ReqEmail reqEmail) async {
    try {
      final response = await _apiService.post(
        apiEmailVerification,
        data: reqEmail.toJson(),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> resendEmailOtp(ReqEmail reqEmail) async {
    try {
      final response = await _apiService.post(
        'auth/api/resend-email-verification-code',
        data: reqEmail.toJson(),
      );
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> verifyEmailOtp(ReqEmail reqEmail) async {
    try {
      final response = await _apiService.post(
        'auth/api/verify-email-verification-code',
        data: reqEmail.toJson(),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResResetPassword> resetPassword(ReqResetPassword model) async {
    try {
      final response = await _apiService.post(
        auth + apiResetPasswordNew,
        data: model.toMap(),
      );
      return ResResetPassword.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResReset> resetPasswordStep3(ReqResetPassword model) async {
    try {
      final response = await _apiService.post(
        auth + apiResetPasswordNew,
        data: model.toMap(),
      );
      return ResReset.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResResetPassword> resetPin(ReqResetPassword model) async {
    try {
      final response = await _apiService.post(
        auth + apiResetPin,
        data: model.toMap(),
      );
      return ResResetPassword.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> updateAppointmentData(Map<String, dynamic> model) async {
    try {
      final response = await _apiService.post(
        "api/patient/appointment-booking-v1/update",
        data: model,
      );
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRegisterNumber> otpOnCall(ReqRegsiterNumber model) async {
    try {
      final response = await _apiService.post(
        auth + apiOtpOnCall,
        data: model.toMap(),
      );
      return ResRegisterNumber.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResReset> resetPinStep3(ReqResetPassword model) async {
    try {
      final response = await _apiService.post(
        auth + apiResetPin,
        data: model.toMap(),
      );
      return ResReset.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> getSetupIntent() async {
    try {
      final response = await _apiService.get(
        'api/stripe-setUp-intent',
      );
      return response.data;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
    // Map<String, String> headers = {
    //   HttpHeaders.authorizationHeader: token,
    // };
    // return _netUtil
    //     .get(
    //   Uri.encodeFull(base_url + "api/stripe-setUp-intent"),
    //   headers: headers,
    // )
    //     .then((res) {
    //   return res["response"];
    // });
  }

  Future<ResAddCard> addCard(ReqAddCard reqCard) async {
    try {
      final response = await _apiService.post(
        apiAddCard,
        data: reqCard.toJson(),
      );
      return ResAddCard.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGetCard> getCard() async {
    try {
      final response = await _apiService.get(
        apiGetCard,
      );
      return ResGetCard.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRegisterNumber> sendPhoneVerificationCode(
      ReqRegsiterNumber model) async {
    try {
      final response = await _apiService.post(
        auth + 'send-phone-verification-code',
        data: model.toMap(),
      );
      return ResRegisterNumber.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRegisterNumber> resendPhoneVerificationCode(
      ReqRegsiterNumber model) async {
    try {
      final response = await _apiService.post(
        auth + 'resend-phone-verification-code',
        data: model.toMap(),
      );
      return ResRegisterNumber.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRegisterNumber> register(ReqRegsiterNumber model) async {
    try {
      final response = await _apiService.post(
        auth + apiRegister,
        data: model.toMap(),
      );
      return ResRegisterNumber.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> sendInvite(ReqInvite model) async {
    try {
      final response = await _apiService.post(
        apiSendInvitaion,
        data: model.toJson(),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> setPin(ReqSetupPin model) async {
    try {
      final response = await _apiService.post(
        apiCreatePin,
        data: model.toJson(),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResLoginPin> loginPin(ReqLoginPin model) async {
    try {
      final response = await _apiService.post(
        auth + apiLoginPin,
        data: model.toMap(),
      );
      return ResLoginPin.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResSearchNumber> searchContact(ReqSearchNumber model) async {
    try {
      final response = await _apiService.post(
        patient + apiSearchContact,
        data: model.toMap(),
      );
      return ResSearchNumber.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRelationList> getRelations() async {
    try {
      final response = await _apiService.get(
        patient + apiUserRelations,
      );
      return ResRelationList.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResAddMember> addMember(ReqAddMember model) async {
    try {
      final response =
          await _apiService.post(patient + apiAddMember, data: model.toJson());
      return ResAddMember.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResCheckEmail> checkEmailExist(Map<String, String> request) async {
    try {
      final response =
          await _apiService.post(api + apiCheckEmailExist, data: request);
      return ResCheckEmail.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResInsuranceList> insuraceList() async {
    try {
      final response = await _apiService.get(api + apiGetInsurance);
      return ResInsuranceList.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResStatesList> statesList() async {
    try {
      final response = await _apiService.get(api + apiGetStates);
      return ResStatesList.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResVerifyAddress> verifyAddress(ReqVerifyAddress model) async {
    try {
      final response = await _apiService.post(
        auth + apiVerifyAddress,
        data: model.toMap(),
      );
      return ResVerifyAddress.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResFamilyNetwork> getFamilyNetowrk(ReqFamilyNetwork model) async {
    try {
      final response = await _apiService.post(
        patient + apiGetFamilyNetwork,
        data: model.toMap(),
      );
      return ResFamilyNetwork.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResFamilyCircle> getFamilyCircle(ReqFamilyNetwork model) async {
    try {
      final response = await _apiService.get(
        patient + apiGetFamilyNetwork,
        // data: model.toMap(),
      );
      return ResFamilyCircle.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResUserPermissionModel> getUserPermission() async {
    try {
      final response = await _apiService.get(
        patient + apiUserPermission,
        // data: model.toMap(),
      );
      return ResUserPermissionModel.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRegister> registerUser(ReqRegister request, File profile) async {
    try {
      var formData = FormData.fromMap(request.toMap());
      if (profile != null) {
        final fileName = profile.path.split('/').last;
        var file = await MultipartFile.fromFile(profile.path,
            filename: fileName, contentType: MediaType("image", fileName));
        formData.files.add(MapEntry('avatar', file));
      }

      final response = await ApiService().multipartPost(
        auth + apiRegister,
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return ResRegister.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResAddMember> setMemberPermission(ReqAddPermission model) async {
    try {
      final response =
          await _apiService.post(patient + apiAddMember, data: model.toMap());
      return ResAddMember.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> setSpecificMemberPermission(
      ReqAddUserPermissionModel model, String memberId) async {
    try {
      final response = await _apiService
          .post(patient + apiAddPermission + memberId, data: model.toJson());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResProviderSearch> searchProvider(Map<String, dynamic> search) async {
    try {
      final response =
          await _apiService.get(api + apiGetProviders, params: search);
      return ResProviderSearch.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // Future<ResProviderPacakges> getProviderPackages(
  //     Map<String, dynamic> param) async {
  //   try {
  //     final response = await _apiService.get(patient + apiGetProviderPackages,
  //         params: param);
  //     return ResProviderPacakges.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  Future<ResProviderGroup> getProviderGroups() async {
    try {
      final response = await _apiService.get(api + apiGetProvidersGroups);
      return ResProviderGroup.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResAddProvider> addProviderNetwork(ReqAddProvider model) async {
    try {
      final response =
          await _apiService.post(api + apiAddProviders, data: model.toMap());
      return ResAddProvider.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> deleteProviderGroup(Map model) async {
    try {
      final response = await _apiService
          .post('api/patient/delete-provider-group', data: model);
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMyProviderNetwork> getMyProviderNetwork() async {
    try {
      final response = await _apiService.get(api + apiMyProviderNetwork);
      return ResMyProviderNetwork.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRemoveProvider> removeProvider(ReqRemoveProvider model) async {
    try {
      final response =
          await _apiService.post(api + apiRemoveProvider, data: model.toMap());
      return ResRemoveProvider.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResShareProvider> shareProvider(ReqShareProvider model) async {
    try {
      final response = await _apiService.post(patient + apiShareProvider,
          data: model.toMap());
      return ResShareProvider.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResShareProvider> shareAllProvider(ReqShareProvider model) async {
    try {
      final response = await _apiService.post(patient + apiShareAllProvider,
          data: model.toMap());
      return ResShareProvider.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMessageShare> shareMessage(ReqMessageShare model) async {
    try {
      final response = await _apiService.post(patient + apiShareMessage,
          data: model.toMap());
      return ResMessageShare.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> removeFamilyNetwork(ReqRemoveFamilyMember model) async {
    try {
      final response = await _apiService.post(
        patient + apiRemoveFamilyNetwork,
        data: model.toJson(),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResRewardPoints> getHutanoCash() async {
    try {
      final response = await _apiService.get(
        patient + apiRewardPoints,
      );
      return ResRewardPoints.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResInviteFriends> inviteMember() async {
    try {
      final response = await _apiService.post(
        patient + apiInviteMember,
      );
      return ResInviteFriends.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // Future<ResAppointmentDetail> appointmentList(ReqAppointmentList model) async {
  //   try {
  //     final response = await _apiService.post(patient + apiAppointmentList,
  //         data: model.toMap());
  //     return ResAppointmentDetail.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  Future<ResMedicalImageUpload> uploadPainImages(
      ReqUploadImage request, File profile) async {
    try {
      var formData = FormData.fromMap(request.toMap());
      if (profile != null) {
        final fileName = profile.path.split('/').last;
        var file = await MultipartFile.fromFile(profile.path,
            filename: fileName, contentType: MediaType("image", fileName));
        formData.files.add(MapEntry('medicalImages', file));
      }

      final response = await ApiService().multipartPost(
        patient + apiImages,
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return ResMedicalImageUpload.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMedicalImageUpload> removeMedicalImages(
      ReqRemoveMedicalImages model) async {
    try {
      final response = await _apiService.post(patient + apiRemoveMedicalImages,
          data: model.toMap());
      return ResMedicalImageUpload.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> payAppointment(ReqPayAppointmnet model) async {
    try {
      final response = await _apiService.post(patient + apiCustomerCharge,
          data: model.toMap());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addInsurance(ReqAddMyInsurance model) async {
    try {
      final response = await _apiService.post(patient + apiAddInsurance,
          data: model.toMap());
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMyInsuranceList> myInsuranceList(Map<String, dynamic> model) async {
    // final param = {'userId': controller.text.toString()};
    try {
      final response =
          await _apiService.post(patient + apiMyInsurance, data: model);
      return ResMyInsuranceList.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> uploadInsuranceDoc(
      File frontImage, ReqUploadInsuranceDocuments model,
      {File backImage}) async {
    try {
      var formData = FormData.fromMap(model.toMap());
      final fileName = frontImage.path.split('/').last;
      var file = await MultipartFile.fromFile(frontImage.path,
          filename: fileName, contentType: MediaType("image", fileName));
      formData.files.add(MapEntry('insuranceDocumentFront', file));

      if (backImage != null) {
        final fileName = backImage.path.split('/').last;
        var file = await MultipartFile.fromFile(backImage.path,
            filename: fileName, contentType: MediaType("image", fileName));
        formData.files.add(MapEntry('insuranceDocumentBack', file));
      }
      final response = await ApiService().multipartPost(
        patient + apiUploadInsuranceImage,
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> addInsuranceDoc(File frontImage, ReqAddInsurance model,
      {File backImage}) async {
    try {
      var formData = FormData.fromMap(model.toMap());
      final fileName = frontImage.path.split('/').last;
      var file = await MultipartFile.fromFile(frontImage.path,
          filename: fileName, contentType: MediaType("image", fileName));
      formData.files.add(MapEntry('insuranceDocumentFront', file));

      if (backImage != null) {
        final fileName = backImage.path.split('/').last;
        var file = await MultipartFile.fromFile(backImage.path,
            filename: fileName, contentType: MediaType("image", fileName));
        formData.files.add(MapEntry('insuranceDocumentBack', file));
      }
      final response = await ApiService().multipartPost(
        patient + apiAddInsuranceDoc,
        data: formData,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResInvite> getInviteMessage(Map<String, dynamic> model) async {
    try {
      final response =
          await _apiService.get(patient + apiGetInviteMessage, params: model);
      return ResInvite.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGooglePlaceSuggetions> getPlaceSuggetions(
      Map<String, dynamic> model) async {
    try {
      final response =
          await _googleService.get(googlePlaceSuggetion, params: model);
      return ResGooglePlaceSuggetions.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGooglePlaceDetail> getPlaceDetail(
      Map<String, dynamic> model) async {
    try {
      final response =
          await _googleService.get(googlePlaceDetail, params: model);
      return ResGooglePlaceDetail.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGooglePlaceDetailPharmacy> getPlacePharmacyDetail(
      Map<String, dynamic> model) async {
    try {
      final response =
          await _googleService.get(googlePlaceDetail, params: model);
      return ResGooglePlaceDetailPharmacy.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGoogleAddressSuggetion> getAddressSuggetion(
      Map<String, dynamic> model) async {
    try {
      final response =
          await _googleService.get(googleAddressSuggetion, params: model);
      return ResGoogleAddressSuggetion.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResGetMyInsurance> getPatientInsurance() async {
    try {
      final response = await _apiService.get(
        patient + apiGetPatientInsurance,
      );
      return ResGetMyInsurance.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> bookNewAppointment(
      ReqBookingAppointmentModel reqBookingAppointmentModel) async {
    try {
      final response = await _apiService.post(newBookingAppointmentFlowEndPoint,
          data: reqBookingAppointmentModel.toJson());
      return response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> updatePaymentMethod(Map<String, dynamic> map) async {
    try {
      final response =
          await _apiService.post(updatePaymentMethodEndPoint, data: map);
      return response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> getAccountByPhoneNumber(String phoneNumber) async {
    try {
      final response = await _apiService
          .get('api/account-by-phone', params: {'phoneNumber': phoneNumber});
      return response.data['response'];
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> sendLinkAccountCode(Map<String, dynamic> map) async {
    try {
      final response = await _apiService
          .post('api/send-link-account-verification-code', data: map);
      return response.data['response'];
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<dynamic> veriyfyLinkAccountCode(Map<String, dynamic> map) async {
    try {
      final response = await _apiService
          .post('api/verify-link-account-verification-code', data: map);
      return response;
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

   Future<dynamic> getLinkAccount() async {
    try {
      final response = await _apiService
          .get('api/link-accounts');
      return response.data['response'];
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  // Future<ResRewardPoints> getHutanoCash() async {
  //   try {
  //     final response = await _apiService.get(
  //       patient + apiRewardPoints,
  //     );
  //     return ResRewardPoints.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  // Future<ResInviteFriends> inviteMember() async {
  //   try {
  //     final response = await _apiService.post(
  //       patient + apiInviteMember,
  //     );
  //     return ResInviteFriends.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }

  // Future<ResTrackingAppointment> getOfficeAppointmentStatus(
  //     Map<String, dynamic> param) async {
  //   try {
  //     final response = await _apiService.get(
  //       patient + apiOfficeAppointmentStatus,
  //       params: param,
  //     );
  //     return ResTrackingAppointment.fromJson(response.data);
  //   } on DioError catch (error) {
  //     throw ErrorModel.fromJson(error.response.data);
  //   }
  // }
}
