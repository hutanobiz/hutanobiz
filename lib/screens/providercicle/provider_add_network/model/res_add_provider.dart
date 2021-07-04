class ResAddProvider {
  String status;
  String response;

  ResAddProvider({this.status, this.response});

  ResAddProvider.fromJson(Map<String, dynamic> json) {
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
