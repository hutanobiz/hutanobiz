class ReqEmail {
  int? step;
  String? emailVerificationCode;
  String? phoneNumber;
  String? email;
  String? otp;

  ReqEmail(
      {this.step,
      this.emailVerificationCode,
      this.phoneNumber,
      this.email,
      this.otp});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["step"] = step;
    if (emailVerificationCode != null)
      data["emailVerificationCode"] = emailVerificationCode;
    if (phoneNumber != null) data["phoneNumber"] = phoneNumber;
    if (email != null) data["email"] = email;
    if (otp != null) data["otp"] = otp;
    return data;
  }
}
