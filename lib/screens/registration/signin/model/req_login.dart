
class ReqLogin {
  int type;
  String phoneNumber;
  String password;
  String? deviceToken;
  String mobileCountryCode;

  ReqLogin({this.type=1,
    this.phoneNumber="", this.password="", this.deviceToken="",
    this.mobileCountryCode=""});
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["type"] = type;
    data["phoneNumber"] = phoneNumber;
    data["password"] = password;
    data["deviceToken"] = deviceToken;
    data["mobileCountryCode"]=mobileCountryCode;
    return data;
  }
}
