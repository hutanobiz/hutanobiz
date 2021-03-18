import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';

class RoundSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      FileConstants.icSuccessCheck,
      width: 110,
      height: 110,
    );
  }
}
