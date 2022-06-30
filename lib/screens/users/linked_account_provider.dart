import 'package:flutter/material.dart';
import 'package:hutano/screens/registration/payment/utils/card_utils.dart';

class LinkedAccountProvider extends ChangeNotifier {
  LinkedAccountProvider();

  List<dynamic>? linkedAccounts = [];

  void add(List<dynamic>? accounts) {
    linkedAccounts = accounts;
    notifyListeners();
  }

  getLinkedAccounts() => linkedAccounts;
}
