import 'package:hutano/src/ui/provider/search/model/family_member.dart';

class ResSearchNumber {
  String status;
  List<FamilyMember> response;
  int count;

  ResSearchNumber({this.status, this.response, this.count});

  ResSearchNumber.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <FamilyMember>[];
      json['response'].forEach((v) {
        response.add(FamilyMember.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}
