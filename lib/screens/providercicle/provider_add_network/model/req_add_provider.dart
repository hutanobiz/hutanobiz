class ReqAddProvider {
  String userId;
  String doctorId;
  String groupId;
  String groupName;
  ReqAddProvider({
    this.userId,
    this.doctorId,
    this.groupId,
    this.groupName,
  });

  dynamic toMap() {
    var map = {};
    if (userId != null) {
      map['userId'] = userId;
    }
    if (doctorId != null) {
      map['doctorId'] = doctorId;
    }
    if (groupId != null) {
      map['groupId'] = groupId;
    }
    if (groupName != null) {
      map['groupName'] = groupName;
    }
    // return {
    //   'userId': userId,
    //   'doctorId': doctorId,
    //   'groupId': groupId,
    //   'groupName': groupName,
    // };
    return map;
  }

  factory ReqAddProvider.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqAddProvider(
      userId: map['userId'],
      doctorId: map['doctorId'],
      groupId: map['groupId'],
      groupName: map['groupName'],
    );
  }
}
