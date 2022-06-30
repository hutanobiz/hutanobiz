import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/app_config.dart';

class GoogleService {
  late Dio _dio;
  String tag = "Google API :";
  CancelToken? _cancelToken;

  GoogleService() {
    _dio = initApiServiceDio();
  }

  Dio initApiServiceDio() {
    _cancelToken = CancelToken();
    final baseOption = BaseOptions(
      connectTimeout: 10 * 10000,
      receiveTimeout: 10 * 10000,
      baseUrl: 'https://maps.googleapis.com/maps/api/place/',
      contentType: 'application/json',
    );
    final mDio = Dio(baseOption);

    final mInterceptorsWrapper = InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint("$tag queryParameters ${options.queryParameters.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag headers ${options.headers.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag ${options.baseUrl.toString() + options.path}",
            wrapWidth: 1024);
        debugPrint("$tag ${options.data.toString()}", wrapWidth: 1024);
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        debugPrint("Code  ${response.statusCode.toString()}", wrapWidth: 1024);
        debugPrint("Response ${response.toString()}", wrapWidth: 1024);
        return handler.next(response);
      },
      onError: (e, handler) async {
        debugPrint("$tag ${e.error.toString()}", wrapWidth: 1024);
        debugPrint("$tag ${e.response.toString()}", wrapWidth: 1024);
        return handler.next(e);
      },
    );
    mDio.interceptors.add(mInterceptorsWrapper);
    return mDio;
  }

  void cancelRequests({CancelToken? cancelToken}) {
    cancelToken == null
        ? _cancelToken!.cancel('Cancelled')
        : cancelToken.cancel();
  }

  Future<Response> get(
    String endUrl, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var isConnected = await checkInternet();
      if (!isConnected) {
        return Future.error("Internet not connected");
      }
      params!['key'] = googleApiKey;
      return await (_dio.get(
        endUrl,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
      ));
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
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
}
