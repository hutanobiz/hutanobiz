import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';

class AddProviderComplete extends StatefulWidget {
  AddProviderComplete();

  @override
  AddProviderCompleteState createState() => AddProviderCompleteState();
}

class AddProviderCompleteState extends State<AddProviderComplete> {
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
                progressSteps: HutanoProgressSteps.four,
                title: "My Providers",
                subTitle: "Proivders added",
              ),
              Spacer(),
              RoundSuccess(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.dashboardScreen,
                          (Route<dynamic> route) => false,
                          arguments: 0);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: spacing20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
