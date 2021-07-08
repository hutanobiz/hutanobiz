class ResLogin {
  String _status;
  Response _response;

  ResLogin({String status, Response response}) {
    this._status = status;
    this._response = response;
  }

  String get status => _status;
  set status(String status) => _status = status;
  Response get response => _response;
  set response(Response response) => _response = response;

  ResLogin.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._response != null) {
      data['response'] = this._response.toJson();
    }
    return data;
  }
}

class Response {
  Location _location;
  String _title;
  String _fullName;
  String _firstName;
  String _lastName;
  String _dob;
  String _address;
  String _city;
  String _avatar;
  int _zipCode;
  String _phoneNumber;
  int _gender;
  List<Null> _language;
  String _email;
  bool _isAbleTOReceiveOffersAndPromotions;
  bool _isAgreeTermsAndCondition;
  String _mobileCountryCode;
  bool _isContactInformationVerified;
  bool _isEmailVerified;
  int _status;
  int _type;
  String _resetPasswordVerificationCode;
  String _resetPasswordVerificationCodeSentAt;
  String _stripeCustomerId;
  Null _stripeConnectAccount;
  String _pin;
  String _referalCode;
  int _referalPoints;
  int _resetPinVerificationCode;
  String _resetPinVerificationCodeSentAt;
  String _sId;
  List<Null> _insurance;
  List<Tokens> _tokens;
  String _createdAt;
  String _updatedAt;
  int _iV;
  List<FamilyNetwork> _familyNetwork;
  String _token;

  Response(
      {Location location,
      String title,
      String fullName,
      String firstName,
      String lastName,
      String dob,
      String address,
      String city,
      String avatar,
      int zipCode,
      String phoneNumber,
      int gender,
      List<Null> language,
      String email,
      bool isAbleTOReceiveOffersAndPromotions,
      bool isAgreeTermsAndCondition,
      String mobileCountryCode,
      bool isContactInformationVerified,
      bool isEmailVerified,
      int status,
      int type,
      String resetPasswordVerificationCode,
      String resetPasswordVerificationCodeSentAt,
      String stripeCustomerId,
      Null stripeConnectAccount,
      String pin,
      String referalCode,
      int referalPoints,
      int resetPinVerificationCode,
      String resetPinVerificationCodeSentAt,
      String sId,
      List<Null> insurance,
      List<Tokens> tokens,
      String createdAt,
      String updatedAt,
      int iV,
      List<FamilyNetwork> familyNetwork,
      String token}) {
    this._location = location;
    this._title = title;
    this._fullName = fullName;
    this._firstName = firstName;
    this._lastName = lastName;
    this._dob = dob;
    this._address = address;
    this._city = city;

    this._avatar = avatar;
    this._zipCode = zipCode;
    this._phoneNumber = phoneNumber;
    this._gender = gender;
    this._language = language;
    this._email = email;
    this._isAbleTOReceiveOffersAndPromotions =
        isAbleTOReceiveOffersAndPromotions;
    this._isAgreeTermsAndCondition = isAgreeTermsAndCondition;
    this._mobileCountryCode = mobileCountryCode;
    this._isContactInformationVerified = isContactInformationVerified;
    this._isEmailVerified = isEmailVerified;
    this._status = status;
    this._type = type;
    this._resetPasswordVerificationCode = resetPasswordVerificationCode;
    this._resetPasswordVerificationCodeSentAt =
        resetPasswordVerificationCodeSentAt;
    this._stripeCustomerId = stripeCustomerId;
    this._stripeConnectAccount = stripeConnectAccount;
    this._pin = pin;
    this._referalCode = referalCode;
    this._referalPoints = referalPoints;
    this._resetPinVerificationCode = resetPinVerificationCode;
    this._resetPinVerificationCodeSentAt = resetPinVerificationCodeSentAt;
    this._sId = sId;
    this._insurance = insurance;
    this._tokens = tokens;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._iV = iV;
    this._familyNetwork = familyNetwork;
    this._token = token;
  }

  Location get location => _location;
  set location(Location location) => _location = location;
  String get title => _title;
  set title(String title) => _title = title;
  String get fullName => _fullName;
  set fullName(String fullName) => _fullName = fullName;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get dob => _dob;
  set dob(String dob) => _dob = dob;
  String get address => _address;
  set address(String address) => _address = address;
  String get city => _city;
  set city(String city) => _city = city;

  String get avatar => _avatar;
  set avatar(String avatar) => _avatar = avatar;
  int get zipCode => _zipCode;
  set zipCode(int zipCode) => _zipCode = zipCode;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  int get gender => _gender;
  set gender(int gender) => _gender = gender;
  List<Null> get language => _language;
  set language(List<Null> language) => _language = language;
  String get email => _email;
  set email(String email) => _email = email;
  bool get isAbleTOReceiveOffersAndPromotions =>
      _isAbleTOReceiveOffersAndPromotions;
  set isAbleTOReceiveOffersAndPromotions(
          bool isAbleTOReceiveOffersAndPromotions) =>
      _isAbleTOReceiveOffersAndPromotions = isAbleTOReceiveOffersAndPromotions;
  bool get isAgreeTermsAndCondition => _isAgreeTermsAndCondition;
  set isAgreeTermsAndCondition(bool isAgreeTermsAndCondition) =>
      _isAgreeTermsAndCondition = isAgreeTermsAndCondition;
  String get mobileCountryCode => _mobileCountryCode;
  set mobileCountryCode(String mobileCountryCode) =>
      _mobileCountryCode = mobileCountryCode;
  bool get isContactInformationVerified => _isContactInformationVerified;
  set isContactInformationVerified(bool isContactInformationVerified) =>
      _isContactInformationVerified = isContactInformationVerified;
  bool get isEmailVerified => _isEmailVerified;
  set isEmailVerified(bool isEmailVerified) =>
      _isEmailVerified = isEmailVerified;
  int get status => _status;
  set status(int status) => _status = status;
  int get type => _type;
  set type(int type) => _type = type;
  String get resetPasswordVerificationCode => _resetPasswordVerificationCode;
  set resetPasswordVerificationCode(String resetPasswordVerificationCode) =>
      _resetPasswordVerificationCode = resetPasswordVerificationCode;
  String get resetPasswordVerificationCodeSentAt =>
      _resetPasswordVerificationCodeSentAt;
  set resetPasswordVerificationCodeSentAt(
          String resetPasswordVerificationCodeSentAt) =>
      _resetPasswordVerificationCodeSentAt =
          resetPasswordVerificationCodeSentAt;
  String get stripeCustomerId => _stripeCustomerId;
  set stripeCustomerId(String stripeCustomerId) =>
      _stripeCustomerId = stripeCustomerId;
  Null get stripeConnectAccount => _stripeConnectAccount;
  set stripeConnectAccount(Null stripeConnectAccount) =>
      _stripeConnectAccount = stripeConnectAccount;
  String get pin => _pin;
  set pin(String pin) => _pin = pin;
  String get referalCode => _referalCode;
  set referalCode(String referalCode) => _referalCode = referalCode;
  int get referalPoints => _referalPoints;
  set referalPoints(int referalPoints) => _referalPoints = referalPoints;
  int get resetPinVerificationCode => _resetPinVerificationCode;
  set resetPinVerificationCode(int resetPinVerificationCode) =>
      _resetPinVerificationCode = resetPinVerificationCode;
  String get resetPinVerificationCodeSentAt => _resetPinVerificationCodeSentAt;
  set resetPinVerificationCodeSentAt(String resetPinVerificationCodeSentAt) =>
      _resetPinVerificationCodeSentAt = resetPinVerificationCodeSentAt;
  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  List<Null> get insurance => _insurance;
  set insurance(List<Null> insurance) => _insurance = insurance;
  List<Tokens> get tokens => _tokens;
  set tokens(List<Tokens> tokens) => _tokens = tokens;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  int get iV => _iV;
  set iV(int iV) => _iV = iV;
  List<FamilyNetwork> get familyNetwork => _familyNetwork;
  set familyNetwork(List<FamilyNetwork> familyNetwork) =>
      _familyNetwork = familyNetwork;
  String get token => _token;
  set token(String token) => _token = token;

  Response.fromJson(Map<String, dynamic> json) {
    _location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    _title = json['title'];
    _fullName = json['fullName'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _dob = json['dob'];
    _address = json['address'];
    _city = json['city'];
    _avatar = json['avatar'];
    _zipCode = json['zipCode'];
    _phoneNumber = json['phoneNumber'].toString();
    _gender = json['gender'];
    if (json['language'] != null) {
      _language = new List<Null>();
      json['language'].forEach((v) {
        // _language.add(new Null.fromJson(v));
      });
    }
    _email = json['email'];
    _isAbleTOReceiveOffersAndPromotions =
        json['isAbleTOReceiveOffersAndPromotions'];
    _isAgreeTermsAndCondition = json['isAgreeTermsAndCondition'];
    _mobileCountryCode = json['mobileCountryCode'];
    _isContactInformationVerified = json['isContactInformationVerified'];
    _isEmailVerified = json['isEmailVerified'];
    _status = json['status'];
    _type = json['type'];
    _resetPasswordVerificationCode =
        json['resetPasswordVerificationCode'].toString();
    _resetPasswordVerificationCodeSentAt =
        json['resetPasswordVerificationCodeSentAt'];
    _stripeCustomerId = json['stripeCustomerId'];
    _stripeConnectAccount = json['stripeConnectAccount'];
    _pin = json['pin'];
    _referalCode = json['referalCode'];
    _referalPoints = json['referalPoints'];
    _resetPinVerificationCode = json['resetPinVerificationCode'];
    _resetPinVerificationCodeSentAt = json['resetPinVerificationCodeSentAt'];
    _sId = json['_id'];
    if (json['insurance'] != null) {
      _insurance = new List<Null>();
      json['insurance'].forEach((v) {
        // _insurance.add(new Null.fromJson(v));
      });
    }
    if (json['tokens'] != null) {
      _tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        _tokens.add(new Tokens.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _iV = json['__v'];
    if (json['familyNetwork'] != null) {
      _familyNetwork = new List<FamilyNetwork>();
      json['familyNetwork'].forEach((v) {
        _familyNetwork.add(new FamilyNetwork.fromJson(v));
      });
    }
    _token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._location != null) {
      data['location'] = this._location.toJson();
    }
    data['title'] = this._title;
    data['fullName'] = this._fullName;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['dob'] = this._dob;
    data['address'] = this._address;
    data['city'] = this._city;
    data['avatar'] = this._avatar;
    data['zipCode'] = this._zipCode;
    data['phoneNumber'] = this._phoneNumber;
    data['gender'] = this._gender;
    if (this._language != null) {
      // data['language'] = this._language.map((v) => v.toJson()).toList();
    }
    data['email'] = this._email;
    data['isAbleTOReceiveOffersAndPromotions'] =
        this._isAbleTOReceiveOffersAndPromotions;
    data['isAgreeTermsAndCondition'] = this._isAgreeTermsAndCondition;
    data['mobileCountryCode'] = this._mobileCountryCode;
    data['isContactInformationVerified'] = this._isContactInformationVerified;
    data['isEmailVerified'] = this._isEmailVerified;
    data['status'] = this._status;
    data['type'] = this._type;
    data['resetPasswordVerificationCode'] = this._resetPasswordVerificationCode;
    data['resetPasswordVerificationCodeSentAt'] =
        this._resetPasswordVerificationCodeSentAt;
    data['stripeCustomerId'] = this._stripeCustomerId;
    data['stripeConnectAccount'] = this._stripeConnectAccount;
    data['pin'] = this._pin;
    data['referalCode'] = this._referalCode;
    data['referalPoints'] = this._referalPoints;
    data['resetPinVerificationCode'] = this._resetPinVerificationCode;
    data['resetPinVerificationCodeSentAt'] =
        this._resetPinVerificationCodeSentAt;
    data['_id'] = this._sId;
    if (this._insurance != null) {
      // data['insurance'] = this._insurance.map((v) => v.toJson()).toList();
    }
    if (this._tokens != null) {
      data['tokens'] = this._tokens.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
    if (this._familyNetwork != null) {
      data['familyNetwork'] =
          this._familyNetwork.map((v) => v.toJson()).toList();
    }
    data['token'] = this._token;
    return data;
  }
}

class Location {
  String _type;
  List<int> _coordinates;

  Location({String type, List<int> coordinates}) {
    this._type = type;
    this._coordinates = coordinates;
  }

  String get type => _type;
  set type(String type) => _type = type;
  List<int> get coordinates => _coordinates;
  set coordinates(List<int> coordinates) => _coordinates = coordinates;

  Location.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['coordinates'] = this._coordinates;
    return data;
  }
}

class Tokens {
  String _sId;
  String _access;
  String _token;

  Tokens({String sId, String access, String token}) {
    this._sId = sId;
    this._access = access;
    this._token = token;
  }

  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  String get access => _access;
  set access(String access) => _access = access;
  String get token => _token;
  set token(String token) => _token = token;

  Tokens.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _access = json['access'];
    _token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['access'] = this._access;
    data['token'] = this._token;
    return data;
  }
}

class FamilyNetwork {
  String _userId;
  int _userRelation;
  List<Null> _userPermissions;
  String _sId;

  FamilyNetwork(
      {String userId,
      int userRelation,
      List<Null> userPermissions,
      String sId}) {
    this._userId = userId;
    this._userRelation = userRelation;
    this._userPermissions = userPermissions;
    this._sId = sId;
  }

  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  int get userRelation => _userRelation;
  set userRelation(int userRelation) => _userRelation = userRelation;
  List<Null> get userPermissions => _userPermissions;
  set userPermissions(List<Null> userPermissions) =>
      _userPermissions = userPermissions;
  String get sId => _sId;
  set sId(String sId) => _sId = sId;

  FamilyNetwork.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _userRelation = json['userRelation'];
    if (json['userPermissions'] != null) {
      _userPermissions = new List<Null>();
      json['userPermissions'].forEach((v) {
        //  _userPermissions.add(new Null.fromJson(v));
      });
    }
    _sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['userRelation'] = this._userRelation;
    if (this._userPermissions != null) {
      //data['userPermissions'] =
      //  this._userPermissions.map((v) => v.toJson()).toList();
    }
    data['_id'] = this._sId;
    return data;
  }
}
