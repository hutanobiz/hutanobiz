class ResGooglePlaceDetailPharmacy {
  List<String>? htmlAttributions;
  Result? result;
  String? status;

  ResGooglePlaceDetailPharmacy(
      {this.htmlAttributions, this.result, this.status});

  ResGooglePlaceDetailPharmacy.fromJson(Map<String, dynamic> json) {
    htmlAttributions = json['html_attributions'].cast<String>();
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['html_attributions'] = this.htmlAttributions;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Result {
  List<AddressComponentsDetail>? addressComponents;
  GeometryDetail? geometry;

  Result({this.addressComponents, this.geometry});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponentsDetail>[];
      json['address_components'].forEach((v) {
        addressComponents!.add(new AddressComponentsDetail.fromJson(v));
      });
    }
    geometry = json['geometry'] != null
        ? new GeometryDetail.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents!.map((v) => v.toJson()).toList();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    return data;
  }
}

class AddressComponentsDetail {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponentsDetail({this.longName, this.shortName, this.types});

  AddressComponentsDetail.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long_name'] = this.longName;
    data['short_name'] = this.shortName;
    data['types'] = this.types;
    return data;
  }
}

class GeometryDetail {
  LocationDetail? location;
  Viewport? viewport;

  GeometryDetail({this.location, this.viewport});

  GeometryDetail.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new LocationDetail.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ? new Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class LocationDetail {
  double? lat;
  double? lng;

  LocationDetail({this.lat, this.lng});

  LocationDetail.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  LocationDetail? northeast;
  LocationDetail? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? new LocationDetail.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? new LocationDetail.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}
