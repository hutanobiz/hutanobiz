import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';

class CustomCardView extends StatelessWidget {
  CustomCardView(
      {Key key,
      @required this.onTap,
      @required this.image,
      @required this.cardText,
      @required this.cardSubText,
      this.isSelected = false})
      : super(key: key);

  final Function onTap;
  final String image, cardText, cardSubText;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacing10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.goldenTainoi : null,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[200]),
      ),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: spacing5),
                  Text(
                    cardSubText,
                    style: TextStyle(
                      fontWeight: fontWeightRegular,
                      fontFamily: gilroyRegular,
                      fontSize: fontSize13,
                      color: colorBlack2,
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
