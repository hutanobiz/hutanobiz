class ProviderNetwork {
  String? groupName;
  List<String>? doctorId;
  String? sId;
  bool isSelected=false;

  ProviderNetwork({this.groupName, this.doctorId, this.sId});

  ProviderNetwork.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    doctorId = json['doctorId'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['doctorId'] = this.doctorId;
    data['_id'] = this.sId;
    return data;
  }
}
