import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hutano/src/utils/constants/key_constant.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';

import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dimens.dart';
import '../../utils/navigation.dart';
import '../../utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(color: colorYellow, child: _buildSplashIcon());
  }

  _startTime() async {
    var _duration = Duration(seconds: splashTime);
    return Timer(_duration, _gotoNextScreen);
  }

  void _gotoNextScreen() {
    SizeConfig().init(context);
    var emailVerified = getBool(PreferenceKey.isEmailVerified, false);
    var phone = getString(PreferenceKey.phone);
    var token = getString(PreferenceKey.tokens);
    var skipStep = getBool(PreferenceKey.skipStep, false);
    var performedStep = getBool(PreferenceKey.perFormedSteps, false);
    var isSetupPin = getBool(PreferenceKey.setPin, false);

    if (token.isNotEmpty) {
      if (skipStep || performedStep) {
        if (isSetupPin) {
          NavigationUtils.pushReplacement(context, routeLoginPin, arguments: {
            ArgumentConstant.number: phone,
          });
        } else {
          NavigationUtils.pushReplacement(context, routeHome);
        }
      } else if (!performedStep) {
        NavigationUtils.pushReplacement(context, routeWelcomeScreen);
      } else {
        NavigationUtils.pushReplacement(context, routeLogin);
      }
    } else {
      NavigationUtils.pushReplacement(context, routeLogin);
    }
  }

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  _buildSplashIcon() => Center(
          child: Image(
        image: AssetImage(FileConstants.icSplashLogo),
        width: spacing240,
      ));
}
