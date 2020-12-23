import 'provider_network.dart';

class ResProviderGroup {
  String status;
  Response response;

  ResProviderGroup({this.status, this.response});

  ResProviderGroup.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  Data data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<ProviderNetwork> providerNetwork;

  Data({this.providerNetwork});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['providerNetwork'] != null) {
      providerNetwork = new List<ProviderNetwork>();
      json['providerNetwork'].forEach((v) {
        providerNetwork.add(new ProviderNetwork.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providerNetwork != null) {
      data['providerNetwork'] =
          this.providerNetwork.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
