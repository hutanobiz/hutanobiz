import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class TrackingButton extends StatelessWidget {
  TrackingButton(
      {Key key,
      @required this.title,
      @required this.image,
      @required this.onTap})
      : super(key: key);
  String title, image;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        child: Row(
          children: [
            Image.asset(
              image,
              width: 17,
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                  color: AppColors.windsor, fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }
}
