import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/widgets/app_header.dart';
import 'package:hutano/src/widgets/hutano_button.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';
import 'package:hutano/src/widgets/round_success.dart';

class InviteFamilySuccess extends StatelessWidget {
  _nextClick(context) {
    Navigator.of(context).pushReplacementNamed(routeLogin);
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
                progressSteps: HutanoProgressSteps.one,
                title: Localization.of(context).inviteFamilyAndFriends,
                subTitle: Localization.of(context).taskComplete,
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
