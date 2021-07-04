import 'doctor_data_model.dart';

class ResProviderSearch {
  String status;
  Response response;

  ResProviderSearch({this.status, this.response});

  ResProviderSearch.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.toJson();
    }
    return data;
  }
}

class Response {
  List<DoctorData> doctorData;
  int count;
  int limit;
  Response({this.doctorData, this.count, this.limit});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['doctorData'] != null) {
      doctorData = <DoctorData>[];
      json['doctorData'].forEach((v) {
        doctorData.add(DoctorData.fromJson(v));
      });
    }
    count = json['count'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (doctorData != null) {
      data['doctorData'] = doctorData.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['limit'] = limit;
    return data;
  }
}
