import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/skip_later.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/hutano_progressbar.dart';

class InviteFamilyScreen extends StatefulWidget {
  @override
  _InviteFamilyScreenState createState() => _InviteFamilyScreenState();
}

class _InviteFamilyScreenState extends State<InviteFamilyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    CustomBackButton(),
                  ],
                ),
                AppHeader(
                  progressSteps: HutanoProgressSteps.three,
                  title: Localization.of(context)!.inviteFamilyAndFriends,
                  subTitle: Localization.of(context)!.assignPermisstion,
                ),
                SizedBox(
                  height: spacing80,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.addFamilyMember);
                    },
                    child: _buildInviteText()),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SkipLater(
                        onTap: _skipTaskNow,
                      ),
                      Spacer(),
                      HutanoButton(
                        width: 55,
                        height: 55,
                        color: accentColor,
                        iconSize: 20,
                        buttonType: HutanoButtonType.onlyIcon,
                        icon: FileConstants.icForward,
                        onPressed: _skipTaskNow,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInviteText() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 56,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
            ),
            Image.asset(
              FileConstants.icInvite,
              height: 30,
              width: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Text(Localization.of(context)!.inviteByText,
                style: const TextStyle(
                    color: colorBlack2,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
            Spacer(),
            Image.asset(
              FileConstants.icNextBlack,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: colorGreyBorder, width: 0.5),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x148b8b8b),
                  offset: Offset(0, 2),
                  blurRadius: 30,
                  spreadRadius: 0)
            ],
            color: colorWhite));
  }

  _skipTaskNow() {
    Navigator.of(context)
        .pushReplacementNamed(Routes.myProviderNetwork, arguments: true);
  }
}
