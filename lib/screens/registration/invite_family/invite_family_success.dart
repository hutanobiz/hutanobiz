import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';

class InviteFamilySuccess extends StatelessWidget {
  _nextClick(context) {
    Navigator.of(context)
        .pushReplacementNamed(Routes.loginRoute, arguments: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppHeader(
                title: Localization.of(context)!.inviteFamilyAndFriends,
                subTitle: Localization.of(context)!.taskComplete,
              ),
              Spacer(),
              RoundSuccess(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: HutanoButton(
                    width: 55,
                    height: 55,
                    color: accentColor,
                    iconSize: 20,
                    buttonType: HutanoButtonType.onlyIcon,
                    icon: FileConstants.icForward,
                    onPressed: () {
                      _nextClick(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
