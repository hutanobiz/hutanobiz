class Services {
  String userId;
  String serviceId;
  String subServiceId;
  int duration;
  dynamic amount;
  String sId;
  int iV;
  String serviceName;
  String subServiceName;
  bool isSelected = false;

  Services(
      {this.userId,
      this.serviceId,
      this.subServiceId,
      this.duration,
      this.amount,
      this.sId,
      this.iV,
      this.serviceName,
      this.subServiceName});

  Services.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    serviceId = json['serviceId'];
    subServiceId = json['subServiceId'];
    duration = json['duration'];
    amount = json['amount'];
    sId = json['_id'];
    iV = json['__v'];
    serviceName = json['serviceName'];
    subServiceName = json['subServiceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['serviceId'] = this.serviceId;
    data['subServiceId'] = this.subServiceId;
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['serviceName'] = this.serviceName;
    data['subServiceName'] = this.subServiceName;
    return data;
  }
}
