import 'package:flutter/material.dart';
import 'package:hutano/widgets/circular_loader.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key, required this.isLoading, required this.child})
      : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          child,
          isLoading ? CircularLoader() : Container(),
        ],
      ),
    );
  }
}
