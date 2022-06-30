class ReqAddMember {
  List<FamilyMembers>? familyMembers;

  ReqAddMember({this.familyMembers});

  ReqAddMember.fromJson(Map<String, dynamic> json) {
    if (json['familyMembers'] != null) {
      familyMembers = <FamilyMembers>[];
      json['familyMembers'].forEach((v) {
        familyMembers!.add(new FamilyMembers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyMembers != null) {
      data['familyMembers'] =
          this.familyMembers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyMembers {
  String? name;
  String? phone;
  String? relationId;
  String? relation;

  FamilyMembers({this.name, this.phone, this.relationId,this.relation});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    relationId = json['relationId'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['relationId'] = this.relationId;
    data['relation'] = this.relation;
    return data;
  }
}
