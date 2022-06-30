import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart'
    as DocImg;
import 'package:hutano/screens/book_appointment/diagnosis/model/res_diagnostic_test_model.dart';
import 'package:hutano/screens/book_appointment/model/allergy.dart';
import 'package:hutano/screens/book_appointment/model/res_onsite_address_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/selection_health_issue_model.dart';
import 'package:hutano/screens/book_appointment/vitals/model/social_history.dart';
import 'package:hutano/screens/medical_history/model/req_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/screens/pharmacy/model/res_preferred_pharmacy_list.dart';

class HealthConditionProvider extends ChangeNotifier {
  List<int> healthConditions = [];
  Vitals? vitalsData;
  PreferredPharmacy? preferredPharmacyData;
  List<DiagnosticTest> medicalDiagnosticsTestsModelData = [];
  List<DocImg.MedicalDocuments> medicalDocumentsData = [];
  List<DocImg.MedicalImages> medicalImagesData = [];
  String providerId = "";
  String? officeId = "";
  List<BookedMedicalHistory> medicalHistoryData = [];
  List<String> medicationData = [];
  LatLng? coordinatesDetails;
  ResponseDetailsDetails? addressDetails;
  List<SelectionHealthIssueModel> listOfSelectedHealthIssues = [];
  int currentIndexOfIssue = 0;
  List<Problems> allHealthIssuesData = [];
  String providerAddress = "";
  List<Medications> medicationModelData = [];
  SocialHistory? socialHistory;
  List<Allergy>? allergies = [];
  List<ReqMedicationDetail?> medicines = [];
  Pharmacy? prefPharmacy;
  dynamic previousAppointment;

  void updateHealthConditions(List<int> list) {
    healthConditions = list;
    notifyListeners();
  }

  updatePreviousAppointment(appointment) {
    previousAppointment = appointment;
    notifyListeners();
  }

  void setMedicineDetails({
    ReqMedicationDetail? medicine,
  }) {
    medicines.add(medicine);
    notifyListeners();
  }

  void updateVitals(Vitals vitals) {
    vitalsData = vitals;
    notifyListeners();
  }

  void updatePharmacy(PreferredPharmacy preferredPharmacy, Pharmacy? pharmacy) {
    preferredPharmacyData = preferredPharmacy;
    prefPharmacy = pharmacy;
    notifyListeners();
  }

  void updateSocialHistory(SocialHistory sociaHistory) {
    socialHistory = sociaHistory;
    notifyListeners();
  }

  void updateDiagnosticsModel(List<DiagnosticTest> list) {
    medicalDiagnosticsTestsModelData = list;
    notifyListeners();
  }

  void updateDocuments(List<DocImg.MedicalDocuments> list) {
    medicalDocumentsData = list;
    notifyListeners();
  }

  void updateImages(List<DocImg.MedicalImages> list) {
    medicalImagesData = list;
    notifyListeners();
  }

  void updateProviderId(String doctorId) {
    providerId = doctorId;
    notifyListeners();
  }

  void updateOfficeId(String? offId) {
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

  void updateMedicationModelData(List<Medications> list) {
    medicationModelData = list;
    notifyListeners();
  }

  void updateAllergies(List<Allergy>? allergiesData) {
    allergies = allergiesData;
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
    medicalDiagnosticsTestsModelData = [];
    medicalDocumentsData = [];
    medicalImagesData = [];
    providerId = "";
    officeId = "";
    medicalHistoryData = [];
    medicationData = [];
    medicationModelData = [];
    coordinatesDetails = null;
    addressDetails = null;
    listOfSelectedHealthIssues = [];
    currentIndexOfIssue = 0;
    allHealthIssuesData = [];
    providerAddress = "";
    medicines = [];
    prefPharmacy = null;
    previousAppointment = null;
    // socialHistory = null;
    // allergies = [];
  }
}
