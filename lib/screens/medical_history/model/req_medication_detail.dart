class ReqMedicationDetail {
  String anyMedication;
  List<String> addMedication;
  List<String> doseOfMedicine;
  List<String> frequencyOfDosage;

  ReqMedicationDetail(
      {this.anyMedication,
      this.addMedication,
      this.doseOfMedicine,
      this.frequencyOfDosage});

  ReqMedicationDetail.fromJson(Map<String, dynamic> json) {
    anyMedication = json['anyMedication'];
    addMedication = json['addMedication'].cast<String>();
    doseOfMedicine = json['doseOfMedicine'].cast<String>();
    frequencyOfDosage = json['frequencyOfDosage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anyMedication'] = this.anyMedication;
    data['addMedication'] = this.addMedication;
    data['doseOfMedicine'] = this.doseOfMedicine;
    data['frequencyOfDosage'] = this.frequencyOfDosage;
    return data;
  }
}
