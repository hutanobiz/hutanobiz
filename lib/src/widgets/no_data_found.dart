import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  final String msg;

  const NoDataFound({Key key, this.msg = 'No Data Found.'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(msg);
  }
}
