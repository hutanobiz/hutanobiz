class Email {
  String name;
  String email;

  Email({this.name, this.email});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["name"] = name;
    data["email"] = email;
    return data;
  }
}