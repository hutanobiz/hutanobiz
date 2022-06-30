class ReqRemoveMedicalImages {
  final String? appointmentId;
  final String? imageId;
  ReqRemoveMedicalImages({
    this.appointmentId,
    this.imageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'imageId': imageId,
    };
  }
}
