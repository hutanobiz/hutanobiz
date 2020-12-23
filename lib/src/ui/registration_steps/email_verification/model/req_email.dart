class ReqEmail {
  int step;
  String emailVerificationCode;

  ReqEmail({this.step,this.emailVerificationCode});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["step"] = step;
    if(emailVerificationCode!=null)
    data["emailVerificationCode"] = emailVerificationCode;
    return data;
  }
}
