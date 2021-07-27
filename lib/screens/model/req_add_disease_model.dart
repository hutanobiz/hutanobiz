class ReqAddDiseaseModel {
  String medicalHistory;
  String year;
  String month;

  ReqAddDiseaseModel({this.medicalHistory, this.year, this.month});

  ReqAddDiseaseModel.fromJson(Map<String, dynamic> json) {
    medicalHistory = json['medicalHistory'];
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalHistory'] = this.medicalHistory;
    data['year'] = this.year;
    data['month'] = this.month;
    return data;
  }
}
