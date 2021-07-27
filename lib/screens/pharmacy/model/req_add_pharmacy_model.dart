class ReqAddPharmacyModel {
  String name;
  String address;
  String city;
  String state;
  int zipCode;
  String phoneNumber;

  ReqAddPharmacyModel(
      {this.name,
      this.address,
      this.city,
      this.state,
      this.zipCode,
      this.phoneNumber});

  ReqAddPharmacyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
