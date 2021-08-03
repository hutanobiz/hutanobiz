class ResGetMedicationDetail {
  String status;
  Response response;

  ResGetMedicationDetail({this.status, this.response});

  ResGetMedicationDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String sId;
  List<Medications> medications;

  Response({this.sId, this.medications});

  Response.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['medications'] != null) {
      medications = new List<Medications>();
      json['medications'].forEach((v) {
        medications.add(new Medications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.medications != null) {
      data['medications'] = this.medications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medications {
  String prescriptionId;
  String name;
  String dose;
  String frequency;
  String sId;
  bool isSelected;

  Medications(
      {this.prescriptionId, this.name, this.dose, this.frequency, this.sId});

  Medications.fromJson(Map<String, dynamic> json) {
    prescriptionId = json['prescriptionId'];
    name = json['name'];
    dose = json['dose'];
    frequency = json['frequency'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prescriptionId'] = this.prescriptionId;
    data['name'] = this.name;
    data['dose'] = this.dose;
    data['frequency'] = this.frequency;
    data['_id'] = this.sId;
    return data;
  }
}
