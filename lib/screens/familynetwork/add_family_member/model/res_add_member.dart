class ResAddMember {
  String status;
  String response;
  Data data;

  ResAddMember({this.status, this.response, this.data});

  ResAddMember.fromJson(Map<String, dynamic> json) {
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
  String sId;
  List<FamilyNetwork> familyNetwork;

  Data({this.sId, this.familyNetwork});

  Data.fromJson(Map<String, dynamic> json) {
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
    data['_id'] = sId;
    if (familyNetwork != null) {
      data['family_network'] =
          familyNetwork.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyNetwork {
  String sId;
  String fullName;
  String phoneNumber;
  int userRelation;
  List<int> userPermissions;
  String relation;
  String avatar;
  bool isSelected=false;

  FamilyNetwork(
      {this.sId,
      this.fullName,
      this.phoneNumber,
      this.userRelation,
      this.userPermissions,
      this.avatar,
      this.relation});

  FamilyNetwork.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    userRelation = json['userRelation'];
    userPermissions = json['userPermissions'].cast<int>();
    relation = json['relation'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['userRelation'] = userRelation;
    data['userPermissions'] = userPermissions;
    data['relation'] = relation;
    data['avatar'] = avatar;
    return data;
  }
}
