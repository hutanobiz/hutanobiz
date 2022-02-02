import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/round_success.dart';

class InviteFamilyComplete extends StatefulWidget {
  @override
  _InviteFamilyCompleteState createState() => _InviteFamilyCompleteState();
}

class _InviteFamilyCompleteState extends State<InviteFamilyComplete> {
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
                progressSteps: HutanoProgressSteps.three,
                title: "Invite Family and Friends",
                subTitle: Localization.of(context).taskComplete,
              ),
              Spacer(),
              RoundSuccess(),
              Spacer(),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
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
          onPressed: () async {
            Navigator.of(context).pushNamed(Routes.myProviderNetwork ,arguments: true);
          },
        ),
      ),
    );
  }
}
