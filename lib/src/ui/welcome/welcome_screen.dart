import 'package:flutter/material.dart';
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/ui/registration_steps/email_verification/model/req_email.dart';
import 'package:hutano/src/utils/navigation.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/src/widgets/toast.dart';
import '../../utils/constants/constants.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_header.dart';
import '../../widgets/hutano_header_info.dart';
import '../../widgets/hutano_steps_header.dart';

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                HutanoHeader(
                  headerInfo: HutanoHeaderInfo(
                    title: Localization.of(context).welcome,
                    subTitle: Localization.of(context).accNowActive,
                    subTitleFontSize: fontSize15,
                  ),
                  spacing: spacing20,
                ),
                Text(
                  Localization.of(context).completeTask,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: colorBlack,
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize17),
                ),
                SizedBox(
                  height: spacing20,
                ),
                HutanoStepsHeader(
                  title: Localization.of(context).activateEmail,
                  subTitle: Localization.of(context).activateEmailDesc,
                  iconText: stepOne,
                ),
                HutanoStepsHeader(
                    title: Localization.of(context).addPaymentOption,
                    subTitle: Localization.of(context).addPaymentDesc,
                    iconText: stepTwo),
                HutanoStepsHeader(
                    title: Localization.of(context).addFamily,
                    subTitle: Localization.of(context).addFamilyDesc,
                    iconText: stepThree),
                HutanoStepsHeader(
                  title: Localization.of(context).addProvider,
                  subTitle: Localization.of(context).addProviderDesc,
                  iconText: stepFour,
                ),
                SizedBox(
                  height: spacing20,
                ),
                _buildCompleteTaskNowButton(context),
                SizedBox(
                  height: spacing20,
                ),
                _buildSkipTaskNowButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCompleteTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icDone,
        color: colorDarkBlue,
        iconSize: spacing30,
        label: Localization.of(context).completeTaskNow,
        onPressed: _completeTaskNow,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: spacing20, right: spacing20, bottom: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        iconSize: spacing20,
        color: colorYellow,
        icon: FileConstants.icSkip,
        label: Localization.of(context).skipTasks,
        onPressed: _skipTaskNow,
      ));

  _completeTaskNow() {
      NavigationUtils.pushReplacement(context, routeEmailVerification);
      setBool(PreferenceKey.perFormedSteps, true);
      _sendCode();

  }
  _sendCode() async {
    try {
      await ApiManager()
          .emailVerification(ReqEmail(step: 5))
          .then((value) {
        showToast(value.response);
      })
          .catchError((dynamic e) {
        if (e is ErrorModel) {
          if (e.response != null) {}
        }
      });
    } on ErrorModel catch (e) {}
  }

  _skipTaskNow() {
    NavigationUtils.pushAndRemoveUntil(context, routeHome);
    setBool(PreferenceKey.skipStep, true);
  }
}
