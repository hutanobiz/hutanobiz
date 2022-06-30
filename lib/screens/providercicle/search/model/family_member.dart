class FamilyMember {
  String? fullName;
  String? avatar;
  String? phoneNumber;
  String? mobileCountryCode;
  String? sId;
  String? relation;
  int? userRelation;

  FamilyMember(
      {this.fullName,
      this.avatar,
      this.phoneNumber,
      this.mobileCountryCode,
      this.sId,
      this.relation,
      this.userRelation});

  FamilyMember.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    avatar = json['avatar'];
    phoneNumber = json['phoneNumber'];
    mobileCountryCode = json['mobileCountryCode'];
    sId = json['_id'];
    userRelation = json['userRelation'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['phoneNumber'] = phoneNumber;
    data['mobileCountryCode'] = mobileCountryCode;
    data['_id'] = sId;
    data['relation'] = relation;
    data['userRelation'] = userRelation;

    return data;
  }
}
