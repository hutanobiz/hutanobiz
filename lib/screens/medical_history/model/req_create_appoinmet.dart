class ReqAppointment {
  List<String>? medicalHistory;
  List<String>? drugnames;
  List<String>? dosage;
  List<String>? dosageTime;
  String? fromTime;
  String? date;
  String? doctorId;
  String? userId;
  List<String>? questions;
  List<String>? answers;
  int? bodySide;
  int? bodyType;
  ReqAppointment(
      {this.medicalHistory,
      this.drugnames,
      this.dosage,
      this.dosageTime,
      this.fromTime,
      this.doctorId,
      this.userId,
      this.questions,
      this.answers,
      this.bodySide,
      this.bodyType});

  Map<String, dynamic> toJson() {
    Map json = <String, dynamic>{};
    json['medicalHistory'] = medicalHistory;
    List items = <Map<String, dynamic>>[];
    for (var i = 0; i < drugnames!.length; i++) {
      Map data = <String, dynamic>{};
      data['drugName'] = drugnames![i];
      data['dosage'] = dosage![i];
      data['frequency'] = dosageTime![i];
      items.add(data);
    }
    json['drugInfo'] = items;
    json['doctorId'] = doctorId;
    json['userId'] = userId;
    json['bodySide'] = bodySide;
    json['bodyType'] = bodyType;
    List qna = <Map<String, dynamic>>[];
    for (var i = 0; i < questions!.length; i++) {
      Map data = <String, dynamic>{};
      data['question'] = questions![i];
      data['answer'] = answers![i];
      qna.add(data);
    }
    json['generalInformation'] = qna;

    json['fromTime'] = "10:00:00";
    json["date"] = "10/14/2020";
    json['services'] = [
      {
        "serviceId": "5f040f113dafc1327e7de74f",
        "subServiceId": "5f040f113dafc1327e7de750"
      }
    ];
    return json as Map<String, dynamic>;
  }
}
