import 'dart:convert';

class FamilyMember {
  final String? name;
  final String? relation;
  final String? image;
  FamilyMember({
    this.name,
    this.relation,
    this.image,
  });
  bool isSelected = false;
  FamilyMember copyWith({
    String? name,
    String? relation,
    String? image,
  }) {
    return FamilyMember(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relation': relation,
      'image': image,
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
  

    return FamilyMember(
      name: map['name'],
      relation: map['relation'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyMember.fromJson(String source) =>
      FamilyMember.fromMap(json.decode(source));

  @override
  String toString() =>
      'FamilyMember(name: $name, relation: $relation, image: $image)';
}
