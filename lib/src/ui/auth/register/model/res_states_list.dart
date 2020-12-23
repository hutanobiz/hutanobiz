class ResStatesList {
  String status;
  List<States> response;

  ResStatesList({this.status, this.response});

  ResStatesList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <States>[];
      json['response'].forEach((v) {
        response.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String title;
  String stateCode;
  int status;
  String sId;
  int iV;

  States({this.title, this.stateCode, this.status, this.sId, this.iV});

  States.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    stateCode = json['stateCode'];
    status = json['status'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['stateCode'] = stateCode;
    data['status'] = status;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
