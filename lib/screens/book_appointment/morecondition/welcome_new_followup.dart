import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class WelcomeNewFollowUp extends StatefulWidget {
  @override
  _WelcomeNewFollowUpState createState() => _WelcomeNewFollowUpState();
}

class _WelcomeNewFollowUpState extends State<WelcomeNewFollowUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "",
            addHeader: true,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeBackHeader(context),
                _commonListTileWidget(
                    context,
                    Localization.of(context)!.newHealthIssueHeader,
                    Localization.of(context)!.newEpisodeHeader,
                    FileConstants.icProviderOffice,
                    1),
                _commonListTileWidget(
                    context,
                    Localization.of(context)!.followUpAppointmentHeader,
                    Localization.of(context)!.followUpHeader,
                    FileConstants.icNotificationAppointments,
                    2),
              ],
            )));
  }

  Widget _welcomeBackHeader(BuildContext context) => Padding(
        padding:
            EdgeInsets.symmetric(vertical: spacing20, horizontal: spacing20),
        child: Text(
          "${Localization.of(context)!.welcomeBackHeader} ${getString(PreferenceKey.fullName, "")}!",
          style: AppTextStyle.boldStyle(
              color: Color(0xff0e1c2a),
              fontSize: 20,),
        ),
      );

  Widget _commonListTileWidget(BuildContext context, String header,
          String subHeader, String image, int number) =>
      InkWell(
        onTap: () {
          if (number == 1) {
            Navigator.of(context).pushNamed(Routes.routeMoreCondition);
          } else {
            Navigator.of(context).pushNamed(Routes.slectFollowUpToBook);
          }
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: spacing20, horizontal: spacing20),
          child: ListTile(
            leading: Image.asset(image, width: 55, height: 55),
            title: Text(header,
                style: TextStyle(
                    fontSize: fontSize16,
                    fontWeight: fontWeightSemiBold,
                    color: Colors.black)),
            subtitle: Text(subHeader,
                style: TextStyle(
                    fontSize: fontSize12,
                    fontWeight: fontWeightRegular,
                    color: colorBlack2)),
            trailing: Icon(Icons.arrow_forward_ios, color: colorBlack2),
          ),
        ),
      );
}
