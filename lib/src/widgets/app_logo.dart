import 'package:flutter/material.dart';
import '../utils/constants/file_constants.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top:15),
        child: Image.asset(FileConstants.icAppLogo, width: 150),
      ),
    );
  }
}
