import 'package:flutter/material.dart';

import '../model/medical_history_disease.dart';
import '../model/res_medical_images_upload.dart';
import '../model/res_symptoms.dart';

class SymptomsInfoProvider extends ChangeNotifier {
  List<Disease> diseases = [];
  List<Symptom> symptoms = [];

  /// pain symptoms = 0 , generalied syptoms = 1
  int symtomsType = 0;

  /// back = 0, front = 1, side = 2, allover = 3
  int bodySide = 1;

  //Female =1 , Male=2
  int bodyType = 1;

  ///pain details
  String bodypart = "";
  String bodyPartPain = "";
  String timeForpain = "";
  int timeForpainNumber;
  int painIntensity;
  String painCondition = "";

  ///general info
  bool firestTimeIssue;
  bool hospitalizedBefore;
  String hositalizedTime;
  int hositalizedTimeNumber;
  bool diagnosticTest;
  List<String> diagnosticTests = [];

  String doctorId;
  String userId;

  ///medicine info
  bool isTakingMedicine;

  List<String> medicines = [];
  List<String> medicinDose = [];
  List<String> medcineTime = [];

  List<MedicalImages> medicalImages = [];

  String appoinmentId = "";

  // To set body part selection 
  Offset touchPosition;
  String bodyPart;
  String selectedBodyPart;

  // FRONT-1,BACK-2,SIDE-3,ALLOVER-4
  int getBodySide() {
    switch (bodySide) {
      case 0: //back
        return 2;
      case 1: //front
        return 1;
      case 2: //side
        return 3;
      case 3: //allover
        return 4;
    }
    return 1;
  }

  void setMedicalImages(List<MedicalImages> updateImages) {
    medicalImages = updateImages;
  }

  void setAppoinmentId(String appoinmentId) {
    this.appoinmentId = appoinmentId;
    notifyListeners();
  }

  void setAppoinmentData(String doctorId, String userId) {
    this.doctorId = doctorId;
    this.userId = userId;
  }

  void setBodyPartOffset(localPosition, pathname, selectedBodyPart) {
    touchPosition = localPosition;
    bodyPart = pathname;
    selectedBodyPart = selectedBodyPart;
  }

  void setMedicineDetails(
      {bool isTakingMedicine,
      List<String> medicines,
      List<String> medicinDose,
      List<String> medcineTime}) {
    this.isTakingMedicine = isTakingMedicine;
    this.medicines = medicines;
    this.medicinDose = medicinDose;
    this.medcineTime = medcineTime;
  }

  void setDiasesList(List<Disease> diseases) {
    this.diseases = diseases;
    notifyListeners();
  }

  void setSymptomsList(List<Symptom> symptoms) {
    this.symptoms = symptoms;
    notifyListeners();
  }

  List<String> getSymptomsByBodyPart(String bodypart) {
    if (symptoms.isEmpty) return [];
    return symptoms
            .firstWhere((element) => element.bodyPart == bodypart,
                orElse: () => null)
            ?.pains ??
        [];
  }

  void setSypmtomsType(int type) {
    symtomsType = type;
    notifyListeners();
  }

  void setBodySide(int side) {
    bodySide = side;
    notifyListeners();
  }

  void setBodyType(int type) {
    bodyType = type;
    notifyListeners();
  }

  void setPainDetails(
      {String bodypart,
      String bodyPartPain,
      String timeForpain,
      int timeForpainNumber,
      int painIntensity,
      String painCondition}) {
    this.bodypart = bodypart;
    this.bodyPartPain = bodyPartPain;
    this.timeForpain = timeForpain;
    this.timeForpainNumber = timeForpainNumber;
    this.painIntensity = painIntensity;
    this.painCondition = painCondition;
  }

  void setGeneralSysptomDetails({String bodypart, String bodyPartPain}) {
    this.bodypart = bodypart;
    this.bodyPartPain = bodyPartPain;
  }

  void setGeneralPainInfo(
      {bool firestTimeIssue,
      bool hospitalizedBefore,
      String hositalizedTime,
      int hositalizedTimeNumber,
      bool diagnosticTest,
      List<String> diagnosticTests}) {
    this.firestTimeIssue = firestTimeIssue;
    this.hospitalizedBefore = hospitalizedBefore;
    this.hositalizedTime = hositalizedTime;
    this.hositalizedTimeNumber = hositalizedTimeNumber;
    this.diagnosticTest = diagnosticTest;
    this.diagnosticTests = diagnosticTests;
  }
}
