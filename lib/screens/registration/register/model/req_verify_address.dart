class ReqVerifyAddress {
  final String? street1;
  final String? street2;
  final String? city;
  final String? state;
  final String? zip;
  ReqVerifyAddress({
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.zip,
  });

  Map<String, dynamic> toMap() {
    return {
      'street1': street1,
      'street2': street2,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  factory ReqVerifyAddress.fromMap(Map<String, dynamic> map) {
  
    return ReqVerifyAddress(
      street1: map['street1'],
      street2: map['street2'],
      city: map['city'],
      state: map['state'],
      zip: map['zip'],
    );
  }
}
