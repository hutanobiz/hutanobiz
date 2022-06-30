class ResAddCard {
  String? _status;
  Response? _response;

  ResAddCard({String? status, Response? response}) {
    this._status = status;
    this._response = response;
  }

  String? get status => _status;

  set status(String? status) => _status = status;

  Response? get response => _response;

  set response(Response? response) => _response = response;

  ResAddCard.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._response != null) {
      data['response'] = this._response!.toJson();
    }
    return data;
  }
}

class Response {
  String? _id;
  String? _object;
  String? _addressCity;
  String? _addressCountry;
  String? _addressLine1;
  String? _addressLine1Check;
  String? _addressLine2;
  String? _addressState;
  String? _addressZip;
  String? _addressZipCheck;
  String? _brand;
  String? _country;
  String? _customer;
  String? _cvcCheck;
  String? _dynamicLast4;
  int? _expMonth;
  int? _expYear;
  String? _fingerprint;
  String? _funding;
  String? _last4;
  String? _name;
  String? _tokenizationMethod;

  Response(
      {String? id,
      String? object,
      String? addressCity,
      String? addressCountry,
      String? addressLine1,
      String? addressLine1Check,
      String? addressLine2,
      String? addressState,
      String? addressZip,
      String? addressZipCheck,
      String? brand,
      String? country,
      String? customer,
      String? cvcCheck,
      String? dynamicLast4,
      int? expMonth,
      int? expYear,
      String? fingerprint,
      String? funding,
      String? last4,
      String? name,
      String? tokenizationMethod}) {
    this._id = id;
    this._object = object;
    this._addressCity = addressCity;
    this._addressCountry = addressCountry;
    this._addressLine1 = addressLine1;
    this._addressLine1Check = addressLine1Check;
    this._addressLine2 = addressLine2;
    this._addressState = addressState;
    this._addressZip = addressZip;
    this._addressZipCheck = addressZipCheck;
    this._brand = brand;
    this._country = country;
    this._customer = customer;
    this._cvcCheck = cvcCheck;
    this._dynamicLast4 = dynamicLast4;
    this._expMonth = expMonth;
    this._expYear = expYear;
    this._fingerprint = fingerprint;
    this._funding = funding;
    this._last4 = last4;
    this._name = name;
    this._tokenizationMethod = tokenizationMethod;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  String? get object => _object;

  set object(String? object) => _object = object;

  String? get addressCity => _addressCity;

  set addressCity(String? addressCity) => _addressCity = addressCity;

  String? get addressCountry => _addressCountry;

  set addressCountry(String? addressCountry) => _addressCountry = addressCountry;

  String? get addressLine1 => _addressLine1;

  set addressLine1(String? addressLine1) => _addressLine1 = addressLine1;

  String? get addressLine1Check => _addressLine1Check;

  set addressLine1Check(String? addressLine1Check) =>
      _addressLine1Check = addressLine1Check;

  String? get addressLine2 => _addressLine2;

  set addressLine2(String? addressLine2) => _addressLine2 = addressLine2;

  String? get addressState => _addressState;

  set addressState(String? addressState) => _addressState = addressState;

  String? get addressZip => _addressZip;

  set addressZip(String? addressZip) => _addressZip = addressZip;

  String? get addressZipCheck => _addressZipCheck;

  set addressZipCheck(String? addressZipCheck) =>
      _addressZipCheck = addressZipCheck;

  String? get brand => _brand;

  set brand(String? brand) => _brand = brand;

  String? get country => _country;

  set country(String? country) => _country = country;

  String? get customer => _customer;

  set customer(String? customer) => _customer = customer;

  String? get cvcCheck => _cvcCheck;

  set cvcCheck(String? cvcCheck) => _cvcCheck = cvcCheck;

  String? get dynamicLast4 => _dynamicLast4;

  set dynamicLast4(String? dynamicLast4) => _dynamicLast4 = dynamicLast4;

  int? get expMonth => _expMonth;

  set expMonth(int? expMonth) => _expMonth = expMonth;

  int? get expYear => _expYear;

  set expYear(int? expYear) => _expYear = expYear;

  String? get fingerprint => _fingerprint;

  set fingerprint(String? fingerprint) => _fingerprint = fingerprint;

  String? get funding => _funding;

  set funding(String? funding) => _funding = funding;

  String? get last4 => _last4;

  set last4(String? last4) => _last4 = last4;

  String? get name => _name;

  set name(String? name) => _name = name;

  String? get tokenizationMethod => _tokenizationMethod;

  set tokenizationMethod(String? tokenizationMethod) =>
      _tokenizationMethod = tokenizationMethod;

  Response.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _object = json['object'];
    _addressCity = json['address_city'];
    _addressCountry = json['address_country'];
    _addressLine1 = json['address_line1'];
    _addressLine1Check = json['address_line1_check'];
    _addressLine2 = json['address_line2'];
    _addressState = json['address_state'];
    _addressZip = json['address_zip'];
    _addressZipCheck = json['address_zip_check'];
    _brand = json['brand'];
    _country = json['country'];
    _customer = json['customer'];
    _cvcCheck = json['cvc_check'];
    _dynamicLast4 = json['dynamic_last4'];
    _expMonth = json['exp_month'];
    _expYear = json['exp_year'];
    _fingerprint = json['fingerprint'];
    _funding = json['funding'];
    _last4 = json['last4'];
    _name = json['name'];
    _tokenizationMethod = json['tokenization_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['object'] = this._object;
    data['address_city'] = this._addressCity;
    data['address_country'] = this._addressCountry;
    data['address_line1'] = this._addressLine1;
    data['address_line1_check'] = this._addressLine1Check;
    data['address_line2'] = this._addressLine2;
    data['address_state'] = this._addressState;
    data['address_zip'] = this._addressZip;
    data['address_zip_check'] = this._addressZipCheck;
    data['brand'] = this._brand;
    data['country'] = this._country;
    data['customer'] = this._customer;
    data['cvc_check'] = this._cvcCheck;
    data['dynamic_last4'] = this._dynamicLast4;
    data['exp_month'] = this._expMonth;
    data['exp_year'] = this._expYear;
    data['fingerprint'] = this._fingerprint;
    data['funding'] = this._funding;
    data['last4'] = this._last4;
    data['name'] = this._name;
    data['tokenization_method'] = this._tokenizationMethod;
    return data;
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
