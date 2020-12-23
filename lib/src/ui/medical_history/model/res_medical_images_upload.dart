class ResMedicalImageUpload {
  String status;
  String response;
  Data data;

  ResMedicalImageUpload({this.status, this.response, this.data});

  ResMedicalImageUpload.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['response'] = response;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<MedicalImages> medicalImages;

  Data({this.medicalImages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medicalImages'] != null) {
      medicalImages = <MedicalImages>[];
      json['medicalImages'].forEach((v) {
        medicalImages.add(MedicalImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (medicalImages != null) {
      data['medicalImages'] = medicalImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicalImages {
  String images;
  String name;
  String sId;

  MedicalImages({this.images, this.name, this.sId});

  MedicalImages.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images;
    data['name'] = name;
    data['_id'] = sId;
    return data;
  }
}
