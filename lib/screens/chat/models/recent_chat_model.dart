import 'package:hutano/screens/chat/models/seach_doctor_data.dart';

class RecentChatData {
  String status;
  List<SearchAppointment> response;

  RecentChatData({this.status, this.response});

  RecentChatData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = new List<SearchAppointment>();
      json['response'].forEach((v) {
        response.add(new SearchAppointment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

