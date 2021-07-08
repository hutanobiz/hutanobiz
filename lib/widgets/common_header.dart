import 'package:flutter/material.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/custom_back_button.dart';

class CommonHeader extends StatelessWidget {
  final bool showBack;
  final Color backgroundColor;

  const CommonHeader({
    Key key,
    this.showBack = false,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showBack)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CustomBackButton(
                margin: const EdgeInsets.all(0),
                size: 26,
              ),
            ),
          Spacer(),
          Image.asset(
            FileConstants.icHutanoHeader,
            height: 30,
            width: 90,
          ),
          Spacer(),
          Image.asset(
            FileConstants.icNotification,
            height: 22,
            width: 22,
          ),
        ],
      ),
    );
  }
}
