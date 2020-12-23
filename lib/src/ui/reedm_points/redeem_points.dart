import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/src/ui/reedm_points/point_progress.dart';
import 'package:hutano/src/widgets/hutano_button.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';


class ReedomPointsScreen extends StatefulWidget {
  @override
  _ReedomPointsScreenState createState() => _ReedomPointsScreenState();
}

class _ReedomPointsScreenState extends State<ReedomPointsScreen> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: spacing70,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 15),
                    child: Image.asset(FileConstants.icInviteLogo, width: 160),
                  ),
                  Text(
                    Localization.of(context).inviteSent,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: colorBlack85,
                        fontWeight: fontWeightBold,
                        fontSize: fontSize20),
                  ),
                  SizedBox(height: spacing25,),
                  Text(
                    Localization.of(context).congratulations,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: colorBlack50, fontSize: fontSize13),
                  ),
                  SizedBox(height: spacing10,),
                  _buildPoints(),

                  ScreenProgress(points: (6.8).roundToDouble()*10,),
                  SizedBox(height: spacing20,),
                  _buildReedomPoints(context),
                  SizedBox(height: spacing50,),
                  _buildNextButton(context),
                  SizedBox(height: spacing40,),
                  _buildContinuePoints(context),
                  SizedBox(height: spacing40,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  _buildReedomPoints(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorReedom,
        width: 250,
        height: spacing40,
        iconSize: spacing30,
        fontSize: fontSize20,
        labelColor:colorWhite85,
        label: Localization.of(context).redeemPoints,
        onPressed: _nextClick,

      ));

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing25, right: spacing25),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icNext,
        color: colorDarkBlue,
        iconSize: spacing20,
        label: Localization.of(context).moreInvite,
        onPressed: _nextClick,

      ));


  _buildContinuePoints(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing30, right: spacing30),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorReedom,
        label: Localization.of(context).continueText,
        onPressed: true ? _continueButtonClick : null,
      ));


  _buildPoints()
  {
    double dollars = 6.80;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          r"$" "$dollars",
          textAlign: TextAlign.center,
          style:  TextStyle(
              color: colorBlack50,
              fontSize: fontSize20,fontWeight: fontWeightBold),
        ),
        Image.asset(FileConstants.icStar, width: spacing30)
      ],
    );
  }

   _nextClick() {
    print(((22.8).roundToDouble()*10));
  }

   _continueButtonClick() {
  }
}



