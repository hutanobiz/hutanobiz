import 'dart:convert';

class Appointment {
  final String name;
  final String image;
  final String rating;
  final String memberSince;
  final String painType;
  final String appointmentType;
  final String appointmentTime;
  Appointment({
    this.name,
    this.image,
    this.rating,
    this.memberSince,
    this.painType,
    this.appointmentType,
    this.appointmentTime,
  });

  Appointment copyWith({
    String name,
    String image,
    String rating,
    String memberSince,
    String painType,
    String appointmentType,
    String appointmentTime,
  }) {
    return Appointment(
      name: name ?? this.name,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      memberSince: memberSince ?? this.memberSince,
      painType: painType ?? this.painType,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentTime: appointmentTime ?? this.appointmentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'memberSince': memberSince,
      'painType': painType,
      'appointmentType': appointmentType,
      'appointmentTime': appointmentTime,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Appointment(
      name: map['name'],
      image: map['image'],
      rating: map['rating'],
      memberSince: map['memberSince'],
      painType: map['painType'],
      appointmentType: map['appointmentType'],
      appointmentTime: map['appointmentTime'],
    );
  }

  String toJson() => json.encode(toMap());
}
