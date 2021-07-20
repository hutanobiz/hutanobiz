import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/color_utils.dart';
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
      this.subTitlePadding = true,
      this.titleStyle,
      this.subTitleStyle})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 20, right: 20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: titleStyle ??
                        TextStyle(
                            color: colorBlack2,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize:
                                (MediaQuery.of(context).devicePixelRatio > 2)
                                    ? 15
                                    : 12),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (subTitle != null)
                  Padding(
                    padding: EdgeInsets.only(left: subTitlePadding ? 20 : 0),
                    child: Text(
                      subTitle,
                      style: subTitleStyle ??
                          TextStyle(
                            fontSize:
                                (MediaQuery.of(context).devicePixelRatio > 2)
                                    ? 13
                                    : 11,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: colorBlack2.withOpacity(0.85),
                          ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
