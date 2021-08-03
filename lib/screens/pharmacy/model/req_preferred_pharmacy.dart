class PreferredPharmacyDetail {
  String pharmacyId;
  PharmacyAddress address;

  PreferredPharmacyDetail(this.pharmacyId, this.address);
}

class PharmacyAddress {
  String address;
  String state;
  String zipCode;

  PharmacyAddress(this.address, this.state, this.zipCode);
}
