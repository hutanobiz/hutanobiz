class ReqAddCurrentMedicalHistory {
  String? description;
  List<String?>? chiefComplaint;
  String? problem;
  String? rateDiscomfort;

  ReqAddCurrentMedicalHistory(
      {this.description,
      this.chiefComplaint,
      this.problem,
      this.rateDiscomfort});

  ReqAddCurrentMedicalHistory.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    chiefComplaint = json['chiefComplaint'].cast<String>();
    problem = json['problem'];
    rateDiscomfort = json['rateDiscomfort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['chiefComplaint'] = this.chiefComplaint;
    data['problem'] = this.problem;
    data['rateDiscomfort'] = this.rateDiscomfort;
    return data;
  }
}
