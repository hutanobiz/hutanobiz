class ReqRemoveProvider {
  final String? groupId;
  final String? doctorId;
  final String? userId;
  ReqRemoveProvider({
    this.groupId,
    this.doctorId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'doctorId': doctorId,
      'userId': userId,
    };
  }

  factory ReqRemoveProvider.fromMap(Map<String, dynamic> map) {
 
    return ReqRemoveProvider(
      groupId: map['groupId'],
      doctorId: map['doctorId'],
      userId: map['userId'],
    );
  }
}
