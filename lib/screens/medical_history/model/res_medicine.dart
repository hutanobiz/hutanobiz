class ResMedicine {
  List<Medicine> medicines = [];
  ResMedicine.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      if (json['data'] != null) {
        json['data'].forEach((element) {
          medicines.add(Medicine.fromJson(element));
        });
      }
    }
  }
}

class Medicine {
  String drugName;
  List<String> dosage = [];
  Medicine.fromJson(Map<String, dynamic> json) {
    drugName = json['drugName'];
    json['dosage'].forEach((element) {
      dosage.add(element);
    });
  }
}
