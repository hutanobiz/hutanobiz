class ReqAddCard {
  String token ;

  ReqAddCard({this.token});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["token"] = token;

    return data;
  }
}