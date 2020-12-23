import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/preference_utils.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/ripple_effect.dart';
import '../../widgets/text_with_image.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(),
          Spacer(),
          RippleEffect(
            onTap: () async {
              clear().then((value) {
                NavigationUtils.pushAndRemoveUntil(context, routeLogin);
              });
            },
            child: IntrinsicWidth(
              child: TextWithImage(
                image: FileConstants.icLogout,
                label: Localization.of(context).logout,
                textStyle: TextStyle(color: colorYellow),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
