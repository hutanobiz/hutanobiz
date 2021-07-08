class ResVerifyAddress {
  String status;
  Response response;

  ResVerifyAddress({this.status, this.response});

  ResVerifyAddress.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.toJson();
    }
    return data;
  }
}

class Response {
  String street1;
  String street2;
  String city;
  String zip;
  String state;
  String zip4;
  String deliveryPoint;
  String carrierRoute;
  String footnotes;
  String dpvConfirmation;
  String dpvcmra;
  String dpvFootnotes;
  String business;
  String centralDeliveryPoint;
  String vacant;

  Response(
      {this.street1,
      this.street2,
      this.city,
      this.zip,
      this.state,
      this.zip4,
      this.deliveryPoint,
      this.carrierRoute,
      this.footnotes,
      this.dpvConfirmation,
      this.dpvcmra,
      this.dpvFootnotes,
      this.business,
      this.centralDeliveryPoint,
      this.vacant});

  Response.fromJson(Map<String, dynamic> json) {
    street1 = json['street1'];
    street2 = json['street2'];
    city = json['city'];
    zip = json['zip'];
    state = json['state'];
    zip4 = json['zip4'];
    deliveryPoint = json['delivery_point'];
    carrierRoute = json['carrier_route'];
    footnotes = json['footnotes'];
    dpvConfirmation = json['dpv_confirmation'];
    dpvcmra = json['dpvcmra'];
    dpvFootnotes = json['dpv_footnotes'];
    business = json['business'];
    centralDeliveryPoint = json['central_delivery_point'];
    vacant = json['vacant'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['street1'] = street1;
    data['street2'] = street2;
    data['city'] = city;
    data['zip'] = zip;
    data['state'] = state;
    data['zip4'] = zip4;
    data['delivery_point'] = deliveryPoint;
    data['carrier_route'] = carrierRoute;
    data['footnotes'] = footnotes;
    data['dpv_confirmation'] = dpvConfirmation;
    data['dpvcmra'] = dpvcmra;
    data['dpv_footnotes'] = dpvFootnotes;
    data['business'] = business;
    data['central_delivery_point'] = centralDeliveryPoint;
    data['vacant'] = vacant;
    return data;
  }
}
