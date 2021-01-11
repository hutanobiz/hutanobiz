import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';

class RoundSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 1.0,
              color: colorBorder2.withOpacity(0.1),
              style: BorderStyle.solid),
          color: accentColor,
        ),
        child: Image.asset(FileConstants.icDonePurple, width: 35, height: 35));
  }
}
