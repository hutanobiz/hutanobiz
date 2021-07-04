import 'package:hutano/screens/payment/res_insurance_list.dart';

class ResGetMyInsurance {
  String status;
  List<Insurance> response;

  ResGetMyInsurance({this.status, this.response});

  ResGetMyInsurance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<Insurance>();
      json['response'].forEach((v) {
        response.add(new Insurance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
