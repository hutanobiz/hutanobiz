class ResInsuranceList {
  String? status;
  List<Insurance>? response;

  ResInsuranceList({this.status, this.response});

  ResInsuranceList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Insurance>[];
      json['response'].forEach((v) {
        response!.add(Insurance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Insurance {
  String? title;
  String? image;
  int? status;
  String? sId;
  bool isSelected = false;

  Insurance({this.title, this.image, this.status, this.sId});

  Insurance.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      title = json['title'];
      image = json['image'];
      status = json['status'];
      sId = json['_id'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['status'] = status;
    data['_id'] = sId;
    return data;
  }
}
