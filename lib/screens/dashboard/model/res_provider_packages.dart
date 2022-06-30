class ResProviderPacakges {
  String? status;
  Response? response;

  ResProviderPacakges({this.status, this.response});

  ResProviderPacakges.fromJson(Map<String, dynamic> json) {
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
  Consultation? consultation;

  Response({this.consultation});

  Response.fromJson(Map<String, dynamic> json) {
    consultation = json['consultation'] != null
        ? new Consultation.fromJson(json['consultation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consultation != null) {
      data['consultation'] = this.consultation!.toJson();
    }
    return data;
  }
}

class Consultation {
  Office? office;
  Office? onSite;
  Office? video;

  Consultation({this.office, this.onSite, this.video});

  Consultation.fromJson(Map<String, dynamic> json) {
    office =
        json['office'] != null ? new Office.fromJson(json['office']) : null;
    onSite =
        json['onSite'] != null ? new Office.fromJson(json['onSite']) : null;
    video = json['video'] != null ? new Office.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.office != null) {
      data['office'] = this.office!.toJson();
    }
    if (this.onSite != null) {
      data['onSite'] = this.onSite!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class Office {
  int? fee;
  int? duration;
  String? sId;
  List<ServiceData>? services;

  Office({this.fee, this.duration, this.sId, this.services});

  Office.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    duration = json['duration'];
    sId = json['_id'];
    if (json['services'] != null) {
      services = <ServiceData>[];
      json['services'].forEach((v) {
        services!.add(new ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['duration'] = this.duration;
    data['_id'] = this.sId;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceData {
  int? duration;
  int? amount;
  int? serviceType;
  String? subServiceId;
  String? subServiceTitle;

  ServiceData(
      {this.duration,
      this.amount,
      this.serviceType,
      this.subServiceId,
      this.subServiceTitle});

  ServiceData.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    amount = json['amount'];
    serviceType = json['serviceType'];
    subServiceId = json['subServiceId'];
    subServiceTitle = json['subServiceTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['serviceType'] = this.serviceType;
    data['subServiceId'] = this.subServiceId;
    data['subServiceTitle'] = this.subServiceTitle;
    return data;
  }
}
