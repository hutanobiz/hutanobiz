import '../../../../utils/enum_utils.dart';

class VerificationModel {
  final String countryCode;
  final String email;
  final String phone;
  final VerificationScreen verificationScreen;
  final VerificationType verificationType;
  VerificationModel({
    this.countryCode,
    this.email,
    this.phone,
    this.verificationScreen,
    this.verificationType,
  });

  @override
  String toString() {
    return """VerificationModel(countryCode: $countryCode, 
    email: $email, phone: $phone, verificationScreen: $verificationScreen, verificationType: $verificationType)""";
  }
}
