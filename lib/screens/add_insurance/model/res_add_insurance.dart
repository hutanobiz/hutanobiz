class ResAddInsurance {
  String? status;
  List<Response>? response;

  ResAddInsurance({this.status, this.response});

  ResAddInsurance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = [];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? location;
  String? param;
  String? msg;

  Response({this.location, this.param, this.msg});

  Response.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    param = json['param'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['param'] = this.param;
    data['msg'] = this.msg;
    return data;
  }
}
