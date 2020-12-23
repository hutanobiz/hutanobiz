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
  int gender;
  String fullName;
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
      this.gender,
      this.fullName});

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'email': email,
      'zipCode': zipCode,
      'state': state,
      'dob': dob,
      'city': city,
      'insuranceId': insuranceId,
      'mobileCountryCode': mobileCountryCode,
      'isAgreeTermsAndCondition': isAgreeTermsAndCondition,
      'phoneNumber': phoneNumber,
      'referedBy': referedBy,
      'type': type,
      'step': step,
      'fullName': fullName,
      'gender': gender
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
      fullName: map['fullName'],
    );
  }
}
