import 'package:flutter/material.dart';

import '../../../routes.dart';
import '../../apis/api_manager.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_header_info.dart';
import '../../widgets/hutano_steps_header.dart';
import '../../widgets/skip_later.dart';
import '../../widgets/toast.dart';
import '../registration_steps/email_verification/model/req_email.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: spacing30),
              HutanoHeaderInfo(
                showLogo: true,
                title: Localization.of(context).welcome,
                subTitle: Localization.of(context).accNowActive,
                subTitleFontSize: fontSize15,
              ),
              SizedBox(height: spacing30),
              Row(
                children: [
                  SizedBox(width: 35),
                  Image.asset(
                    FileConstants.icEdit,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      Localization.of(context).completeTask,
                      maxLines: 2,
                      style: const TextStyle(
                          color: colorBlack2,
                          fontFamily: gilroySemiBold,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spacing20,
              ),
              HutanoStepsHeader(
                title: Localization.of(context).activateEmail,
                subTitle: Localization.of(context).activateEmailDesc,
                iconText: stepOne,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                title: Localization.of(context).addPaymentOption,
                subTitle: Localization.of(context).addPaymentDesc,
                iconText: stepTwo,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                  title: Localization.of(context).addFamily,
                  subTitle: Localization.of(context).addFamilyDesc,
                  titleStyle: _getTitletStyle(),
                  subTitleStyle: _getSubTitletStyle(),
                  iconText: stepThree),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                title: Localization.of(context).addProvider,
                subTitle: Localization.of(context).addProviderDesc,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
                iconText: stepFour,
              ),
              SizedBox(
                height: spacing20,
              ),
              Spacer(),
              _buildCompleteTaskNowButton(context),
              SizedBox(
                height: spacing20,
              ),
              Container(
                alignment: Alignment.center,
                child: SkipLater(
                  onTap: _skipTaskNow,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getTitletStyle() {
    return TextStyle(
      color: colorBlack2,
      fontSize: fontSize15,
      fontWeight: FontWeight.w500,
      fontFamily: gilroyMedium,
      fontStyle: FontStyle.normal,
    );
  }

  _getSubTitletStyle() {
    return TextStyle(
        fontFamily: gilroyRegular,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: colorBlack2.withOpacity(0.85),
        fontSize: fontSize14);
  }

  _buildCompleteTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        isIconButton: true,
        icon: FileConstants.icDone,
        color: colorOrange,
        iconSize: spacing30,
        label: Localization.of(context).completeTaskNow,
        onPressed: _completeTaskNow,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: spacing20, right: spacing20, bottom: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        isIconButton: true,
        labelColor: colorBlack,
        iconSize: spacing20,
        color: Colors.transparent,
        icon: FileConstants.icSkipBlack,
        label: Localization.of(context).skipTasks,
        onPressed: _skipTaskNow,
      ));

  _completeTaskNow() {
    Navigator.of(context).pushReplacementNamed(routeEmailVerification);
    setBool(PreferenceKey.perFormedSteps, true);
    _sendCode();
  }

  _sendCode() async {
    try {
      await ApiManager().emailVerification(ReqEmail(step: 5)).then((value) {
        showToast(value.response);
      }).catchError((dynamic e) {
        if (e is ErrorModel) {
          if (e.response != null) {}
        }
      });
    } on ErrorModel catch (e) {}
  }

  _skipTaskNow() {
    setBool(PreferenceKey.skipStep, true);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false);
  }
}
