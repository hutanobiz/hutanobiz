class ReqFamilyNetwork {
  final String id;
  final int page;
  final int limit;
  final String search;

  ReqFamilyNetwork({
    this.id,
    this.page,
    this.limit,
    this.search,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'page': page,
      'limit': limit,
      'search': search,
    };
  }

  factory ReqFamilyNetwork.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return ReqFamilyNetwork(
      id: map['_id'],
      page: map['page'],
      limit: map['limit'],
      search: map['search'],
    );
  }
}
