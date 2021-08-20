class ReqRegister {
  String password;
  String firstName;
  String lastName;
  String address;
  String email;
  String zipCode;
  String state;
  String dob;
  String city;
  String insuranceId;
  String mobileCountryCode;
  int isAgreeTermsAndCondition;
  String phoneNumber;
  String referedBy;
  int type;
  int step;
  String deviceToken;
  int gender;
  int genderType;
  String fullName;
  bool haveHealthInsurance;
  String latitude;
  String longitude;
  ReqRegister(
      {this.password,
      this.firstName,
      this.lastName,
      this.address,
      this.email,
      this.zipCode,
      this.state,
      this.dob,
      this.city,
      this.insuranceId,
      this.mobileCountryCode,
      this.isAgreeTermsAndCondition,
      this.phoneNumber,
      this.referedBy,
      this.type,
      this.step,
      this.haveHealthInsurance,
      this.deviceToken,
      this.gender,
      this.genderType,
      this.fullName,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'email': email,
      'deviceToken': deviceToken,
      'zipCode': zipCode,
      'state': state,
      'dob': dob,
      'haveHealthInsurance': haveHealthInsurance,
      'city': city,
      'insuranceId': insuranceId,
      'mobileCountryCode': mobileCountryCode,
      'isAgreeTermsAndCondition': isAgreeTermsAndCondition,
      'phoneNumber': phoneNumber,
      'referedBy': referedBy,
      'type': type,
      'step': step,
      'fullName': fullName,
      'gender': gender,
      'genderType': genderType,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ReqRegister.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqRegister(
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      email: map['email'],
      zipCode: map['zipCode'],
      state: map['state'],
      haveHealthInsurance: map['haveHealthInsurance'],
      deviceToken: map['deviceToken'],
      dob: map['dob'],
      city: map['city'],
      insuranceId: map['insuranceId'],
      mobileCountryCode: map['mobileCountryCode'],
      isAgreeTermsAndCondition: map['isAgreeTermsAndCondition'],
      phoneNumber: map['phoneNumber'],
      referedBy: map['referedBy'],
      type: map['type'],
      step: map['step'],
      gender: map['gender'],
      genderType: map['genderType'],
      fullName: map['fullName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
