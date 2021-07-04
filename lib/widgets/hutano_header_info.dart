import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';


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
      this.subTitleFontSize = 13})
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
                  height: 35,
                  width: 35,
                ),
              if (showLogo)
                SizedBox(
                  width: 10,
                ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.boldStyle(
                    color: AppColors.colorBlack85,
                    fontSize: 20),
              ),
            ],
          ),
          if (subTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.colorBlack50,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
        ],
      ),
    );
  }
}
