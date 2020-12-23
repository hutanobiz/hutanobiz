import 'package:hutano/src/ui/invite/model/email.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';

class ReqInvite {
  String phoneNumber;
  String mobileCountryCode;
  String message;
  List emailList;

  ReqInvite(
  {this.phoneNumber, this.mobileCountryCode="", this.message="", this.emailList});


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["mobileCountryCode"] = mobileCountryCode;
    data["phoneNumber"] = phoneNumber;
    data["message"] = message;
    data["emailList"] = emailList;
    return data;
  }
}