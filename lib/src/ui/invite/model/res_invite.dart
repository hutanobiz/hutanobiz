class ResInvite {
  String status;
  String response;
  String message;

  ResInvite({this.status, this.response, this.message});

  ResInvite.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['response'] = response;
    data['message'] = message;
    return data;
  }
}
