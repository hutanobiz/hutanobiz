class ReqAddMember {
  final String id;
  final String userId;
  final int userRelation;
  final int step;
  
  ReqAddMember({
    this.id,
    this.userId,
    this.userRelation,
    this.step,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'userRelation': userRelation,
      'step': step,
    };
  }

  factory ReqAddMember.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqAddMember(
      id: map['_id'],
      userId: map['userId'],
      userRelation: map['userRelation'],
      step: map['step'],
    );
  }
}
