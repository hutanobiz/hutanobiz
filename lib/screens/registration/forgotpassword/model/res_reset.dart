class ResReset {
  String status;
  String response;

  ResReset({this.status, this.response});

  ResReset.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() => {
    'status' : this.status,
    'response' : this.response
  };
}