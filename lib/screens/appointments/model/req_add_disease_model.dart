class ReqAddDiseaseModel {
  String? sId;
  String? year;
  String? month;
  String? name;
  String? medicalHistoryId;

  ReqAddDiseaseModel({this.sId, this.year, this.month, this.name,this.medicalHistoryId});

  ReqAddDiseaseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    year = json['year'];
    month = json['month'];
    month = json['name'];
    medicalHistoryId = json['medicalHistoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['year'] = this.year;
    data['month'] = this.month;
    data['name'] = this.name;
    data['medicalHistoryId'] = this.medicalHistoryId;
    return data;
  }
}
