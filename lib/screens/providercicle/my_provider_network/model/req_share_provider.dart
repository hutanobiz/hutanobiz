class ReqShareProvider {
  final String doctorId;
  final String userId;
  ReqShareProvider({
    this.doctorId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'userId': userId,
    };
  }
}
