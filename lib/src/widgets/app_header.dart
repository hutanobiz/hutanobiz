import 'package:flutter/widgets.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/widgets/hutano_header_info.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/app_logo.dart';

class AppHeader extends StatelessWidget {
  final HutanoProgressSteps progressSteps;
  final String title;
  final String subTitle;
  final double margin;

  const AppHeader(
      {Key key, this.margin, this.progressSteps, this.title, this.subTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: margin ?? 40,
        ),
        const AppLogo(),
        const SizedBox(
          height: 5,
        ),
        if (progressSteps != null)
          HutanoProgressBar(progressSteps: progressSteps),
        const SizedBox(
          height: 15,
        ),
        if (title != null && subTitle != null)
          HutanoHeaderInfo(
            title: title,
            showLogo: false,
            subTitle: subTitle,
            subTitleFontSize: fontSize15,
          ),
      ],
    );
  }
}
