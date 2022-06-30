class ResInviteFriends {
  String? status;
  Response? response;

  ResInviteFriends({this.status, this.response});

  ResInviteFriends.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? message;
  String? url;

  Response({this.message, this.url});

  Response.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['url'] = this.url;
    return data;
  }
}
