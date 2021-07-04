import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_header_info.dart';
import 'package:hutano/widgets/hutano_steps_header.dart';
import 'package:hutano/widgets/skip_later.dart';

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
          body: ListView(
            children: [
              SizedBox(height: 30),
              HutanoHeaderInfo(
                showLogo: true,
                title: Strings.welcome,
                subTitle: Strings.accNowActive,
                subTitleFontSize: 15,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 35),
                  Image.asset(
                    FileConstants.icWelcomeNote,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      Strings.completeTask,
                      maxLines: 2,
                      style: AppTextStyle.semiBoldStyle(
                          color: AppColors.colorBlack2,
                          fontSize:
                              (MediaQuery.of(context).devicePixelRatio > 2)
                                  ? 16
                                  : 13),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: (MediaQuery.of(context).devicePixelRatio > 2) ? 28 : 20,
              ),
              HutanoStepsHeader(
                title: Strings.activateEmail,
                subTitle: Strings.activateEmailDesc,
                iconText: Strings.stepOne,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                title: Strings.addPaymentOption,
                subTitle: Strings.addPaymentDesc,
                iconText: Strings.stepTwo,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                  title: Strings.addFamily,
                  subTitle: Strings.addFamilyDesc,
                  titleStyle: _getTitletStyle(),
                  subTitleStyle: _getSubTitletStyle(),
                  iconText: Strings.stepThree),
              SizedBox(
                height: 20,
              ),
              HutanoStepsHeader(
                title: Strings.addProvider,
                subTitle: Strings.addProviderDesc,
                titleStyle: _getTitletStyle(),
                subTitleStyle: _getSubTitletStyle(),
                iconText: Strings.stepFour,
              ),
              SizedBox(
                height: 20,
              ),
              Spacer(),
              _buildCompleteTaskNowButton(context),
              SizedBox(
                height: 20,
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
    return AppTextStyle.mediumStyle(
      color: AppColors.colorBlack2,
      fontSize: 15,
    );
  }

  _getSubTitletStyle() {
    return AppTextStyle.regularStyle(
        fontWeight: FontWeight.w400,
        color: AppColors.colorBlack2.withOpacity(0.85),
        fontSize: 14);
  }

  _buildCompleteTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        isIconButton: true,
        icon: FileConstants.icDone,
        color: AppColors.colorOrange,
        iconSize: 30,
        label: Strings.completeTaskNow,
        onPressed: _completeTaskNow,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        isIconButton: true,
        labelColor: AppColors.colorBlack,
        iconSize: 20,
        color: Colors.transparent,
        icon: FileConstants.icSkipBlack,
        label: Strings.skipTasks,
        onPressed: _skipTaskNow,
      ));

  _completeTaskNow() async {
    await SharedPref().setBoolValue('perFormedSteps', true);
    Navigator.of(context).pushNamed(Routes.verifyEmailOtpRoute);

    // _sendCode();
  }

  // _sendCode() async {
  //   try {
  //     await ApiManager().emailVerification(ReqEmail(step: 5)).then((value) {
  //       showToast(value.response);
  //     }).catchError((dynamic e) {
  //       if (e is ErrorModel) {
  //         if (e.response != null) {}
  //       }
  //     });
  //   } on ErrorModel catch (e) {}
  // }

  _skipTaskNow() async {
    await SharedPref().setBoolValue('skipStep', true);

    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.dashboardScreen,
      (Route<dynamic> route) => false,
      arguments: 0,
    );
  }
}
