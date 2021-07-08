class ResRegisterNumber {
  String status;
  dynamic response;

  ResRegisterNumber({this.status, this.response});

  ResRegisterNumber.fromJson(Map<String, dynamic> json) {
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
