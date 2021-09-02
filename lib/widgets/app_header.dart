import 'package:flutter/widgets.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/hutano_header_info.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';

class AppHeader extends StatelessWidget {
  final HutanoProgressSteps progressSteps;
  final String title;
  final String subTitle;
  final double margin;
  final bool isFromTab;
  final bool isAppLogoVisible;

  const AppHeader(
      {Key key,
      this.margin,
      this.progressSteps,
      this.title,
      this.subTitle,
      this.isFromTab = false,
      this.isAppLogoVisible = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAppLogoVisible)
          SizedBox(
            height: margin ?? 20,
          ),
        isAppLogoVisible ? const AppLogo() : SizedBox(),
        const SizedBox(
          height: 5,
        ),
        if (progressSteps != null)
          if (!isFromTab) HutanoProgressBar(progressSteps: progressSteps),
        const SizedBox(
          height: 15,
        ),
        if (title != null && subTitle != null)
          HutanoHeaderInfo(
            title: title,
            showLogo: false,
            subTitle: subTitle,
            subTitleFontSize: 15,
          ),
      ],
    );
  }
}
