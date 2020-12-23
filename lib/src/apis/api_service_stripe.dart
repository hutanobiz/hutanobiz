import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/apis/error_model_stripe.dart';
import 'package:hutano/src/ui/registration_steps/payment/model/req_create_card_token.dart';
import 'package:hutano/src/ui/registration_steps/payment/model/res_create_card_token.dart';

import 'api_constants.dart';

class ApiServiceStripe {
  Dio _dio;
  String tag = "API call :";
  CancelToken _cancelToken;

  ApiServiceStripe() {
    _dio = initApiServiceDio();
  }

  Dio initApiServiceDio() {
    _cancelToken = CancelToken();
    final baseOption = BaseOptions(
      connectTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000,
      contentType: 'application/x-www-form-urlencoded',
      headers: {
        'authorization': "Bearer ${kstripePublishKey}",
      },
    );
    final mDio = Dio(baseOption);

    final mInterceptorsWrapper = InterceptorsWrapper(
      onRequest: (options) async {
        debugPrint("$tag queryParameters ${options.queryParameters.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag headers ${options.headers.toString()}",
            wrapWidth: 1024);
        debugPrint("$tag ${options.path}", wrapWidth: 1024);
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

  Future<ResCreateCardToken> sendCardDetails(ReqCreateCardToken model) async {
    try {
      final response = await post(
        apiGenerateCardToken,
        data: model.toJson(),
      );
      return ResCreateCardToken.fromJsonMap(response.data);
    } on DioError catch (error) {
      debugPrint("$tag ${error.response.toString()}");
      throw ErrorModelStripe.fromJson(error.response.data);
    }
  }

  Future<Response> post(
    String endUrl, {
    Map<String, dynamic> data,
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      return await (_dio.post(
        endUrl,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
      ));
    } on DioError {
      rethrow;
    }
  }
}
