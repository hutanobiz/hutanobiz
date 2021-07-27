class ResAppoinment {
  String id;
  ResAppoinment.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      if (json['response'] != null) {
        if (json['response']['data'] != null) {
          id = json['response']['data']['_id'];
        }
      }
    }
  }
}
