import 'dart:convert';

class ReqAddPermission {
  final String id;
  final String userId;
  final int userRelation;
  final int step;
  final List<int> userPermissions;
  ReqAddPermission({
    this.id,
    this.userId,
    this.userRelation,
    this.step,
    this.userPermissions,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'userRelation': userRelation,
      'step': step,
      'userPermissions': userPermissions,
    };
  }

  factory ReqAddPermission.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqAddPermission(
      id: map['_id'],
      userId: map['userId'],
      userRelation: map['userRelation'],
      step: map['step'],
      userPermissions: List<int>.from(map['userPermissions']),
    );
  }

  String toJson() => json.encode(toMap());
}