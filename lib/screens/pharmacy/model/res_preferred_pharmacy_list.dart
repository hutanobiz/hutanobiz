class ResPreferredPharmacyList {
  String status;
  List<Pharmacy> response;

  ResPreferredPharmacyList({this.status, this.response});

  ResPreferredPharmacyList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<Pharmacy>();
      json['response'].forEach((v) {
        response.add(new Pharmacy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pharmacy {
  String sId;
  String name;
  String createdAt;
  String updatedAt;
  int iV;
  List<AddressPharmacy> address;

  Pharmacy(
      {this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address});

  Pharmacy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['address'] != null) {
      address = new List<AddressPharmacy>();
      json['address'].forEach((v) {
        address.add(new AddressPharmacy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressPharmacy {
  String address;
  String city;
  String phone;
  String state;
  String zipCode;
  String sId;

  AddressPharmacy(
      {this.address,
      this.city,
      this.phone,
      this.state,
      this.zipCode,
      this.sId});

  AddressPharmacy.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    state = json['state'];
    zipCode = json['zipCode'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['_id'] = this.sId;
    return data;
  }
}
