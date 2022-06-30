class ResDiagnosticTestResult {
  String? status;
  List<Response>? response;

  ResDiagnosticTestResult({this.status, this.response});

  ResDiagnosticTestResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
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

class Response {
  String? sId;
  List<MedicalDocuments>? medicalDocuments;

  Response({this.sId, this.medicalDocuments});

  Response.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['medicalDocuments'] != null) {
      medicalDocuments = <MedicalDocuments>[];
      json['medicalDocuments'].forEach((v) {
        medicalDocuments!.add(new MedicalDocuments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.medicalDocuments != null) {
      data['medicalDocuments'] =
          this.medicalDocuments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalDocuments {
  String? medicalDocuments;
  String? type;
  String? name;
  String? date;
  String? size;
  String? sId;

  MedicalDocuments(
      {this.medicalDocuments,
      this.type,
      this.name,
      this.date,
      this.size,
      this.sId});

  MedicalDocuments.fromJson(Map<String, dynamic> json) {
    medicalDocuments = json['medicalDocuments'];
    type = json['type'];
    name = json['name'];
    date = json['date'];
    size = json['size'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicalDocuments'] = this.medicalDocuments;
    data['type'] = this.type;
    data['name'] = this.name;
    data['date'] = this.date;
    data['size'] = this.size;
    data['_id'] = this.sId;
    return data;
  }
}
