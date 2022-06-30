class ResBodyPartModel {
  String? status;
  List<BodyPart>? response;

  ResBodyPartModel({this.status, this.response});

  ResBodyPartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <BodyPart>[];
      json['response'].forEach((v) {
        response!.add(new BodyPart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyPart {
  String? name;
  String? sId;

  BodyPart({this.name, this.sId});

  BodyPart.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}
