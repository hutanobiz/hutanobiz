import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hutano/models/user.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/widgets.dart';

class ApiBaseHelper {
  NetworkUtil _netUtil = new NetworkUtil();
  static const String _base_url = "http://206.189.137.24:8000/";

  Future<User> login(Map<String, String> loginData) {
    return _netUtil
        .post(_base_url + "auth/api/login", body: loginData)
        .then((res) {
      print(res.toString());

      return User.fromJson(res["response"]);
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
        Widgets.showToast(en["response"]);

        throw Exception(en["response"]);
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
        Widgets.showToast(en["response"]);

        throw Exception(en["response"]);
      }

      responseJson = _decoder.convert(response.body);
    } on SocketException {
      Widgets.showToast(Strings.noInternet);
      throw Exception(Strings.noInternet);
    }

    return responseJson;
  }
}
