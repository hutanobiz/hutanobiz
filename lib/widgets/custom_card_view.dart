import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class CustomCardView extends StatelessWidget {
  CustomCardView(
      {Key key,
      @required this.onTap,
      @required this.image,
      @required this.cardText,
      this.fontWeight,
      this.widget})
      : super(key: key);

  final Function onTap;
  final String image, cardText;
  final FontWeight fontWeight;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[200]),
      ),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              child: Image(
                image: AssetImage(image),
                height: 64.0,
                width: 64.0,
              ),
            ),
            SizedBox(width: 23.0),
            Text(
              cardText,
              style: TextStyle(
                color: AppColors.midnight_express,
                fontWeight: fontWeight ?? FontWeight.normal,
              ),
            ),
            widget ?? Container(),
          ],
        ),
      ),
    );
  }
}
