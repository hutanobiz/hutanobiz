class ReqLoginPin {
  String phoneNumber;
  int type;
  String deviceToken;
  String pin;

  ReqLoginPin({
    this.phoneNumber,
    this.type=1,
    this.deviceToken="",
    this.pin,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'type': type,
      'deviceToken': deviceToken,
      'pin': pin,
    };
  }

  factory ReqLoginPin.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqLoginPin(
      phoneNumber: map['phoneNumber'],
      type: map['type'],
      deviceToken: map['deviceToken'],
      pin: map['pin'],
    );
  }
}
