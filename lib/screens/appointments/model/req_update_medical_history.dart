class ReqUpdateMedicalHistory {
  String? medicalHistoryId;
  String? name;
  String? year;
  String? month;

  ReqUpdateMedicalHistory(
      {this.medicalHistoryId, this.name, this.year, this.month});

  ReqUpdateMedicalHistory.fromJson(Map<String, dynamic> json) {
    medicalHistoryId = json['medicalHistoryId'];
    name = json['name'];
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalHistoryId'] = this.medicalHistoryId;
    data['name'] = this.name;
    data['year'] = this.year;
    data['month'] = this.month;
    return data;
  }
}
