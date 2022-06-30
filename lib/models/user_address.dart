class Address {
  String? title;
  int? addresstype;
  String? address;
  String? street;
  String? city;
  State? state;
  String? stateCode;
  String? zipCode;
  String? type;
  List<double>? coordinates;
  String? sId;
  String? number;
  String? securityGate;

  Address(
      {this.title,
      this.addresstype,
      this.address,
      this.street,
      this.city,
      this.state,
      this.stateCode,
      this.zipCode,
      this.type,
      this.coordinates,
      this.sId,
      this.number,
      this.securityGate});

  Address.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    addresstype = json['addresstype'];
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    stateCode = json['stateCode'];
    zipCode = json['zipCode'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    sId = json['_id'];
    number = json['number'];
    securityGate = json['securityGate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['addresstype'] = this.addresstype;
    data['address'] = this.address;
    data['street'] = this.street;
    data['city'] = this.city;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    data['stateCode'] = this.stateCode;
    data['zipCode'] = this.zipCode;
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['_id'] = this.sId;
    data['number'] = this.number;
    data['securityGate'] = this.securityGate;
    return data;
  }
}

class State {
  String? sId;
  String? title;
  String? stateCode;
  Null status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  State(
      {this.sId,
      this.title,
      this.stateCode,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  State.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    stateCode = json['stateCode'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['stateCode'] = this.stateCode;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
