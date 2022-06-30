import 'dart:convert';
import '../../provider_search/model/provider_detail_model.dart';

class ProviderGroup {
  final String? image;
  final String? groupType;
  final int? count;
  final List<ProviderDetail>? list;
  ProviderGroup({
    this.image,
    this.groupType,
    this.count,
    this.list,
  });

  ProviderGroup copyWith({
    String? image,
    String? groupType,
    int? count,
    List<ProviderDetail>? list,
  }) {
    return ProviderGroup(
      image: image ?? this.image,
      groupType: groupType ?? this.groupType,
      count: count ?? this.count,
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'groupType': groupType,
      'count': count,
      'list': list?.map((x) => x.toMap()).toList(),
    };
  }

  factory ProviderGroup.fromMap(Map<String, dynamic> map) {
    return ProviderGroup(
      image: map['image'],
      groupType: map['groupType'],
      count: map['count'],
      list: List<ProviderDetail>.from(
          map['list']?.map((x) => ProviderDetail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());
}
