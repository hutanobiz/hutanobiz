class ResCheckEmail {
  String? status;
  String? response;

  ResCheckEmail({this.status, this.response});

  ResCheckEmail.fromJson(Map<String, dynamic> json) {
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
