import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key key, @required this.isLoading, @required this.widget})
      : super(key: key);

  final bool isLoading;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          widget,
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }
}
