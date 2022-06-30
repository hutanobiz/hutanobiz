class ResSearchMedicalHistory {
  String? status;
  List<SearchMedicalHistory>? response;

  ResSearchMedicalHistory({this.status, this.response});

  ResSearchMedicalHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <SearchMedicalHistory>[];
      json['response'].forEach((v) {
        response!.add(new SearchMedicalHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchMedicalHistory {
  int? status;
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SearchMedicalHistory(
      {this.status,
      this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SearchMedicalHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
