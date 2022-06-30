class ReqLoginPin {
  String? phoneNumber;
  int? type;
  String? deviceToken;
  String? pin;

  ReqLoginPin({
    this.phoneNumber,
    this.type = 1,
    this.deviceToken = "",
    this.pin,
  });

  Map<String, String?> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'type': type.toString(),
      'deviceToken': deviceToken,
      'pin': pin,
    };
  }

  factory ReqLoginPin.fromMap(Map<String, dynamic> map) {


    return ReqLoginPin(
      phoneNumber: map['phoneNumber'],
      type: map['type'],
      deviceToken: map['deviceToken'],
      pin: map['pin'],
    );
  }
}
