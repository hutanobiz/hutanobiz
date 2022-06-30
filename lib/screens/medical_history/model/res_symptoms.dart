class ResSymptoms {
  List<Symptom> symptoms = [];
  ResSymptoms.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      if (json['response'] != null) {
        json['response'].forEach((element) {
          symptoms.add(Symptom.fromJson(element));
        });
      }
    }
  }
}

class Symptom {
  String? bodyPart;
  List<String> pains = [];
  Symptom.fromJson(Map<String, dynamic> json) {
    bodyPart = json['bodyPart'];
    json['painType'].forEach((element) {
      pains.add(element);
    });
  }
}
