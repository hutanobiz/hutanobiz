import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/app_config.dart';
import '../utils/preference_key.dart';
import '../utils/preference_utils.dart';

class ApiService {
  Dio _dio;
  String tag = "API call :";
  CancelToken _cancelToken;

  ApiService() {
    _dio = initApiServiceDio();
  }

  Dio initApiServiceDio() {
    _cancelToken = CancelToken();
    final baseOption = BaseOptions(
      connectTimeout: 10 * 10000,
      receiveTimeout: 10 * 10000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization': "Bearer ${getString(PreferenceKey.tokens)}",
      },
    );
    final mDio = Dio(baseOption);

    final mInterceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        debugPrint("$tag queryParameters ${options.queryParameters.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag headers ${options.headers.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag ${options.baseUrl.toString() + options.path}",
            wrapWidth: 1024);
        debugPrint("$tag ${options.data.toString()}", wrapWidth: 1024);
        return options;
      },
      onResponse: (response) async {
        debugPrint("Code  ${response.statusCode.toString()}", wrapWidth: 1024);
        debugPrint("Response ${response.toString()}", wrapWidth: 1024);
        return response;
      },
      onError: (e) async {
        debugPrint("$tag ${e.error.toString()}", wrapWidth: 1024);
        debugPrint("$tag ${e.response.toString()}", wrapWidth: 1024);
        return e;
      },
    );
    mDio.interceptors.add(mInterceptorsWrapper);
    return mDio;
  }

  void cancelRequests({CancelToken cancelToken}) {
    cancelToken == null
        ? _cancelToken.cancel('Cancelled')
        : cancelToken.cancel();
  }

  Future<Response> get(
    String endUrl, {
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var isConnected = await checkInternet();
      if (!isConnected) {
        return Future.error("Internet not connected");
      }
      return await (_dio.get(
        endUrl,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
      ));
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        return Future.error("Poor internet connection");
      }
      rethrow;
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<Response> post(
    String endUrl, {
    Map<String, dynamic> data,
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var isConnected = await checkInternet();
      if (!isConnected) {
        return Future.error("Internet not connected");
      }
      return await (_dio.post(
        endUrl,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
      ));
    } on DioError catch (e){
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        return Future.error("Poor internet connection");
      }
      rethrow;
    }
  }

  Future<Response> multipartPost(
    String endUrl, {
    FormData data,
    CancelToken cancelToken,
    Options options,
  }) async {
    try {
      return await (_dio.post(
        endUrl,
        data: data,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
      ));
    } on DioError {
      rethrow;
    }
  }
}
