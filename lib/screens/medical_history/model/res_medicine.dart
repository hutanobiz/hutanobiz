class ResMedicine {
  String? status;
  List<Medicine>? response;

  ResMedicine({this.status, this.response});

  ResMedicine.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Medicine>[];
      json['response'].forEach((v) {
        response!.add(new Medicine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicine {
  List<String>? dose;
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Medicine(
      {this.dose,
      this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Medicine.fromJson(Map<String, dynamic> json) {
    dose = json['dose'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dose'] = this.dose;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
