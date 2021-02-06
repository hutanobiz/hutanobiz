class MedicalHistory {
  String name;
  int status;
  String sId;
  int iV;
  String createdAt;
  String updatedAt;
  bool isSelected = false;

  MedicalHistory(
      {this.name,
      this.status,
      this.sId,
      this.iV,
      this.createdAt,
      this.updatedAt});

  MedicalHistory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
