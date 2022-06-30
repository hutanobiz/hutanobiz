class ReqAddUserPermissionModel {
  List<String?>? userPermissions;

  ReqAddUserPermissionModel({this.userPermissions});

  ReqAddUserPermissionModel.fromJson(Map<String, dynamic> json) {
    userPermissions = json['userPermissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPermissions'] = this.userPermissions;
    return data;
  }
}
