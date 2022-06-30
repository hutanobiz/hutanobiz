class MessagesData {
  String? status;
  List<Message>? response;

  MessagesData({this.status, this.response});

  MessagesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Message>[];
      json['response'].forEach((v) {
        response!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? message;
  String? sId;
  String? sender;
  String? receiver;
  String? appointmentId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Message(
      {this.message,
      this.sId,
      this.sender,
      this.receiver,
      this.appointmentId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sId = json['_id'];
    sender = json['sender'];
    receiver = json['receiver'];
    appointmentId = json['appointmentId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    // data['_id'] = this.sId;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['appointmentId'] = this.appointmentId;
    // data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    return data;
  }
}
