import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hutano/models/user.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/widgets.dart';

class ApiBaseHelper {
  NetworkUtil _netUtil = new NetworkUtil();
  static const String _base_url = "http://139.59.40.62:5300/";

  Future<User> login(Map<String, String> loginData) {
    return _netUtil
        .post(_base_url + "auth/api/login", body: loginData)
        .then((res) {
      print(res.toString());

      return User.fromJson(res["response"]);
    });
  }

  Future<dynamic> register(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "auth/api/register", body: map)
        .then((res) {
      print(res.toString());

      return (res["response"]);
    });
  }

  Future<dynamic> resetPassword(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "auth/api/reset-password", body: map)
        .then((res) {
      print(res.toString());

      return (res["response"]);
    });
  }

  Future<List<dynamic>> getProfessionalTitle() {
    return _netUtil.get(_base_url + "api/professional-titles").then((res) {
      print(res.toString());

      List responseJson = res["response"];

      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getProfessionalSpecility(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "api/provider/specialties", body: map)
        .then((res) {
      print(res["response"]);
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<List<dynamic>> getStates() {
    return _netUtil.get(_base_url + "api/states").then((res) {
      print(res.toString());
      List responseJson = res["response"];
      return responseJson.map((m) => m).toList();
    });
  }

  Future<dynamic> getProviderList(Map<String, String> map) {
    return _netUtil
        .post(_base_url + "api/patient/provider-search", body: map)
        .then((res) {
      print(res);
      return res;
    });
  }
}

class NetworkUtil {
  static final NetworkUtil _instance = new NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  NetworkUtil.internal();

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers}) async {
    var responseJson;
    try {
      final response = await http.get(url, headers: headers);
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String)
          Widgets.showToast(en["response"]);
        else if (en["response"] is Map)
          Widgets.showToast(en);
        else {
          en["response"].map((m) => Widgets.showToast(m["msg"])).toList();
        }

        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);
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

      if (statusCode < 200 || statusCode > 400 || json == null) {
        final en = json.decode(response.body);

        if (en["response"] is String)
          Widgets.showToast(en["response"]);
        else if (en["response"] is Map)
          Widgets.showToast(en);
        else {
          en["response"].map((m) => Widgets.showToast(m["msg"])).toList();
        }

        throw Exception(en);
      }

      responseJson = _decoder.convert(response.body);
    } on SocketException {
      Widgets.showToast(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }
}
