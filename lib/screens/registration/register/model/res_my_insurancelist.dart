import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';

class ResMyInsuranceList {
  String status;
  List<Insurance> response;

  ResMyInsuranceList({this.status, this.response});

  ResMyInsuranceList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Insurance>[];
      json['data']['insurance'].forEach((v) {
        if (v['insuranceId'] != null) {
          response.add(Insurance.fromJson(v['insuranceId']));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
