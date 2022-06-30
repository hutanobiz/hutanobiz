class ReqAddProvider {
  String? userId;
  String? doctorId;
  String? groupId;
  String? groupName;
  ReqAddProvider({
    this.userId,
    this.doctorId,
    this.groupId,
    this.groupName,
  });

  dynamic toMap() {
    return {
      'userId': userId,
      'doctorId': doctorId,
      'groupId': groupId,
      'groupName': groupName,
    };
  }

  factory ReqAddProvider.fromMap(Map<String, dynamic> map) {
    

    return ReqAddProvider(
      userId: map['userId'],
      doctorId: map['doctorId'],
      groupId: map['groupId'],
      groupName: map['groupName'],
    );
  }
}
