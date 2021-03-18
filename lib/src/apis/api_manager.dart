import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:hutano/src/ui/add_insurance/model/req_add_insurace.dart';
import 'package:hutano/src/ui/add_insurance/model/res_get_my_insurance.dart';

import '../ui/appointments/my_appointments/model/req_appointment_list.dart';
import '../ui/appointments/my_appointments/model/res_appointment_list.dart';
import '../ui/auth/forgotpassword/model/req_reset_password.dart';
import '../ui/auth/forgotpassword/model/res_reset.dart';
import '../ui/auth/forgotpassword/model/res_reset_password.dart';
import '../ui/auth/login_pin/model/req_login_pin.dart';
import '../ui/auth/login_pin/model/res_login_pin.dart';
import '../ui/auth/register/model/req_register.dart';
import '../ui/auth/register/model/req_verify_address.dart';
import '../ui/auth/register/model/res_check_email.dart';
import '../ui/auth/register/model/res_google_address_suggetion.dart';
import '../ui/auth/register/model/res_google_place_detail.dart';
import '../ui/auth/register/model/res_google_place_suggetions.dart';
import '../ui/auth/register/model/res_insurance_list.dart';
import '../ui/auth/register/model/res_my_insurancelist.dart';
import '../ui/auth/register/model/res_register.dart';
import '../ui/auth/register/model/res_states_list.dart';
import '../ui/auth/register/model/res_verify_address.dart';
import '../ui/auth/register_phone/model/req_register_number.dart';
import '../ui/auth/register_phone/model/res_register_number.dart';
import '../ui/auth/signin/model/req_login.dart';
import '../ui/auth/signin/model/res_login.dart';
import '../ui/familynetwork/add_family_member/model/req_add_member.dart';
import '../ui/familynetwork/add_family_member/model/res_add_member.dart';
import '../ui/familynetwork/add_family_member/model/res_relation_list.dart';
import '../ui/familynetwork/familycircle/model/req_add_permission.dart';
import '../ui/familynetwork/familycircle/model/req_family_network.dart';
import '../ui/familynetwork/familycircle/model/res_family_network.dart';
import '../ui/familynetwork/member_message/model/req_message_share.dart';
import '../ui/familynetwork/member_message/model/res_message_share.dart';
import '../ui/invite/model/req_invite.dart';
import '../ui/invite/model/res_invite.dart';
import '../ui/medical_history/model/req_add_my_insurace.dart';
import '../ui/medical_history/model/req_pay_appointment.dart';
import '../ui/medical_history/model/req_remove_medical_images.dart';
import '../ui/medical_history/model/req_upload_images.dart';
import '../ui/medical_history/model/req_upload_insurance_document.dart';
import '../ui/medical_history/model/res_medical_images_upload.dart';
import '../ui/provider/my_provider_network/model/req_remove_provider.dart';
import '../ui/provider/my_provider_network/model/req_share_provider.dart';
import '../ui/provider/my_provider_network/model/res_my_provider_network.dart';
import '../ui/provider/my_provider_network/model/res_remove_provider.dart';
import '../ui/provider/my_provider_network/model/res_share_provider.dart';
import '../ui/provider/provider_add_network/model/req_add_provider.dart';
import '../ui/provider/provider_add_network/model/res_add_provider.dart';
import '../ui/provider/provider_add_network/model/res_provider_group.dart';
import '../ui/provider/provider_search/model/res_search_provider.dart';
import '../ui/provider/search/model/req_search_number.dart';
import '../ui/provider/search/model/res_search_number.dart';
import '../ui/registration_steps/email_verification/model/req_email.dart';
import '../ui/registration_steps/payment/model/req_add_card.dart';
import '../ui/registration_steps/payment/model/res_add_card.dart';
import '../ui/registration_steps/payment/model/res_get_card.dart';
import '../ui/registration_steps/setup_pin/model/req_setup_pin.dart';
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

  Future<ResResetPassword> resetPassword(ReqResetPassword model) async {
    try {
      final response = await _apiService.post(
        auth + apiResetPassword,
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
        auth + apiResetPassword,
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
          await _apiService.post(patient + apiAddMember, data: model.toMap());
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

  Future<ResProviderSearch> searchProvider(Map<String, dynamic> search) async {
    try {
      final response =
          await _apiService.get(api + apiGetProviders, params: search);
      return ResProviderSearch.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

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

  Future<ResAppointmentDetail> appointmentList(ReqAppointmentList model) async {
    try {
      final response = await _apiService.post(patient + apiAppointmentList,
          data: model.toMap());
      return ResAppointmentDetail.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

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
}
