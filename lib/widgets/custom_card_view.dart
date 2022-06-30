import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';

class CustomCardView extends StatelessWidget {
  CustomCardView(
      {Key? key,
      required this.onTap,
      required this.image,
      required this.cardText,
      required this.cardSubText,
      this.isSelected = false,
      this.isEnabled = true})
      : super(key: key);

  final Function? onTap;
  final String image, cardText, cardSubText;
  final bool isSelected, isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacing10),
      decoration: BoxDecoration(
        color:  isSelected
                ? AppColors.goldenTainoi
                : null
            ,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border:
             Border.all(color: isEnabled?Colors.grey[200]!:Colors.grey[50]!),
      ),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap as void Function()?,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: spacing10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardText,
                    style: TextStyle(
                      fontWeight: fontWeightSemiBold,
                      fontSize: fontSize16,
                      color: isEnabled? Colors.black:Colors.grey,
                    ),
                  ),
                  SizedBox(height: spacing5),
                  Text(
                    cardSubText,
                    style: TextStyle(
                      fontWeight: fontWeightRegular,
                      fontFamily: gilroyRegular,
                      fontSize: fontSize13,
                      color: isEnabled? Colors.black:Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              child: Image(
                image: AssetImage(image),
                height: 64.0,
                width: 64.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
