import 'package:flutter/material.dart';

class RippleEffect extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;

  const RippleEffect({Key? key, this.onTap, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(onTap: onTap, child: child),
    );
  }
}
