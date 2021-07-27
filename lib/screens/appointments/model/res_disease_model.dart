class ResDiseaseModel {
  String status;
  List<Disease> response;

  ResDiseaseModel({this.status, this.response});

  ResDiseaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<Disease>();
      json['response'].forEach((v) {
        response.add(new Disease.fromJson(v));
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

class Disease {
  String name;
  int status;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  Disease(
      {this.name,
        this.status,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Disease.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
