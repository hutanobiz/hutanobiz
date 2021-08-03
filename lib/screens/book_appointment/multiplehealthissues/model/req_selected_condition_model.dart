class ReqSelectConditionModel {
  List<String> problemIds;

  ReqSelectConditionModel({this.problemIds});

  ReqSelectConditionModel.fromJson(Map<String, dynamic> json) {
    problemIds = json['problemIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemIds'] = this.problemIds;
    return data;
  }
}