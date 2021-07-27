class ReqUploadImage {
  final String name;
  final String appointmentId;
  ReqUploadImage({
    this.name,
    this.appointmentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'appointmentId': appointmentId,
    };
  }
}
