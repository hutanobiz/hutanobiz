import 'package:flutter/material.dart';

class HealthConditionProvider extends ChangeNotifier {
  List<int> healthConditions = [];

  void updateHealthConditions(List<int> list) {
    healthConditions = list;
    notifyListeners();
  }
}
