import '../../add_family_member/model/res_add_member.dart';

class ResFamilyNetwork {
  String status;
  Response response;

  ResFamilyNetwork({this.status, this.response});

  ResFamilyNetwork.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.toJson();
    }
    return data;
  }
}

class Response {
  String sId;
  List<FamilyNetwork> familyNetwork;

  Response({this.sId, this.familyNetwork});

  Response.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['family_network'] != null) {
      familyNetwork = <FamilyNetwork>[];
      json['family_network'].forEach((v) {
        familyNetwork.add(FamilyNetwork.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = this.sId;
    if (familyNetwork != null) {
      data['family_network'] = familyNetwork.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

