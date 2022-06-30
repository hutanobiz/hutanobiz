class ResResetPassword {
  String? status;
  String? response;

  ResResetPassword({this.status, this.response});

  ResResetPassword.fromJson(Map<String, dynamic> json) {
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

