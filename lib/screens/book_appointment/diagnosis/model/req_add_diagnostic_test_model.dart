class ReqAddDiagnosticTestModel {
  String? diagnosticTests;
  List<LongAgo>? longAgo;

  ReqAddDiagnosticTestModel({this.diagnosticTests, this.longAgo});

  ReqAddDiagnosticTestModel.fromJson(Map<String, dynamic> json) {
    diagnosticTests = json['diagnosticTests'];
    if (json['longAgo'] != null) {
      longAgo = <LongAgo>[];
      json['longAgo'].forEach((v) {
        longAgo!.add(new LongAgo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diagnosticTests'] = this.diagnosticTests;
    if (this.longAgo != null) {
      data['longAgo'] = this.longAgo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LongAgo {
  String? name;

  LongAgo({this.name});

  LongAgo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
