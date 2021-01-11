import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';
import 'hutano_round_button.dart';

class HutanoStepsHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isIcon;
  final String iconText;
  final String icon;
  final double iconSize;
  final Color bgColor;
  final Color borderColor;
  final CrossAxisAlignment alignment;
  final bool subTitlePadding;
  final TextStyle titleStyle;
  final TextStyle subTitleStyle;

  const HutanoStepsHeader(
      {Key key,
      @required this.title,
      this.subTitle,
      this.iconText = "",
      this.isIcon = false,
      this.icon,
      this.iconSize,
      this.bgColor,
      this.borderColor,
      this.alignment = CrossAxisAlignment.start,
      this.subTitlePadding = true, this.titleStyle, this.subTitleStyle})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: spacing30),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: HutanoRoundButton(
              borderColor: borderColor,
              bgColor: bgColor,
              isIcon: isIcon,
              iconText: iconText,
              icon: icon,
              iconSize: iconSize,
            ),
          ),
          Column(
            crossAxisAlignment: alignment,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: titleStyle ??const TextStyle(
                      color: colorDarkBlack,
                      fontWeight: fontWeightSemiBold,
                      fontSize: fontSize18),
                ),
              ),
              SizedBox(height: 5,),
              if (subTitle != null)
                Padding(
                  padding: EdgeInsets.only(left: subTitlePadding ? 20 : 0),
                  child: Container(
                    child: Text(
                      subTitle,
                      style:subTitleStyle ?? const TextStyle(
                        fontWeight: fontWeightSemiBold,
                        fontSize: fontSize10,
                        color: colorLightGrey,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
