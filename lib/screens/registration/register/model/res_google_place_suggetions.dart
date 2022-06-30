class ResGooglePlaceSuggetions {
  List<Places>? results;
  String? status;

  ResGooglePlaceSuggetions({this.results, this.status});

  ResGooglePlaceSuggetions.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Places>[];
      json['results'].forEach((v) {
        results!.add(Places.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Places {
  String? formattedAddress;
  String? name;
  String? placeId;
  PlusCode? plusCode;
  String? reference;
  List<String>? types;

  Places(
      {this.formattedAddress,
      this.name,
      this.placeId,
      this.plusCode,
      this.reference,
      this.types});

  Places.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formatted_address'];
    name = json['name'];
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ? PlusCode.fromJson(json['plus_code'])
        : null;
    reference = json['reference'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formatted_address'] = formattedAddress;
    data['name'] = name;
    data['place_id'] = placeId;
    if (plusCode != null) {
      data['plus_code'] = plusCode!.toJson();
    }
    data['reference'] = reference;
    data['types'] = types;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}
