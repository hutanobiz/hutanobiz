class ResMessageShare {
  String? status;
  String? response;

  ResMessageShare({this.status, this.response});

  ResMessageShare.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['response'] = response;
    return data;
  }
}
