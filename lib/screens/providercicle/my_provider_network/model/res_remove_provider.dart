class ResRemoveProvider {
  String status;
  String response;

  ResRemoveProvider({this.status, this.response});

  ResRemoveProvider.fromJson(Map<String, dynamic> json) {
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
