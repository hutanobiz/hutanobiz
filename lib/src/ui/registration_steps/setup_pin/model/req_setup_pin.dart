

class ReqSetupPin {
  int step;
  String id;
  String pin;

  ReqSetupPin({this.step=7,this.id="",this.pin});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["_id"] = id;
    data["step"] = step;
    data["pin"]=pin;

    return data;
  }
}