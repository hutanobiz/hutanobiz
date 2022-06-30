import 'package:hutano/screens/pharmacy/model/res_preferred_pharmacy_list.dart';

class PreferredPharmacyData {
  String? status;
  PreferredPharmacyList? response;

  PreferredPharmacyData({this.status, this.response});

  PreferredPharmacyData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new PreferredPharmacyList.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class PreferredPharmacyList {
  String? sId;
  List<Pharmacy>? preferredPharmacy;

  PreferredPharmacyList({this.sId, this.preferredPharmacy});

  PreferredPharmacyList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['preferredPharmacy'] != null) {
      preferredPharmacy = <Pharmacy>[];
      json['preferredPharmacy'].forEach((v) {
        preferredPharmacy!.add(new Pharmacy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.preferredPharmacy != null) {
      data['preferredPharmacy'] =
          this.preferredPharmacy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

