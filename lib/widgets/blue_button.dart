import 'package:flutter/widgets.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';


class BlueButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const BlueButton({
    Key key,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(title,
                style: const TextStyle(
                    color: colorWhite,
                    fontWeight: FontWeight.w400,
                    fontFamily: gilroyRegular,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.left),
            SizedBox(
              width: 7,
            ),
            Image.asset(
              FileConstants.icNext,
              height: 15,
              width: 15,
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: const Color(0x148b8b8b),
                offset: Offset(0, 2),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: colorDarkBlue2,
        ),
      ),
    );
  }
}
