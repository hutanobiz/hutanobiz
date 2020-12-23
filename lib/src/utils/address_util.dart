import '../ui/auth/register/model/res_google_place_detail.dart';

class AddressUtil {
  String state;
  String city="";
  String zipCode="";
  String _route;
  String _streetNumber;

  String get address => "$_streetNumber $_route";

  void parseAddress(List<AddressComponents> addressComponents) {
    for (final address in addressComponents) {
      if (address.types[0] == "locality") {
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
