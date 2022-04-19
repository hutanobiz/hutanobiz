import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:hutano/main.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/add_insurance/model/req_add_insurace.dart';
import 'package:hutano/screens/add_insurance/model/res_get_my_insurance.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/req_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_relation_list.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_add_permission.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_add_permission_model.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_family_network.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_network.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_user_permission_model.dart';
import 'package:hutano/screens/familynetwork/member_message/model/req_message_share.dart';
import 'package:hutano/screens/familynetwork/member_message/model/res_message_share.dart';
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
import 'package:hutano/screens/registration/forgotpassword/model/req_reset_password.dart';
import 'package:hutano/screens/registration/forgotpassword/model/res_reset.dart';
import 'package:hutano/screens/registration/forgotpassword/model/res_reset_password.dart';
import 'package:hutano/screens/registration/login_pin/model/req_login_pin.dart';
import 'package:hutano/screens/registration/login_pin/model/res_login_pin.dart';
import 'package:hutano/screens/registration/payment/model/res_get_card.dart';
import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';
import 'package:hutano/screens/setup_pin/model/req_setup_pin.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/common_res.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/widgets.dart';

class ApiBaseHelper {
  NetworkUtil _netUtil = new NetworkUtil();
  static const String imageUrl = "https://hutano-assets.s3.amazonaws.com/";
  static const String base_u = "hutano.appening.xyz";
  static const String base_url = "https://hutano.appening.xyz/";
  static const String socket_url = "https://hutano.appening.xyz";
  // static const String base_url = "https://dev.hutano.com/";
  // static const String base_u = "dev.hutano.com";
  // static const String socket_url = "https://dev.hutano.com";

  // static const String base_u = "staging.hutano.com";
  // static const String base_url = "https://staging.hutano.com/";
  // static const String socket_url = "https://staging.hutano.com";
  // static const String base_u = "production.hutano.com/";
  // static const String base_url = "https://production.hutano.com/";
  // static const String socket_url = "https://production.hutano.com";
  // static const String base_u = "www.hutano.com/";
  // static const String base_url = "https://www.hutano.com/";
  // static const String socket_url = "https://www.hutano.com";

  static const String image_base_url =
      "https://hutano-assets.s3.amazonaws.com/";

  Future<dynamic> login(Map loginData) {
    return _netUtil
        .post(base_url + "auth/api/login", body: loginData)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> sendEmailOtp(BuildContext context, Map verifyEmail) {
    return _netUtil
        .post(base_url + "auth/api/resend-email-verification-code",
            body: verifyEmail)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> verifyEmailOtp(
      BuildContext context, Map<String, String> loginData) {
    return _netUtil
        .post(base_url + "auth/api/verify-email-verification-code",
            body: loginData)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> sendPhoneOtp(BuildContext context, Map verifyEmail) {
    return _netUtil
        .post(base_url + "auth/api/send-phone-verification-code",
            body: verifyEmail)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> verifyPhoneOtp(
      BuildContext context, Map<String, String> loginData) {
    return _netUtil
        .post(base_url + "auth/api/verify-phone-verification-code",
            body: loginData)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> resendPhoneOtp(BuildContext context, Map verifyEmail) {
    return _netUtil
        .post(base_url + "auth/api/resend-phone-verification-code",
            body: verifyEmail)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> resendPhoneVerificationCode(
      BuildContext context, Map verifyEmail) {
    return _netUtil
        .post(base_url + "auth/api/resend-phone-verification-code",
            body: verifyEmail)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> registerPassword(Map<String, String> map) {
    return _netUtil
        .post(base_url + "auth/api/set-password", body: map)
        .then((res) {
      return (res["response"]);
    });
  }

  Future<dynamic> register(Map<String, String> map) {
    return _netUtil.post(base_url + "auth/api/register", body: map).then((res) {
      return (res["response"]);
    });
  }

  Future<ResResetPassword> resetPassword(ReqResetPassword map) {
    return _netUtil
        .post(base_url + "auth/api/reset-password-new", body: map.toMap())
        .then((res) {
      return ResResetPassword.fromJson(res);
    });
  }

  // Future<ResResetPassword> resetPassword(ReqResetPassword map) {
  //   return _netUtil
  //       .post(base_url + "auth/api/phone-reset-password", body: map.toMap())
  //       .then((res) {
  //     return ResResetPassword.fromJson(res);
  //   });
  // }

  Future<ResReset> resetPinStep3(ReqResetPassword model) async {
    return _netUtil
        .post(base_url + "auth/api/reset-pin", body: model.toMap())
        .then((res) {
      return ResReset.fromJson(res);
    });
  }

  Future<ResResetPassword> resetPin(ReqResetPassword model) async {
    return _netUtil
        .post(
      base_url + 'auth/api/reset-pin',
      body: model.toMap(),
    )
        .then((res) {
      return ResResetPassword.fromJson(res);
    });
  }

  Future<dynamic> checkEmailExist(Map<String, String> request) async {
    return _netUtil
        .postNotHandleError(
      base_url + 'api/check-user',
      body: request,
    )
        .then((res) {
      return res;
    });
  }

  Future<dynamic> loginPin(ReqLoginPin model) async {
    return _netUtil
        .post(
      base_url + 'auth/api/pin-login',
      body: model.toMap(),
    )
        .then((res) {
      return res;
    });
  }

  Future<dynamic> otpOnCall(Map model) async {
    return _netUtil
        .post(
      base_url + 'auth/api/otp-on-call',
      body: model,
    )
        .then((res) {
      return res;
    });
  }

  Future<dynamic> profile(String token, Map map) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };

    return _netUtil
        .post(base_url + "api/profile/update",
            headers: headers, body: json.encode(map))
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getPatientCard(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url + "api/stripe-card"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getConsentContent(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url + "api/patient/consent-treat"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> deletePharmacy(String token, String pharmacyId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url +
          "api/patient/preferred-Pharmacy-delete?pharmacyId=$pharmacyId"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getSetupIntent(BuildContext context, String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url + "api/stripe-setUp-intent"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> emailVerfication(String token, Map map) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };

    return _netUtil
        .post(base_url + "api/email-verification",
            headers: headers, body: json.encode(map))
        .then((res) {
      return res;
    });
  }

  Future<dynamic> bookAppointment2(
      BuildContext context, String token, Map map) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };
    return _netUtil
        .post(base_url + "api/patient/appointment-booking-v1",
            headers: headers, body: json.encode(map))
        .then((res) {
      return res;
    });
  }

  Future<List<dynamic>> getProfessionalTitle() {
    return _netUtil.get(base_url + "api/professional-titles").then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getProfessionalSpecility(Map map) {
    return _netUtil
        .post(base_url + "api/provider/specialties", body: map)
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getStates() {
    return _netUtil.get(base_url + "api/states").then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<Schedule>> getScheduleList(String providerId, Map doctorData) {
    return _netUtil
        .post(Uri.encodeFull(base_url + 'api/doctor-slots/$providerId'),
            body: doctorData)
        .then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => Schedule.fromJson(m)).toList();
    });
  }

  Future<dynamic> bookAppointment(String token, Map appointmentData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(base_url + "api/patient/appointment-booking",
            body: appointmentData, headers: headers)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> searchDoctors(String string) {
    return _netUtil
        .get(Uri.encodeFull(
            base_url + "api/patient/name/specialty/service?search=$string"))
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> appointmentRequests(String token, LatLng latLng) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
// user-notification
    return _netUtil
        .get(
      base_url +
          "api/patient/user-schedule-appointmnet-pending?longitude=${latLng.longitude.toStringAsFixed(2)}"
              "&lattitude=${latLng.latitude.toStringAsFixed(2)}",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> userAppointments(String token, LatLng latLng) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(
            base_url +
                "api/patient/user-schedule-appointmnet?longitude"
                    "=${latLng.longitude.toStringAsFixed(2)}"
                    "&latitude=${latLng.latitude.toStringAsFixed(2)}",
            headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getProviderProfile(String providerId, Map locMap) {
    return _netUtil
        .get(
      Uri.encodeFull(
        base_url +
            "api/patient/doctor-details?id=$providerId&longitude"
                "=${locMap['longitude']}&lattitude=${locMap['lattitude']}",
      ),
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getProviderAddress(String token, String providerId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url +
          'api/patient/doctor-location-address?doctorId=$providerId'),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<Map> getUnreadNotifications(BuildContext context, token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(base_url + "api/patient/unread-notification-list",
            headers: headers)
        .then((res) {
      print(res.toString());
      return res['response'];
    });
  }

  Future<Map> getAllNotifications(BuildContext context) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader:
          "Bearer ${getString(PreferenceKey.tokens)}",
    };
    return _netUtil
        .get(base_url + "api/patient/notification-list", headers: headers)
        .then((res) {
      print(res.toString());
      return res;
    });
  }

  Future<Map> checkCardInsuranceAdded(BuildContext context) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader:
          "Bearer ${getString(PreferenceKey.tokens)}",
    };
    return _netUtil
        .get(base_url + "api/patient/check-card-insurence-added",
            headers: headers)
        .then((res) {
      print(res.toString());
      return res;
    });
  }

  Future<Map> readNotifications(BuildContext context) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader:
          "Bearer ${getString(PreferenceKey.tokens)}",
    };
    return _netUtil
        .get(base_url + "api/patient/notification-read", headers: headers)
        .then((res) {
      print(res.toString());
      return res;
    });
  }

  Future<List<dynamic>> getStripeStatements(BuildContext context, token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(base_url + "api/patient/stripe-statements", headers: headers)
        .then((res) {
      print(res.toString());
      return res['response'];
    });
  }

  Future<dynamic> getAppointmentDetails(
      String token, String providerId, LatLng latLng) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(
        base_url +
            "api/patient/doctor-appointment-details?id=$providerId&longitude"
                "=${latLng.longitude.toStringAsFixed(2)}"
                "&lattitude=${latLng.latitude.toStringAsFixed(2)}",
      ),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getGraphData(String token, String key, String date) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(
        base_url + "api/vital/graff?key=$key&date=$date",
      ),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> postGraphData(String token, Map graphData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(base_url + "api/vital", body: graphData, headers: headers)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getChatAppointmentDetails(
      String token, String appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(base_url +
          "api/patient/get-appointment-details?appointmentId=$appointmentId"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> rescheduleAppointment(String token, Map map) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };

    return _netUtil
        .post(base_url + "api/reschedule-appointment",
            headers: headers, body: json.encode(map))
        .then((res) {
      return res;
    });
  }

  Future<dynamic> postPayment(
      String token, String appointmentId, Map paymentMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      Uri.encodeFull(
          base_url + "api/patient/appointment-details/$appointmentId"),
      body: paymentMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> rateDoctor(String token, Map rateDoctorData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(base_url + "api/patient/provider-rating",
            body: rateDoctorData, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> patientAvailableForCall(String token, Map appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(base_url + "api/patient/join-call",
            body: appointmentId, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> cancelRequest(String token, Map rateDoctorData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(base_url + "api/patient/cancel-request",
            body: rateDoctorData, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getDiseases() {
    return _netUtil.get(base_url + "api/disease").then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getLastAppointmentDetails(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      base_url + "api/patient/last-appointment-detail",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getUserDetails(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      base_url + "api/patient/user-details",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getInsuranceList() {
    return _netUtil
        .get(
      base_url + "api/insurance",
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<ResInsuranceList> insuraceList() {
    return _netUtil
        .get(
      base_url + "api/insurance",
    )
        .then((res) {
      return ResInsuranceList.fromJson(res);
    });
  }

  Future<dynamic> updateAppointmentCoordinates(
      String token, Map locationMap, String appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
            Uri.encodeFull(
                base_url + "api/appointment-coordinates/$appointmentId"),
            body: locationMap,
            headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> appointmentTrackingStatus(
      String token, Map rateDoctorData, String appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(base_url + "api/appointment-tracking-status/" + appointmentId,
            body: rateDoctorData, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> onsiteAppointmentTrackingStatus(
      String token, Map rateDoctorData, String appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      base_url + "api/onsite/appointment-tracking-status/" + appointmentId,
      body: rateDoctorData,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> updateAppointmentData(
      String token, Map<String, dynamic> rateDoctorData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      base_url + "api/patient/appointment-booking-v1/update",
      body: rateDoctorData,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> deleteinsurance(String token, String insuranceId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map insuranceMap = {};
    insuranceMap['insuranceId'] = insuranceId;

    return _netUtil
        .post(
      base_url + "api/patient/delete-insurance",
      body: insuranceMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> insuranceRemove(String token, String insuranceId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      base_url + "api/patient/insurance-remove",
      body: {'insuranceId': insuranceId},
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> deleteStripeCard(String token, String cardId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      base_url + "api/delete-stripe-card",
      body: {'cardId': cardId},
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> providerFilter(String token, Map filterMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
      base_url + "api/search",
      body: filterMap,
      headers: headers,
    )
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getDistanceAndTime(
      LatLng source, LatLng dest, String apiKey) {
    return _netUtil
        .get(Uri.encodeFull(
            "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial" +
                "&origins=${source.latitude},${source.longitude}&destinations=${dest.latitude},${dest.longitude}&key=$apiKey"))
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getAppointmentRecordings(
      BuildContext context, String token, String appointmentId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };
    return _netUtil
        .get(
            base_url +
                "api/appointmnet-video-calls?appointmentId=$appointmentId",
            headers: headers)
        .then((res) {
      print(res.toString());
      return res["response"];
    });
  }

  Future<dynamic> multipartPost(String url, String token,
      Map<String, String> fileMap, List<MultipartFile> files) {
    return _netUtil
        .multipartPost(
      url,
      token: token,
      fileMap: fileMap,
      files: files,
    )
        .then((res) {
      return res;
    });
  }

  Future<String> deletePatientImage(String token, String imageId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map imageNameMap = {};
    imageNameMap['id'] = imageId;

    return _netUtil
        .post(
      base_url + "api/patient/delete-image",
      body: imageNameMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<String> deletePatientMedicalDocs(String token, String medicalDocId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map medicalDocumentMap = {};
    medicalDocumentMap['id'] = medicalDocId;

    return _netUtil
        .post(
      base_url + "api/patient/delete-medical-documents",
      body: medicalDocumentMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getPatientDocuments(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      base_url + "api/patient/medical-images-documents",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getDegrees() {
    return _netUtil.get(base_url + "api/education-qualification").then((res) {
      return res["response"];
    });
  }

  Future<String> sendPatientMedicalHistory(String token, Map diseaseMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
      base_url + "api/patient/medical-history",
      body: diseaseMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<String> deletePatientMedicalHistory(String token, String diseaseId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map diseaseMap = {};
    diseaseMap['medicalHistory'] = diseaseId;

    return _netUtil
        .post(
      base_url + "api/patient/delete-medical-history",
      body: diseaseMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<String> deletePatientAllergyHistory(String token, String allergyId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map diseaseMap = {};
    diseaseMap['medicalAllergy'] = allergyId;

    return _netUtil
        .post(
      base_url + "api/patient/delete-medical-allergy",
      body: diseaseMap,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getLanguages() {
    return _netUtil.get(base_url + "api/languages").then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getSpecialties() {
    return _netUtil.get(base_url + "api/specialties").then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getMyDoctors(String token, LatLng latLng) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(
      base_url +
          "api/patient/my-doctors?longitude=${latLng.longitude.toStringAsFixed(2)}"
              "&lattitude=${latLng.latitude.toStringAsFixed(2)}",
      headers: headers,
    )
        .then((res) {
      return res["response"]['patientData'];
    });
  }

  Future<List<dynamic>> getOnDemandDoctors(
      String token, LatLng latLng, String radius, String timeZone) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(
      base_url +
          "api/patient/ondemand-available-doctors?longitude=${latLng.longitude.toStringAsFixed(2)}&latitude=${latLng.latitude.toStringAsFixed(2)}&radius=$radius&timeZone=$timeZone",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getSavedDoctors(
      String token, LatLng latLng, String radius) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(
      base_url +
          "api/patient/saved-doctors?longitude=${latLng.longitude.toStringAsFixed(2)}&latitude=${latLng.latitude.toStringAsFixed(2)}&radius=$radius",
      headers: headers,
    )
        .then((res) {
      return res['response'];
    });
  }

  Future<List<dynamic>> getServices({String specialityId}) {
    return _netUtil
        .get(
      base_url + "api/services?id=$specialityId",
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getSpecialityServices(Map map) {
    return _netUtil
        .post(
      base_url + "api/services",
      body: map,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getAllTitleSpecilities() {
    return _netUtil.get(base_url + "api/title-specialties").then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> getAddress(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      base_url + "api/patient/address",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> deleteAddress(String token, String id) {
    Map _map = {};
    _map['id'] = id;

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .post(
      base_url + "api/patient/delete-address",
      body: _map,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> addAddress(String token, Map addressMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };
    return _netUtil
        .post(
      base_url + "api/patient/address",
      body: json.encode(addressMap),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> editAddress(String token, Map addressMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };
    return _netUtil
        .post(
      base_url + "api/patient/edit-address",
      body: json.encode(addressMap),
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> logOUt(String token, String deviceToken) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    Map map = {};
    map['deviceToken'] = deviceToken;

    return _netUtil
        .post(
      base_url + "auth/api/logout",
      body: map,
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> cancelAppointment(String token, Map appointmentData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
      base_url + "api/patient/appointment-cancel-status",
      body: appointmentData,
      headers: headers,
    )
        .then((res) {
      return res;
    });
  }

  Future<dynamic> cancelCallEndNotification(String token, Map appointmentData) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
      base_url + "api/cancel-call-push-notification",
      body: appointmentData,
      headers: headers,
    )
        .then((res) {
      return res;
    });
  }

  Future<List<dynamic>> getReviewReasons(token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      base_url + "api/patient/reason",
      headers: headers,
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<ResGetMyInsurance> getPatientInsurance(
    BuildContext context,
    String token,
  ) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/patient/get-patient-insurance"),
            headers: headers)
        .then((res) {
      return ResGetMyInsurance.fromJson(res);
    });
  }

  Future<ResGetCard> getCard(
    BuildContext context,
    String token,
  ) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/stripe-card"), headers: headers)
        .then((res) {
      return ResGetCard.fromJson(res);
    });
  }

  Future<ResAddMember> setMemberPermission(
    BuildContext context,
    String token,
    ReqAddPermission model,
  ) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/add-family-members"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResAddMember.fromJson(res);
    });
  }

  Future<CommonRes> setSpecificMemberPermission(BuildContext context,
      String token, ReqAddUserPermissionModel model, String memberId) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(
            Uri.encodeFull(base_url +
                "api/patient/manage-family-member-permission/$memberId"),
            headers: headers,
            body: model.toJson())
        .then((res) {
      return CommonRes.fromJson(res);
    });
  }

  Future<ResUserPermissionModel> getUserPermission(
    BuildContext context,
    String token,
  ) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/patient/user-permission"),
            headers: headers)
        .then((res) {
      return ResUserPermissionModel.fromJson(res);
    });
  }

  Future<ResFamilyCircle> getFamilyCircle(
      BuildContext context, String token, ReqFamilyNetwork model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/patient/get-family-members"),
            headers: headers)
        .then((res) {
      return ResFamilyCircle.fromJson(res);
    });
  }

  Future<ResProviderSearch> searchProvider(
      BuildContext context, String token, Map<String, dynamic> search) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

//Todo: aaaaaaaaaa

    return _netUtil
        .getUri(Uri.https(base_u, "/api/get-providers", search),
            headers: headers)
        .then((res) {
      return ResProviderSearch.fromJson(res);
    });
  }

  Future<ResProviderGroup> getProviderGroups(
      BuildContext context, String token) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/get-provider-groups"),
            headers: headers)
        .then((res) {
      return ResProviderGroup.fromJson(res);
    });
  }

  Future<ResAddProvider> addProviderNetwork(
      BuildContext context, String token, ReqAddProvider model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    print(model.toMap());

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/add-edit-providers"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResAddProvider.fromJson(res);
    });
  }

  Future<ResMyProviderNetwork> getMyProviderNetwork(
      BuildContext context, String token) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/get-all-providers"),
            headers: headers)
        .then((res) {
      return ResMyProviderNetwork.fromJson(res);
    });
  }

  Future<ResRemoveProvider> removeProvider(
      BuildContext context, String token, ReqRemoveProvider model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/delete-providers"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResRemoveProvider.fromJson(res);
    });
  }

  Future<ResShareProvider> shareProvider(
      BuildContext context, String token, ReqShareProvider model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/share-single-user"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResShareProvider.fromJson(res);
    });
  }

  Future<ResShareProvider> shareAllProvider(
      BuildContext context, String token, ReqShareProvider model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/share-all-providers"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResShareProvider.fromJson(res);
    });
  }

  Future<ResSearchNumber> searchContact(
      BuildContext context, String token, ReqSearchNumber model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/search-contacts"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResSearchNumber.fromJson(res);
    });
  }

  Future<ResFamilyNetwork> getFamilyNetowrk(
      BuildContext context, String token, ReqFamilyNetwork model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/get-family-members"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResFamilyNetwork.fromJson(res);
    });
  }

  Future<ResRelationList> getRelations(
      BuildContext context, String token) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(Uri.encodeFull(base_url + "api/patient/user-relations"),
            headers: headers)
        .then((res) {
      return ResRelationList.fromJson(res);
    });
  }

  Future<dynamic> getLinkAccount(String token) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    try {
      final response = await _netUtil.get(
          Uri.encodeFull(base_url + 'api/link-accounts'),
          headers: headers);
      return response['response'];
    } catch (error) {}
  }

  Future<dynamic> switchAccount(String token, Map map) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    try {
      final response = await _netUtil.post(
          Uri.encodeFull(base_url + 'api/switch-account'),
          body: map,
          headers: headers);
      return response['response'];
    } catch (error) {}
  }

  Future<ResAddMember> addMember(
      BuildContext context, String token, ReqAddMember model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json"
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/add-family-members"),
            headers: headers, body: jsonEncode(model)) //model.toJson())
        .then((res) {
      return ResAddMember.fromJson(res);
    });
  }

  Future<ResMessageShare> shareMessage(
      BuildContext context, String token, ReqMessageShare model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/patient/send-single-user"),
            headers: headers, body: model.toMap())
        .then((res) {
      return ResMessageShare.fromJson(res);
    });
  }

  Future<CommonRes> setPin(
      BuildContext context, String token, ReqSetupPin model) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/create-pin"),
            headers: headers, body: model.toJson())
        .then((res) {
      return CommonRes.fromJson(res);
    });
  }

  Future<dynamic> checkTimeToStartVideo(
      BuildContext context, String token, Map locationMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/check/appintment/time-slot"),
            body: locationMap, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> startVideoCall(
      BuildContext context, String token, Map locationMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/video-appointment"),
            body: locationMap, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> stopVideoCall(
      BuildContext context, String token, Map locationMap) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .post(Uri.encodeFull(base_url + "api/video-appointment-stop"),
            body: locationMap, headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  // Future<dynamic> multipartPost(String url, String token,
  //     Map<String, String> fileMap, List<MultipartFile> files) {
  //   return _netUtil
  //       .multipartPost(
  //     url,
  //     token: token,
  //     fileMap: fileMap,
  //     files: files,
  //   )
  //       .then((res) {
  //     return res;
  //   });
  // }

  Future<CommonRes> addInsuranceDoc(
      String token, File frontImage, ReqAddInsurance model,
      {File backImage}) async {
    // try {
    // var formData = FormData.fromMap(model.toMap());
    // final fileName = frontImage.path.split('/').last;
    // var file = await MultipartFile.fromFile(frontImage.path,
    //     filename: fileName, contentType: MediaType("image", fileName));
    // formData.files.add(MapEntry('insuranceDocumentFront', file));
    List<MultipartFile> multipartList = [];

    var stream = ByteStream(DelegatingStream(frontImage.openRead()));
    var length = await frontImage.length();
    var multipartFile = MultipartFile(
        'insuranceDocumentFront', stream.cast(), length,
        filename: frontImage.path);
    multipartList.add(multipartFile);
    if (backImage != null) {
      var stream1 = ByteStream(DelegatingStream(backImage.openRead()));
      var length = await backImage.length();
      var multipartFile1 = MultipartFile(
          'insuranceDocumentBack', stream1.cast(), length,
          filename: backImage.path);
      multipartList.add(multipartFile1);

      // final fileName = backImage.path.split('/').last;
      // var file = await MultipartFile.fromFile(backImage.path,
      //     filename: fileName, contentType: MediaType("image", fileName));
      // formData.files.add(MapEntry('insuranceDocumentBack', file));
    }
    var map = model.toMap();

    return _netUtil
        .multipartPost(
      base_url + 'api/patient/add-patient-insurance',
      token: token,
      fileMap: model.toMap(),
      files: multipartList,
    )
        .then((res) {
      return CommonRes.fromJson(res);
    });
    //   final response = await ApiService().multipartPost(
    //     patient + apiAddInsuranceDoc,
    //     data: formData,
    //     options: Options(contentType: 'application/x-www-form-urlencoded'),
    //   );
    //   return CommonRes.fromJson(response.data);
    // } on DioError catch (error) {
    //   throw ErrorModel.fromJson(error.response.data);
    // }
  }
}

class NetworkUtil {
  static final NetworkUtil _instance = new NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  NetworkUtil.internal();

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> getUri(Uri url, {Map headers}) async {
    var responseJson;
    try {
      final response = await http.get(url, headers: headers);
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String) {
          showError(en["response"].toString());
        } else if (en["response"] is Map) {
          showError(en);
        } else {
          en["response"].map((m) => showError(m["msg"])).toList();
        }

        debugPrint(en["response"].toString(), wrapWidth: 1024);

        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      showError(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> get(url, {Map headers}) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String) {
          showError(en["response"].toString());
        } else if (en["response"] is Map) {
          showError(en);
        } else {
          en["response"].map((m) => showError(m["msg"])).toList();
        }

        debugPrint(en["response"].toString(), wrapWidth: 1024);

        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      showError(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: body, headers: headers, encoding: encoding);
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        ProgressDialogUtils.dismissProgressDialog();
        final en = json.decode(response.body);

        if (en["response"] is String) {
          showError(en["response"].toString());
        } else if (en["response"] is Map) {
          showError(en);
        } else {
          en["response"].map((m) => showError(m["msg"])).toList();
        }

        debugPrint(en["response"].toString(), wrapWidth: 1024);
        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      showError(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> postNotHandleError(String url,
      {Map headers, body, encoding}) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: body, headers: headers, encoding: encoding);
      final int statusCode = response.statusCode;

      // if (statusCode < 200 || statusCode > 400 || json == null) {
      //   final en = json.decode(response.body);

      //   await errorDialog(context, en);

      //   throw Exception(en);
      // }

      responseJson = response;

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      showError(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> multipartPost(
    String url, {
    String token,
    Map<String, String> fileMap,
    List<MultipartFile> files,
  }) async {
    var responseJson;
    try {
      Uri uri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['authorization'] = token;
      }

      request.fields.addAll(fileMap);

      // var stream = ByteStream(DelegatingStream(file.openRead()));
      // var length = await file.length();
      // var multipartFile =
      //     MultipartFile(key, stream.cast(), length, filename: file.path);
      request.files.addAll(files);

      var response = await request.send();
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      JsonDecoder _decoder = new JsonDecoder();

      String respStr = await response.stream.bytesToString();
      responseJson = _decoder.convert(respStr);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        if (responseJson["response"] is String) {
          showError(responseJson["response"].toString());
        } else if (responseJson["response"] is Map)
          showError(responseJson);
        else {
          responseJson["response"].map((m) => showError(m["msg"])).toList();
        }

        debugPrint(responseJson["response"].toString(), wrapWidth: 1024);
        throw Exception(responseJson);
      }
      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      showError(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }
    return responseJson;
  }

  void showError(String message) {
    Widgets.showErrorDialog(
        context: navigatorKey.currentState.overlay.context,
        description: message,
        onPressed: () {
          if (message == 'Unauthorized') {
            SharedPref().clearSharedPref();
            Navigator.of(navigatorKey.currentState.overlay.context)
                .pushNamedAndRemoveUntil(
                    Routes.loginRoute, (Route<dynamic> route) => false,
                    arguments: false);
          } else {
            Navigator.pop(navigatorKey.currentState.overlay.context);
          }
        });
  }
}
