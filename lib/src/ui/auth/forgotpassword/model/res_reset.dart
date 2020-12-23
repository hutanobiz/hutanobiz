class ResReset {
  String status;
  Response response;

  ResReset({this.status, this.response});

  ResReset.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.toJson();
    }
    return data;
  }
}

class Response {
  List<Tokens> tokens;

  Response({tokens});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['tokens'] != null) {
      tokens = <Tokens>[];
      json['tokens'].forEach((v) {
        tokens.add(Tokens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (tokens != null) {
      data['tokens'] = tokens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tokens {
  String sId;
  String access;
  String token;

  Tokens({sId, access, token});

  Tokens.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    access = json['access'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['access'] = access;
    data['token'] = token;
    return data;
  }
}
