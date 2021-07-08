import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';

class HutanoCheckBox extends StatelessWidget {
  final bool isChecked;
  final Function onValueChange;

  const HutanoCheckBox(
      {@required this.isChecked, @required this.onValueChange});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onValueChange != null) onValueChange(!isChecked);
      },
      child: Container(
        height: 20,
        width: 20,
        child: isChecked ? Image.asset(FileConstants.icCheck) : Container(),
        decoration: BoxDecoration(
          image: null,
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(width: 0.4, color: colorLightGrey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 1),
                color: colorLightGrey.withOpacity(0.2))
          ],
        ),
      ),
    );
  }
}
