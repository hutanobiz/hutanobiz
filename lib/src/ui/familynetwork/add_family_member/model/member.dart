import 'dart:convert';

class Member {
  final String name;
  final String relation;
  final String image;
  final String number;
  Member({
    this.name,
    this.relation,
    this.image,
    this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relation': relation,
      'image': image,
      'number': number,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Member(
      name: map['name'],
      relation: map['relation'],
      image: map['image'],
      number: map['number'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));
}
