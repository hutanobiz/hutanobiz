class ReqMessageShare {
  final String phoneNumber;
  final String message;
  ReqMessageShare({
    this.phoneNumber,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'message': message,
    };
  }
}
