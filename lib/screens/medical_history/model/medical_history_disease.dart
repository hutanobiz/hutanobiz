import 'package:flutter/material.dart';

class Disease {
  String? disease;
  bool isChecked;
  Disease({required this.disease, required this.isChecked});
}

class ResDiseases {
  List<Disease> disease = [];

  ResDiseases.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      if (json['response'] != null) {
        json['response'].forEach((element) {
          disease.add(Disease(disease: element['name'], isChecked: false));
        });
      }
    }
  }
}
