class ResRewardPoints {
  String? status;
  int? response;

  ResRewardPoints({this.status, this.response});

  ResRewardPoints.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['response'] = this.response;
    return data;
  }
}
