class AllergiesData {
  String status;
  List<Allergy> response;

  AllergiesData({this.status, this.response});

  AllergiesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<Allergy>();
      json['response'].forEach((v) {
        response.add(new Allergy.fromJson(v));
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

class Allergy {
  String sId;
  String name;
  String allergyId;

  Allergy({this.sId, this.name, this.allergyId});

  Allergy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    allergyId = json['allergyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['allergyId'] = this.allergyId;
    return data;
  }
}

class MyAllergiesData {
  String status;
  List<MyAllergiesResponse> response;

  MyAllergiesData({this.status, this.response});

  MyAllergiesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<MyAllergiesResponse>();
      json['response'].forEach((v) {
        response.add(new MyAllergiesResponse.fromJson(v));
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

class MyAllergiesResponse {
  String sId;
  List<Allergy> allergy;

  MyAllergiesResponse({this.sId, this.allergy});

  MyAllergiesResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['allergy'] != null) {
      allergy = new List<Allergy>();
      json['allergy'].forEach((v) {
        allergy.add(new Allergy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.allergy != null) {
      data['allergy'] = this.allergy.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



