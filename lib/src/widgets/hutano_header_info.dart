import 'package:flutter/material.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';

class HutanoHeaderInfo extends StatelessWidget {
  final String title;
  final String subTitle;
  final double subTitleFontSize;
  final bool showLogo;
  const HutanoHeaderInfo(
      {Key key,
      @required this.title,
      this.subTitle,
      this.showLogo = false,
      this.subTitleFontSize = fontSize13})
      : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLogo)
                Image.asset(
                  FileConstants.icLogoBlack,
                  height: 45,
                  width: 45,
                ),
              if (showLogo)
                SizedBox(
                  width: 10,
                ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: colorBlack85,
                    fontWeight: fontWeightBold,
                    fontSize: fontSize20),
              ),
            ],
          ),
          if (subTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: spacing7),
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subTitleFontSize,
                  color: colorBlack50,
                ),
              ),
            )
        ],
      ),
    );
  }
}
