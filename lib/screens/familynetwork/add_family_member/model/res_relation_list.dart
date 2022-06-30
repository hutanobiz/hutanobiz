class ResRelationList {
  String? status;
  List<Relations>? response;

  ResRelationList({this.status, this.response});

  ResRelationList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Relations>[];
      json['response'].forEach((v) {
        response!.add(Relations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Relations {
  String? relation;
  String? sId;
  int? relationId;

  Relations({this.relation, this.sId, this.relationId});

  Relations.fromJson(Map<String, dynamic> json) {
    relation = json['relation'];
    sId = json['_id'];
    relationId = json['relationId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['relation'] = relation;
    data['_id'] = sId;
    data['relationId'] = relationId;
    return data;
  }
}
