class ReqCommunicationReasonModel {
  String? description;
  List<String>? reasonIds;

  ReqCommunicationReasonModel({this.description, this.reasonIds});

  ReqCommunicationReasonModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    reasonIds = json['reasonIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['reasonIds'] = this.reasonIds;
    return data;
  }
}
