import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
      ),
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
