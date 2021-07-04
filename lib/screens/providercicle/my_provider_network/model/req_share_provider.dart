class ReqShareProvider {
  final String doctorId;
  final String userId;
  ReqShareProvider({
    this.doctorId,
    this.userId,
  });

  Map toMap() {
    Map map = {};
    if (doctorId != null) {
      map['doctorId'] = doctorId;
    }
    if (userId != null) {
      map['userId'] = userId;
    }
    return map;
  }
}
