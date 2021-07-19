class ReqRemoveFamilyMember {
  String sId;
  String userId;

  ReqRemoveFamilyMember({this.sId, this.userId});

  ReqRemoveFamilyMember.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    return data;
  }
}
