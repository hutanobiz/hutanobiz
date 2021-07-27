class ResCommunicationReasonModel {
  String status;
  List<CommunicationReason> response;

  ResCommunicationReasonModel({this.status, this.response});

  ResCommunicationReasonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<CommunicationReason>();
      json['response'].forEach((v) {
        response.add(new CommunicationReason.fromJson(v));
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

class CommunicationReason {
  String name;
  String createdAt;
  String sId;
  int iV;

  CommunicationReason({this.name, this.createdAt, this.sId, this.iV});

  CommunicationReason.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdAt = json['createdAt'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
