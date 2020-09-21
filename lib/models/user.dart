class User {
  Location location;
  String fullName;
  String dob;
  String address;
  String city;
  String state;
  String avatar;
  String zipCode;
  String phoneNumber;
  String gender;
  String language;
  bool isAbleTOReceiveOffersAndPromotions;
  bool isAgreeTermsAndCondition;
  String mobileCountryCode;
  bool isContactInformationVerified;
  int status;
  int type;
  int resetPasswordVerificationCode;
  String resetPasswordVerificationCodeSentAt;
  String sId;
  String email;
  List<Tokens> tokens;
  String createdAt;
  String updatedAt;
  int iV;

  User(
      {this.location,
      this.fullName,
      this.dob,
      this.address,
      this.city,
      this.state,
      this.avatar,
      this.zipCode,
      this.phoneNumber,
      this.gender,
      this.language,
      this.isAbleTOReceiveOffersAndPromotions,
      this.isAgreeTermsAndCondition,
      this.mobileCountryCode,
      this.isContactInformationVerified,
      this.status,
      this.type,
      this.resetPasswordVerificationCode,
      this.resetPasswordVerificationCodeSentAt,
      this.sId,
      this.email,
      this.tokens,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    fullName = json['fullName'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    avatar = json['avatar'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    language = json['language'];
    isAbleTOReceiveOffersAndPromotions =
        json['isAbleTOReceiveOffersAndPromotions'];
    isAgreeTermsAndCondition = json['isAgreeTermsAndCondition'];
    mobileCountryCode = json['mobileCountryCode'];
    isContactInformationVerified = json['isContactInformationVerified'];
    status = json['status'];
    type = json['type'];
    resetPasswordVerificationCode = json['resetPasswordVerificationCode'];
    resetPasswordVerificationCodeSentAt =
        json['resetPasswordVerificationCodeSentAt'];
    sId = json['_id'];
    email = json['email'];
    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['fullName'] = this.fullName;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['avatar'] = this.avatar;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['language'] = this.language;
    data['isAbleTOReceiveOffersAndPromotions'] =
        this.isAbleTOReceiveOffersAndPromotions;
    data['isAgreeTermsAndCondition'] = this.isAgreeTermsAndCondition;
    data['mobileCountryCode'] = this.mobileCountryCode;
    data['isContactInformationVerified'] = this.isContactInformationVerified;
    data['status'] = this.status;
    data['type'] = this.type;
    data['resetPasswordVerificationCode'] = this.resetPasswordVerificationCode;
    data['resetPasswordVerificationCodeSentAt'] =
        this.resetPasswordVerificationCodeSentAt;
    data['_id'] = this.sId;
    data['email'] = this.email;
    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  String type;
  List<Object> coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = new List<Object>();
      json['coordinates'].forEach((v) {
        coordinates.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;

    return data;
  }
}

class Tokens {
  String sId;
  String access;
  String token;

  Tokens({this.sId, this.access, this.token});

  Tokens.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    access = json['access'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['access'] = this.access;
    data['token'] = this.token;
    return data;
  }
}
