class ReqAddMyInsurance {
  final String? userId;
  final String? insuranceId;
  ReqAddMyInsurance({
    this.userId,
    this.insuranceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'insuranceId': insuranceId,
    };
  }
}
