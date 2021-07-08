import 'package:flutter/material.dart';
import 'package:hutano/screens/registration/payment/utils/card_utils.dart';

class CreditCardProvider extends ChangeNotifier {
  CreditCardProvider();

  List<MyCreditCard> creditCardList = [];

  void add(MyCreditCard creditCard) {
    creditCardList.add(creditCard);
    notifyListeners();
  }
  getCreditCards() => creditCardList;
}

class MyCreditCard {
  String nameOnCard;
  String cardNumber;
  String expiryDate;
  String cvv;
  CardType type;
  String id;
  String customer;


  MyCreditCard(
      {this.nameOnCard = "",
      this.cardNumber = "",
      this.expiryDate,
      this.cvv,this.type=CardType.Others,
      this.customer="",
      this.id="",
      });
}


