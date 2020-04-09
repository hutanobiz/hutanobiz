import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/models/schedule.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/widgets.dart';

class ApiBaseHelper {
  NetworkUtil _netUtil = new NetworkUtil();
  static const String _base_url = "http://139.59.40.62:5300/";

  Future<dynamic> login(Map loginData) {
    return _netUtil
        .post(_base_url + "auth/api/login", body: loginData)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> register(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "auth/api/register", body: map)
        .then((res) {
      return (res["response"]);
    });
  }

  Future<dynamic> resetPassword(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "auth/api/reset-password", body: map)
        .then((res) {
      return (res["response"]);
    });
  }

  Future<List<dynamic>> getProfessionalTitle() {
    return _netUtil.get(_base_url + "api/professional-titles").then((res) {
      List responseJson = res["response"];

      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getProfessionalSpecility(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "api/provider/specialties", body: map)
        .then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getStates() {
    return _netUtil.get(_base_url + "api/states").then((res) {
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<dynamic> getProviderList(Map map) {
    return _netUtil
        .post(_base_url + "api/patient/provider-search", body: map)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getSpecialityProviderList(String query) {
    return _netUtil
        .get(Uri.encodeFull(
            _base_url + "api/specialty-providers?specialtyId=$query"))
        .then((res) {
      return res;
    });
  }

  Future<List<Schedule>> getScheduleList(String providerId, Map doctorData) {
    return _netUtil
        .post(Uri.encodeFull(_base_url + "api/provider/schedule/$providerId"),
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
        .post(_base_url + "api/patient/appointment-booking",
            body: appointmentData, headers: headers)
        .then((res) {
      return res;
    });
  }

  Future<dynamic> getServiceProviderList(String query) {
    return _netUtil
        .get(Uri.encodeFull(
            _base_url + "api/service-providers?serviceId=$query"))
        .then((res) {
      return res;
    });
  }

  Future<dynamic> searchDoctors(String string) {
    return _netUtil
        .get(Uri.encodeFull(
            _base_url + "api/patient/name/specialty/service?search=$string"))
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> appointmentRequests(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(_base_url + "api/patient/user-notification", headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<List<dynamic>> userAppointments(String token) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };

    return _netUtil
        .get(_base_url + "api/patient/user-schedule-appointmnet",
            headers: headers)
        .then((res) {
      return res["response"];
    });
  }

  Future<dynamic> getProviderProfile(String token, String providerId) {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    };
    return _netUtil
        .get(
      Uri.encodeFull(_base_url + "api/patient/doctor-details?id=$providerId"),
      headers: headers,
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
}
