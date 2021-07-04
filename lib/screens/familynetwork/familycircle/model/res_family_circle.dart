class ResFamilyCircle {
  String status;
  List<CircleMember> response;

  ResFamilyCircle({this.status, this.response});

  ResFamilyCircle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<CircleMember>();
      json['response'].forEach((v) {
        response.add(new CircleMember.fromJson(v));
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

class CircleMember {
  String sId;
  String name;
  String phone;
  int relationId;
  String relationName;
  List<UserPermissions> userPermissions;
  bool isSelected = false;

  CircleMember(
      {this.sId,
      this.name,
      this.phone,
      this.relationId,
      this.relationName,
      this.userPermissions});

  CircleMember.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    relationId = json['relationId'];
    relationName = json['relationName'];
    if (json['userPermissions'] != null) {
      userPermissions = new List<UserPermissions>();
      json['userPermissions'].forEach((v) {
        userPermissions.add(new UserPermissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['relationId'] = this.relationId;
    data['relationName'] = this.relationName;
    if (this.userPermissions != null) {
      data['userPermissions'] =
          this.userPermissions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserPermissions {
  String permission;
  String sId;
  bool isSelected = false;

  UserPermissions({this.permission, this.sId});

  UserPermissions.fromJson(Map<String, dynamic> json) {
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
