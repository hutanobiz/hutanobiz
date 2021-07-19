import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/loading_background_new.dart';

import '../colors.dart';

class ComingSoon extends StatelessWidget {
  final bool isBackRequired;
  final bool isFromUpload;
  ComingSoon({this.isBackRequired = false, this.isFromUpload = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: !isFromUpload,
        isBackRequired: isBackRequired,
        isAddAppBar: !isFromUpload,
        color: Colors.white,
        child: Center(
          child: Text(
            Localization.of(context).comingSoonLabel,
            style: TextStyle(
                color: primaryColor,
                fontSize: fontSize18,
                fontWeight: fontWeightSemiBold),
          ),
        ),
      ),
    );
  }
}
