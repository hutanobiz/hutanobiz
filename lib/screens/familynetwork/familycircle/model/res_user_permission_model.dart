class ResUserPermissionModel {
  String status;
  List<MemberPermission> response;

  ResUserPermissionModel({this.status, this.response});

  ResUserPermissionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<MemberPermission>();
      json['response'].forEach((v) {
        response.add(new MemberPermission.fromJson(v));
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

class MemberPermission {
  String permission;
  String sId;

  MemberPermission({this.permission, this.sId});

  MemberPermission.fromJson(Map<String, dynamic> json) {
    permission = json['permission'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permission'] = this.permission;
    data['_id'] = this.sId;
    return data;
  }
}
