class ReqAppointmentList {
  final String userId;
  ReqAppointmentList({
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }
}
