class ReqResetPassword {
  String phoneNumber;
  int step;
  String email;
  String verificationCode;
  String password;
  String pin;

  ReqResetPassword({
    this.phoneNumber,
    this.step,
    this.email,
    this.verificationCode,
    this.password,
    this.pin,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'step': step,
      'email': email,
      'verificationCode': verificationCode,
      'password': password,
      'pin': pin,
    };
  }

  factory ReqResetPassword.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqResetPassword(
      phoneNumber: map['phoneNumber'],
      step: map['step'],
      email: map['email'],
      verificationCode: map['verificationCode'],
      password: map['password'],
      pin: map['pin'],
    );
  }
}
