// adding referaal code when redirecting from branch io only for current session

class Referral {
  static final Referral _singleton = Referral._internal();

  factory Referral() {
    return _singleton;
  }

  Referral._internal();

  String _referralCode = "";
  String get referralCode => _referralCode;
  set referralCode(code) {
    _referralCode = code;
  }
}
