class ResDiagnositcTestModel {
  String status;
  List<DiagnosticTest> response;

  ResDiagnositcTestModel({this.status, this.response});

  ResDiagnositcTestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<DiagnosticTest>();
      json['response'].forEach((v) {
        response.add(new DiagnosticTest.fromJson(v));
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

class DiagnosticTest {
  String name;
  String sId;
  int iV;
  String createdAt;
  String updatedAt;
  bool isSelected = false;

  DiagnosticTest(
      {this.name, this.sId, this.iV, this.createdAt, this.updatedAt});

  DiagnosticTest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
