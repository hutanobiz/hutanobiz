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

  Map toMap() {
    Map map = {};
    if (id != null) {
      map['id'] = id;
    }
    if (page != null) {
      map['page'] = page.toString();
    }
    if (limit != null) {
      map['limit'] = limit.toString();
    }
    if (search != null) {
      map['search'] = search;
    }
    return map;
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
