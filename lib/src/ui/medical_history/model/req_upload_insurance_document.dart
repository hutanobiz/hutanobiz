class ReqUploadInsuranceDocuments {
  final String insuranceId;
  final String appointmentId;
  ReqUploadInsuranceDocuments({
    this.insuranceId,
    this.appointmentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'insuranceId': insuranceId,
      'appointmentId': appointmentId,
    };
  }
}
