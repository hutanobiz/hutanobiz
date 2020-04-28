import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key key, @required this.isLoading, @required this.child})
      : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          child,
          isLoading
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[200],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
