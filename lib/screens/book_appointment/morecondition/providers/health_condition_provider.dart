import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/model/res_onsite_address_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/selection_health_issue_model.dart';

class HealthConditionProvider extends ChangeNotifier {
  List<int> healthConditions = [];
  Vitals vitalsData;
  PreferredPharmacy preferredPharmacyData;
  List<String> medicalDiagnosticsTestsData = [];
  List<String> medicalDocumentsData = [];
  List<String> medicalImagesData = [];
  String providerId = "";
  String officeId = "";
  List<BookedMedicalHistory> medicalHistoryData = [];
  List<String> medicationData = [];
  LatLng coordinatesDetails;
  ResponseDetailsDetails addressDetails;
  List<SelectionHealthIssueModel> listOfSelectedHealthIssues = [];
  int currentIndexOfIssue = 0;
  List<Problems> allHealthIssuesData = [];
  String providerAddress = "";

  void updateHealthConditions(List<int> list) {
    healthConditions = list;
    notifyListeners();
  }

  void updateVitals(Vitals vitals) {
    vitalsData = vitals;
    notifyListeners();
  }

  void updatePharmacy(PreferredPharmacy preferredPharmacy) {
    preferredPharmacyData = preferredPharmacy;
    notifyListeners();
  }

  void updateDiagnostics(List<String> list) {
    medicalDiagnosticsTestsData = list;
    notifyListeners();
  }

  void updateDocuments(List<String> list) {
    medicalDocumentsData = list;
    notifyListeners();
  }

  void updateImages(List<String> list) {
    medicalImagesData = list;
    notifyListeners();
  }

  void updateProviderId(String doctorId) {
    providerId = doctorId;
    notifyListeners();
  }

  void updateOfficeId(String offId) {
    officeId = offId;
    notifyListeners();
  }

  void updateMedicalHistory(List<BookedMedicalHistory> medicalHistory) {
    medicalHistoryData = medicalHistory;
    notifyListeners();
  }

  void updateMedicationData(List<String> list) {
    medicationData = list;
    notifyListeners();
  }

  void updateAddressData(ResponseDetailsDetails address) {
    addressDetails = address;
    notifyListeners();
  }

  void updateCoordinatesData(LatLng coordinates) {
    coordinatesDetails = coordinates;
    notifyListeners();
  }

  void updateListOfSelectedHealthIssues(List<SelectionHealthIssueModel> list) {
    listOfSelectedHealthIssues = list;
    notifyListeners();
  }

  void updateCurrentIndex(int pos) {
    currentIndexOfIssue = pos;
    notifyListeners();
  }

  void incrementCurrentIndex() {
    currentIndexOfIssue++;
    notifyListeners();
  }

  void decrementCurrentIndex() {
    if (currentIndexOfIssue > 0) {
      currentIndexOfIssue--;
    }
    notifyListeners();
  }

  void updateAllHealthIssuesData(List<Problems> list) {
    allHealthIssuesData = list;
    notifyListeners();
  }

  void updateProviderAddress(String address) {
    providerAddress = address;
    notifyListeners();
  }

  void resetHealthConditionProvider() {
    healthConditions = [];
    vitalsData = null;
    preferredPharmacyData = null;
    medicalDiagnosticsTestsData = [];
    medicalDocumentsData = [];
    medicalImagesData = [];
    providerId = "";
    officeId = "";
    medicalHistoryData = [];
    medicationData = [];
    coordinatesDetails = null;
    addressDetails = null;
    listOfSelectedHealthIssues = [];
    currentIndexOfIssue = 0;
    allHealthIssuesData = [];
    providerAddress = "";
  }
}
