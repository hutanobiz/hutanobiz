

import 'package:hutano/screens/pharmacy/model/res_google_place_detail_pharmacy.dart';
import 'package:hutano/screens/registration/register/model/res_google_place_detail.dart';
class AddressUtil {
  String state;
  String city = "";
  String zipCode = "";
  String _route;
  String _streetNumber;

  String get address => "${_streetNumber ?? ""} $_route".trim();

  void parseAddress(List<AddressComponents> addressComponents) {
    for (final address in addressComponents) {
      if (address.types[0] == "locality") {
        city = address.longName;
      }
      if (city.isEmpty && address.types[0] == "administrative_area_level_2") {
        city = address.longName;
      }

      if (address.types[0] == "administrative_area_level_1") {
        state = address.longName;
      }
      if (address.types[0] == "postal_code") {
        zipCode = address.longName;
      }
      if (address.types[0] == "street_number") {
        _streetNumber = address.longName;
      }
      if (address.types[0] == "route") {
        _route = address.longName;
      }
    }
  }

  void parsePharmacyAddress(List<AddressComponentsDetail> addressComponents) {
    for (final address in addressComponents) {
      if (address.types[0] == "locality") {
        city = address.longName;
      }
      if (city.isEmpty && address.types[0] == "administrative_area_level_2") {
        city = address.longName;
      }

      if (address.types[0] == "administrative_area_level_1") {
        state = address.longName;
      }
      if (address.types[0] == "postal_code") {
        zipCode = address.longName;
      }
      if (address.types[0] == "street_number") {
        _streetNumber = address.longName;
      }
      if (address.types[0] == "route") {
        _route = address.longName;
      }
    }
  }
}
