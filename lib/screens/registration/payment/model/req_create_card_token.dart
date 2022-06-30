class ReqCreateCardToken{
  String? card_number;
  String? card_exp_month;
  String? card_exp_year;
  String? card_cvc;
  String? card_name;


  ReqCreateCardToken({this.card_number,this.card_exp_month,this.card_exp_year,this.card_cvc,this.card_name});
  ReqCreateCardToken.fromJson(Map<String, dynamic> json) {
    card_number = json['card[number]'];
    card_exp_month = json['card[exp_month]'];
    card_exp_year = json['card[exp_year]'];
    card_cvc = json['card[cvc]'];
    card_name = json['card[name]'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card[number]'] = this.card_number;
    data['card[exp_month]'] = this.card_exp_month;
    data['card[exp_year]'] = this.card_exp_year;
    data['card[cvc]'] = this.card_cvc;
    data['card[name]'] = this.card_name;


    return data;
  }
}