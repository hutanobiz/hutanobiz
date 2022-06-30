class ReqResetPassword {
  String? phoneNumber;
  int? step;
  String? email;
  String? verificationCode;
  String? password;
  String? pin;

  ReqResetPassword({
    this.phoneNumber,
    this.step,
    this.email,
    this.verificationCode,
    this.password,
    this.pin,
  });

  Map<String, String?> toMap() {
    Map<String, String?> map = {};
    if (phoneNumber != null) {
      map['phoneNumber'] = phoneNumber;
    }
    if (step != null) {
      map['step'] = step.toString();
    }
    if (email != null) {
      map['email'] = email;
    }
    if (verificationCode != null) {
      map['verificationCode'] = verificationCode;
    }
    if (password != null) {
      map['password'] = password;
    }
    if (pin != null) {
      map['pin'] = pin;
    }
    return map;
  }

  factory ReqResetPassword.fromMap(Map<String, dynamic> map) {
 

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
