class ResDiagnositcTestModel {
  String? status;
  List<DiagnosticTest>? response;

  ResDiagnositcTestModel({this.status, this.response});

  ResDiagnositcTestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <DiagnosticTest>[];
      json['response'].forEach((v) {
        response!.add(new DiagnosticTest.fromJson(v));
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

class DiagnosticTest {
  String? name;
  String? image;
  String? sId;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? type;
  String? date;
  bool isSelected = false;

  DiagnosticTest(
      {this.name,
      this.image,
      this.sId,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.type,
      this.date});

  DiagnosticTest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = image;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
