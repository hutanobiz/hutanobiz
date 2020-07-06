import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/widgets.dart';

class ApiBaseHelper {
  NetworkUtil _netUtil = new NetworkUtil();
  static const String base_url = "http://139.59.40.62:5300/";
  static const String imageUrl = base_url + "uploads/";

  Future<dynamic> login(Map loginData) {
    return _netUtil
        .post(base_url + "auth/api/login", body: loginData)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> register(Map<String, String> map) {
    return _netUtil.post(base_url + "auth/api/register", body: map).then((res) {
      return (res["response"]);
    });
  }

  Future<dynamic> resetPassword(Map<String, String> map) {
    return _netUtil
        .post(base_url + "auth/api/reset-password", body: map)
        .then((res) {
      return (res["response"]);
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

  Future<List<dynamic>> getProfessionalTitle() {
    return _netUtil.get(base_url + "api/professional-titles").then((res) {
      List responseJson = res["response"];

      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getProfessionalSpecility(Map<String, String> map) {
    return _netUtil
        .post(base_url + "api/provider/specialties", body: map)
        .then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getStates() {
    return _netUtil.get(base_url + "api/states").then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<dynamic> getProviderList(Map map) {
    return _netUtil
        .post(base_url + "api/patient/provider-search", body: map)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getSpecialityProviderList(String query) {
    return _netUtil
        .get(Uri.encodeFull(
            base_url + "api/specialty-providers?specialtyId=$query"))
        .then((res) {
      return res;
    });
  }

  Future<List<Schedule>> getScheduleList(String providerId, Map doctorData) {
    return _netUtil
        .post(Uri.encodeFull(base_url + "api/provider/schedule/$providerId"),
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

  Future<dynamic> getServiceProviderList(String query) {
    return _netUtil
        .get(
            Uri.encodeFull(base_url + "api/service-providers?serviceId=$query"))
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

  Future<dynamic> appointmentRequests(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(base_url + "api/patient/user-notification", headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> userAppointments(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(base_url + "api/patient/user-schedule-appointmnet",
            headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getProviderProfile(String providerId) {
    return _netUtil
        .get(
      Uri.encodeFull(base_url + "api/patient/doctor-details?id=$providerId"),
    )
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getAppointmentDetails(String token, String providerId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(
          base_url + "api/patient/doctor-appointment-details?id=$providerId"),
      headers: headers,
    )
        .then((res) {
      return res["response"];
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

  Future<dynamic> cancelAppointment(String token, Map rateDoctorData) {
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

  Future<List<MedicalHistory>> getDiseases() {
    return _netUtil.get(base_url + "api/disease").then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => MedicalHistory.fromJson(m)).toList();
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

  Future<dynamic> multipartPost(String url, String token, String key,
      Map<String, String> fileMap, File file) {
    return _netUtil
        .multipartPost(
      url,
      token: token,
      fileMap: fileMap,
      file: file,
      key: key,
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

  Future<List<dynamic>> getMyDoctors(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(
      base_url + "api/patient/my-doctors",
      headers: headers,
    )
        .then((res) {
      return res["response"];
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
}

class NetworkUtil {
  static final NetworkUtil _instance = new NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  NetworkUtil.internal();

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(url, {Map headers}) async {
    var responseJson;
    try {
      final response = await http.get(url, headers: headers);
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String)
          Widgets.showToast(en["response"]);
        else if (en["response"] is Map)
          Widgets.showToast(en);
        else {
          en["response"].map((m) => Widgets.showToast(m["msg"])).toList();
        }

        debugPrint(en["response"].toString(), wrapWidth: 1024);

        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      Widgets.showToast(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    var responseJson;
    try {
      final response = await http.post(url,
          body: body, headers: headers, encoding: encoding);
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String)
          Widgets.showToast(en["response"]);
        else if (en["response"] is Map)
          Widgets.showToast(en);
        else {
          en["response"].map((m) => Widgets.showToast(m["msg"])).toList();
        }

        debugPrint(en["response"].toString(), wrapWidth: 1024);
        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      Widgets.showToast(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }

  Future<dynamic> multipartPost(String url,
      {String token,
      Map<String, String> fileMap,
      File file,
      String key}) async {
    var responseJson;
    try {
      Uri uri = Uri.parse(url);
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['authorization'] = token;
      }

      request.fields.addAll(fileMap);

      var stream = ByteStream(DelegatingStream(file.openRead()));
      var length = await file.length();
      var multipartFile =
          MultipartFile(key, stream.cast(), length, filename: file.path);
      request.files.add(multipartFile);

      var response = await request.send();
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      JsonDecoder _decoder = new JsonDecoder();

      String respStr = await response.stream.bytesToString();
      var responseJson = _decoder.convert(respStr);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        if (responseJson["response"] is String)
          Widgets.showToast(responseJson["response"]);
        else if (responseJson["response"] is Map)
          Widgets.showToast(responseJson);
        else {
          responseJson["response"]
              .map((m) => Widgets.showToast(m["msg"]))
              .toList();
        }

        debugPrint(responseJson["response"].toString(), wrapWidth: 1024);
        throw Exception(responseJson);
      }

      debugPrint(responseJson.toString(), wrapWidth: 1024);
    } on SocketException {
      Widgets.showToast(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }
}
