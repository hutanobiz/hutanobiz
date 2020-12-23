import 'package:flutter/material.dart';
import 'package:hutano/src/ui/registration_steps/payment/utils/card_utils.dart';

class CreditCardProvider extends ChangeNotifier {
  CreditCardProvider();

  List<CreditCard> creditCardList = [];

  void add(CreditCard creditCard) {
    creditCardList.add(creditCard);
    notifyListeners();
  }
  getCreditCards() => creditCardList;
}

class CreditCard {
  String nameOnCard;
  String cardNumber;
  String expiryDate;
  String cvv;
  CardType type;
  String id;
  String customer;


  CreditCard(
      {this.nameOnCard = "",
      this.cardNumber = "",
      this.expiryDate,
      this.cvv,this.type=CardType.Others,
      this.customer="",
      this.id="",
      });
}


