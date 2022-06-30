class ReqSearchNumber {
  String? searchByNumber;
  int? limit;
  int? page;
  int? skip;
  ReqSearchNumber({
    this.searchByNumber,
    this.limit,
    this.page,
    this.skip,
  });

  Map<String, dynamic> toMap() {
    return {
      'searchByNumber': searchByNumber,
      'limit': limit,
      'page': page,
      'skip': skip,
    };
  }

  factory ReqSearchNumber.fromMap(Map<String, dynamic> map) {
 
    return ReqSearchNumber(
      searchByNumber: map['searchByNumber'],
      limit: map['limit'],
      page: map['page'],
      skip: map['skip'],
    );
  }
}
