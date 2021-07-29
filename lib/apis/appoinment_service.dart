import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hutano/screens/medical_history/model/medical_history_disease.dart';
import 'package:hutano/screens/medical_history/model/req_create_appoinmet.dart';
import 'package:hutano/screens/medical_history/model/res_create_appoinment.dart';
import 'package:hutano/screens/medical_history/model/res_documentlist.dart';
import 'package:hutano/screens/medical_history/model/res_medicine.dart';
import 'package:hutano/screens/medical_history/model/res_symptoms.dart';
import 'api_constants.dart';
import 'api_service.dart';
import 'common_res.dart';
import 'error_model.dart';

class AppoinmentService {
  static final AppoinmentService _instance = AppoinmentService._internal();

  factory AppoinmentService() {
    return _instance;
  }

  AppoinmentService._internal();

  Future<ResDiseases> getMedicalHistory() async {
    try {
      final response = await ApiService().get(
        apiDisease,
      );
      return ResDiseases.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResSymptoms> getSymtoms(Map<String, int> model) async {
    try {
      final response = await ApiService().get(apiSymptoms, params: model);
      return ResSymptoms.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResMedicine> searchMedicine(String search) async {
    try {
      final response = await ApiService().post(
        apiMedicineList,
        data: {'search': search},
      );
      return ResMedicine.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResAppoinment> createAppounment(ReqAppointment request) async {
    try {
      final response =
          await ApiService().post(apiCreateAppoinment, data: request.toJson());
      return ResAppoinment.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<CommonRes> uploadDocument(
      File file, String type, String appointmentid) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      "medicalDocuments": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        // contentType,
      ),
      "appointmentId": appointmentid,
      "type": type
    });
    try {
      final response = await ApiService().multipartPost(
        apiUploadDocuments,
        data: formData,
      );
      return CommonRes.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }

  Future<ResDocumentList> documentListing(
      {String appoitmetid, int page, int limit}) async {
    try {
      final response = await ApiService().post(
        apiDocumentList,
        data: {
          'appointmentId': appoitmetid,
          'medicalImages': 1,
          'medicalDocuments': 1,
          'page': page,
          'limit': limit,
        },
      );
      return ResDocumentList.fromJson(response.data);
    } on DioError catch (error) {
      throw ErrorModel.fromJson(error.response.data);
    }
  }
}
