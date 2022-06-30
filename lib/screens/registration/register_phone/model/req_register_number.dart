class ReqRegsiterNumber {
  int? type;
  String? fullName;
  int? isAgreeTermsAndCondition;
  String? phoneNumber;
  int? step;
  String? verificationCode;
  String? mobileCountryCode;
  ReqRegsiterNumber({
    this.type,
    this.fullName,
    this.isAgreeTermsAndCondition,
    this.phoneNumber,
    this.step,
    this.verificationCode,
    this.mobileCountryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'fullName': fullName,
      'isAgreeTermsAndCondition': isAgreeTermsAndCondition,
      'phoneNumber': phoneNumber,
      'step': step,
      'verificationCode': verificationCode,
      'mobileCountryCode': mobileCountryCode,
    };
  }
}
