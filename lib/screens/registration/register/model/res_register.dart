class ResRegister {
  String _status;
  Response _response;

  ResRegister({String status, Response response}) {
    this._status = status;
    this._response = response;
  }

  String get status => _status;
  set status(String status) => _status = status;
  Response get response => _response;
  set response(Response response) => _response = response;

  ResRegister.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _response = json['response'] != String
        ? new Response.fromJson(json['response'])
        : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._response != String) {
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
  State _state;
  String _avatar;
  int _zipCode;
  String _phoneNumber;
  int _gender;
  List<String> _language;
  String _email;
  String _password;
  bool _isAbleTOReceiveOffersAndPromotions;
  bool _isAgreeTermsAndCondition;
  String _mobileCountryCode;
  String _verificationCodeSendAt;
  String _verificationCode;
  bool _isContactInformationVerified;
  bool _isEmailVerified;
  int _status;
  int _type;
  String _resetPasswordVerificationCode;
  String _resetPasswordVerificationCodeSentAt;
  String _stripeCustomerId;
  String _stripeConnectAccount;
  String _pin;
  String _referalCode;
  int _referalPoints;
  String _resetPinVerificationCode;
  String _resetPinVerificationCodeSentAt;
  String _emailVerificationCodeSendAt;
  String _emailVerificationCode;
  String _sId;
  List<String> _insurance;
  List<Tokens> _tokens;
  List<String> _familyNetwork;
  List<String> _providerNetwork;
  String _createdAt;
  String _updatedAt;
  int _iV;
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
      State state,
      String avatar,
      int zipCode,
      String phoneNumber,
      int gender,
      List<String> language,
      String email,
      String password,
      bool isAbleTOReceiveOffersAndPromotions,
      bool isAgreeTermsAndCondition,
      String mobileCountryCode,
      String verificationCodeSendAt,
      String verificationCode,
      bool isContactInformationVerified,
      bool isEmailVerified,
      int status,
      int type,
      String resetPasswordVerificationCode,
      String resetPasswordVerificationCodeSentAt,
      String stripeCustomerId,
      String stripeConnectAccount,
      String pin,
      String referalCode,
      int referalPoints,
      String resetPinVerificationCode,
      String resetPinVerificationCodeSentAt,
      String emailVerificationCodeSendAt,
      String emailVerificationCode,
      String sId,
      List<String> insurance,
      List<Tokens> tokens,
      List<String> familyNetwork,
      List<String> providerNetwork,
      String createdAt,
      String updatedAt,
      int iV,
      String token}) {
    this._location = location;
    this._title = title;
    this._fullName = fullName;
    this._firstName = firstName;
    this._lastName = lastName;
    this._dob = dob;
    this._address = address;
    this._city = city;
    this._state = state;
    this._avatar = avatar;
    this._zipCode = zipCode;
    this._phoneNumber = phoneNumber;
    this._gender = gender;
    this._language = language;
    this._email = email;
    this._password = password;
    this._isAbleTOReceiveOffersAndPromotions =
        isAbleTOReceiveOffersAndPromotions;
    this._isAgreeTermsAndCondition = isAgreeTermsAndCondition;
    this._mobileCountryCode = mobileCountryCode;
    this._verificationCodeSendAt = verificationCodeSendAt;
    this._verificationCode = verificationCode;
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
    this._emailVerificationCodeSendAt = emailVerificationCodeSendAt;
    this._emailVerificationCode = emailVerificationCode;
    this._sId = sId;
    this._insurance = insurance;
    this._tokens = tokens;
    this._familyNetwork = familyNetwork;
    this._providerNetwork = providerNetwork;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._iV = iV;
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
  State get state => _state;
  set state(State state) => _state = state;
  String get avatar => _avatar;
  set avatar(String avatar) => _avatar = avatar;
  int get zipCode => _zipCode;
  set zipCode(int zipCode) => _zipCode = zipCode;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  int get gender => _gender;
  set gender(int gender) => _gender = gender;
  List<String> get language => _language;
  set language(List<String> language) => _language = language;
  String get email => _email;
  set email(String email) => _email = email;
  String get password => _password;
  set password(String password) => _password = password;
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
  String get verificationCodeSendAt => _verificationCodeSendAt;
  set verificationCodeSendAt(String verificationCodeSendAt) =>
      _verificationCodeSendAt = verificationCodeSendAt;
  String get verificationCode => _verificationCode;
  set verificationCode(String verificationCode) =>
      _verificationCode = verificationCode;
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
  String get stripeConnectAccount => _stripeConnectAccount;
  set stripeConnectAccount(String stripeConnectAccount) =>
      _stripeConnectAccount = stripeConnectAccount;
  String get pin => _pin;
  set pin(String pin) => _pin = pin;
  String get referalCode => _referalCode;
  set referalCode(String referalCode) => _referalCode = referalCode;
  int get referalPoints => _referalPoints;
  set referalPoints(int referalPoints) => _referalPoints = referalPoints;
  String get resetPinVerificationCode => _resetPinVerificationCode;
  set resetPinVerificationCode(String resetPinVerificationCode) =>
      _resetPinVerificationCode = resetPinVerificationCode;
  String get resetPinVerificationCodeSentAt => _resetPinVerificationCodeSentAt;
  set resetPinVerificationCodeSentAt(String resetPinVerificationCodeSentAt) =>
      _resetPinVerificationCodeSentAt = resetPinVerificationCodeSentAt;
  String get emailVerificationCodeSendAt => _emailVerificationCodeSendAt;
  set emailVerificationCodeSendAt(String emailVerificationCodeSendAt) =>
      _emailVerificationCodeSendAt = emailVerificationCodeSendAt;
  String get emailVerificationCode => _emailVerificationCode;
  set emailVerificationCode(String emailVerificationCode) =>
      _emailVerificationCode = emailVerificationCode;
  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  List<String> get insurance => _insurance;
  set insurance(List<String> insurance) => _insurance = insurance;
  List<Tokens> get tokens => _tokens;
  set tokens(List<Tokens> tokens) => _tokens = tokens;
  List<String> get familyNetwork => _familyNetwork;
  set familyNetwork(List<String> familyNetwork) =>
      _familyNetwork = familyNetwork;
  List<String> get providerNetwork => _providerNetwork;
  set providerNetwork(List<String> providerNetwork) =>
      _providerNetwork = providerNetwork;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  int get iV => _iV;
  set iV(int iV) => _iV = iV;
  String get token => _token;
  set token(String token) => _token = token;

  Response.fromJson(Map<String, dynamic> json) {
    _location = json['location'] != String
        ? new Location.fromJson(json['location'])
        : String;
    _title = json['title'];
    _fullName = json['fullName'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _dob = json['dob'];
    _address = json['address'];
    _city = json['city'];
    _state =
        json['state'] != String ? new State.fromJson(json['state']) : String;
    _avatar = json['avatar'];
    _zipCode = json['zipCode'];
    _phoneNumber = json['phoneNumber'].toString();
    _gender = json['gender'];
    if (json['language'] != String) {
      /* _language = new List<String>();
      json['language'].forEach((v) {
      //  _language.add(new String.fromJson(v));
      });*/
    }
    _email = json['email'];
    _password = json['password'];
    _isAbleTOReceiveOffersAndPromotions =
        json['isAbleTOReceiveOffersAndPromotions'];
    _isAgreeTermsAndCondition = json['isAgreeTermsAndCondition'];
    _mobileCountryCode = json['mobileCountryCode'];
    _verificationCodeSendAt = json['verificationCodeSendAt'];
    _verificationCode = json['verificationCode'].toString();
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
    _resetPinVerificationCode = json['resetPinVerificationCode'].toString();
    _resetPinVerificationCodeSentAt = json['resetPinVerificationCodeSentAt'];
    _emailVerificationCodeSendAt = json['emailVerificationCodeSendAt'];
    _emailVerificationCode = json['emailVerificationCode'].toString();
    _sId = json['_id'];
    if (json['insurance'] != String) {
      /* _insurance = new List<String>();
      json['insurance'].forEach((v) {
       // _insurance.add(new String.fromJson(v));
      });*/
    }
    if (json['tokens'] != String) {
      _tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        _tokens.add(new Tokens.fromJson(v));
      });
    }
    if (json['familyNetwork'] != String) {
      /* _familyNetwork = new List<String>();
      json['familyNetwork'].forEach((v) {
       // _familyNetwork.add(new String.fromJson(v));
      });*/
    }
    if (json['providerNetwork'] != String) {
      /* _providerNetwork = new List<String>();
      json['providerNetwork'].forEach((v) {
       // _providerNetwork.add(new String.fromJson(v));
      });*/
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _iV = json['__v'];
    _token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._location != String) {
      data['location'] = this._location.toJson();
    }
    data['title'] = this._title;
    data['fullName'] = this._fullName;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['dob'] = this._dob;
    data['address'] = this._address;
    data['city'] = this._city;
    if (this._state != String) {
      data['state'] = this._state.toJson();
    }
    data['avatar'] = this._avatar;
    data['zipCode'] = this._zipCode;
    data['phoneNumber'] = this._phoneNumber;
    data['gender'] = this._gender;
    if (this._language != String) {
      //data['language'] = this._language.map((v) => v.toJson()).toList();
    }
    data['email'] = this._email;
    data['password'] = this._password;
    data['isAbleTOReceiveOffersAndPromotions'] =
        this._isAbleTOReceiveOffersAndPromotions;
    data['isAgreeTermsAndCondition'] = this._isAgreeTermsAndCondition;
    data['mobileCountryCode'] = this._mobileCountryCode;
    data['verificationCodeSendAt'] = this._verificationCodeSendAt;
    data['verificationCode'] = this._verificationCode;
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
    data['emailVerificationCodeSendAt'] = this._emailVerificationCodeSendAt;
    data['emailVerificationCode'] = this._emailVerificationCode;
    data['_id'] = this._sId;
    if (this._insurance != String) {
      // data['insurance'] = this._insurance.map((v) => v.toJson()).toList();
    }
    if (this._tokens != String) {
      data['tokens'] = this._tokens.map((v) => v.toJson()).toList();
    }
    if (this._familyNetwork != String) {
      //data['familyNetwork'] =
      //this._familyNetwork.map((v) => v.toJson()).toList();
    }
    if (this._providerNetwork != String) {
      //data['providerNetwork'] =
      // this._providerNetwork.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
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

class State {
  String _title;
  String _stateCode;
  String _status;
  String _sId;
  String _createdAt;
  String _updatedAt;
  int _iV;

  State(
      {String title,
      String stateCode,
      String status,
      String sId,
      String createdAt,
      String updatedAt,
      int iV}) {
    this._title = title;
    this._stateCode = stateCode;
    this._status = status;
    this._sId = sId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._iV = iV;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get stateCode => _stateCode;
  set stateCode(String stateCode) => _stateCode = stateCode;
  String get status => _status;
  set status(String status) => _status = status;
  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  int get iV => _iV;
  set iV(int iV) => _iV = iV;

  State.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _stateCode = json['stateCode'];
    _status = json['status'];
    _sId = json['_id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['stateCode'] = this._stateCode;
    data['status'] = this._status;
    data['_id'] = this._sId;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
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
