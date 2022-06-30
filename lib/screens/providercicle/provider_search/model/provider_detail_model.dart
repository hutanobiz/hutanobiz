import 'dart:convert';

class ProviderDetail {
  final String? name;
  final String? rating;
  final String? occupation;
  final String? experience;
  final String? address;
  final String? miles;
  final String? fee;
  final String? image;
  final String? painType;
  ProviderDetail({
    this.name,
    this.rating,
    this.occupation,
    this.experience,
    this.painType,
    this.address,
    this.miles,
    this.fee,
    this.image,
  });


  ProviderDetail copyWith({
    String? name,
    String? rating,
    String? occupation,
    String? experience,
    String? address,
    String? miles,
    String? fee,
    String? image,
  }) {
    return ProviderDetail(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      occupation: occupation ?? this.occupation,
      experience: experience ?? this.experience,
      address: address ?? this.address,
      miles: miles ?? this.miles,
      fee: fee ?? this.fee,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'occupation': occupation,
      'experience': experience,
      'address': address,
      'miles': miles,
      'fee': fee,
      'image': image,
      'painType': painType,
    };
  }

  factory ProviderDetail.fromMap(Map<String, dynamic> map) {
   
    return ProviderDetail(
      name: map['name'],
      rating: map['rating'],
      occupation: map['occupation'],
      experience: map['experience'],
      address: map['address'],
      miles: map['miles'],
      fee: map['fee'],
      image: map['image'],
      painType: map['painType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProviderDetail.fromJson(String source) => ProviderDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProviderDetail(name: $name, rating: $rating, occupation: $occupation, experience: $experience, address: $address, miles: $miles, fee: $fee, image: $image)';
  }
}
