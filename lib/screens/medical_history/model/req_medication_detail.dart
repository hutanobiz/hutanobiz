class ReqMedicationDetail {
  String dose;
  String name;
  String frequency;
  String prescriptionId;

  ReqMedicationDetail(
      {this.dose, this.name, this.frequency, this.prescriptionId});

  ReqMedicationDetail.fromJson(Map<String, dynamic> json) {
    dose = json['dose'];
    name = json['name'];
    frequency = json['frequency'];
    prescriptionId = json['prescriptionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dose'] = this.dose;
    data['name'] = this.name;
    data['frequency'] = this.frequency;
    data['prescriptionId'] = this.prescriptionId;
    return data;
  }
}
