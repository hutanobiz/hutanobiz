import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:hutano/utils/color_utils.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  List _pageContnet = [];
  int _pagePosition = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _addContent());
    super.initState();
  }

  _addContent() {
    _pageContnet = [
      {
        'title': Localization.of(context).introTitle1,
        'subTitle': Localization.of(context).introSubTitle1,
        'image': FileConstants.icIntro1
      },
      {
        'title': Localization.of(context).introTitle2,
        'subTitle': Localization.of(context).introSubTitle2,
        'image': FileConstants.icIntro2
      },
      {
        'title': Localization.of(context).introTitle3,
        'subTitle': Localization.of(context).introSubTitle3,
        'image': FileConstants.icIntro3
      },
      {
        'title': Localization.of(context).introTitle4,
        'subTitle': Localization.of(context).introSubTitle4,
        'image': FileConstants.icIntro4
      }
    ];
    setState(() {});
  }

  Widget _buildImage(assetName) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Align(
      child: Image.asset(assetName,
          height: MediaQuery.of(context).size.width / (1.8),
          width: MediaQuery.of(context).size.width / (1.8)),
      alignment: Alignment.center,
    );
  }

  _goToLogin() async {
    await setBool(PreferenceKey.intro, true);
    Navigator.pushReplacementNamed(context, Routes.loginRoute,
        arguments: false);
  }

  _bottomDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 10,
        ),
        (_pagePosition == _pageContnet.length - 1)
            ? HutanoButton(
                onPressed: _goToLogin,
                color: colorDarkYellow2,
                label: Localization.of(context).start,
                margin: 20,
              )
            : Text(Localization.of(context).swipeLeft,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorLightGrey3,
                    fontFamily: poppins,
                    fontSize: 17,
                    fontWeight: fontWeightMedium)),
        SizedBox(
          height: 35,
        ),
        Image.asset(
          FileConstants.icLogoBlack,
          height: 30,
          width: 30,
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  _topDetail() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _goToLogin,
            child: Text(
              Localization.of(context).skip,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorBlue2,
                fontFamily: poppins,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topDetail(),
            Expanded(
              child: _pageContnet.length == 0
                  ? Container()
                  : IntroductionScreen(
                      key: introKey,
                      pages:
                          _pageContnet.map((item) => _buildPage(item)).toList(),
                      onDone: () => {},
                      showSkipButton: false,
                      skipFlex: 0,
                      nextFlex: 0,
                      globalBackgroundColor: Colors.white,
                      skip: Text(Localization.of(context).swipeLeft),
                      done: const SizedBox(),
                      onChange: (i) {
                        setState(() {
                          _pagePosition = i;
                        });
                      },
                      dotsDecorator: const DotsDecorator(
                        size: Size(8, 8),
                        color: colorLightYellow2,
                        activeColor: colorDarkYellow2,
                        activeSize: Size(8, 8),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                    ),
            ),
            _bottomDetail(),
          ],
        ),
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children:  children2,
        // ),
      ),
    );
  }

  PageViewModel _buildPage(item) {
    return PageViewModel(
        bodyWidget: Column(
          children: [
            Text(
              item["title"],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: poppins,
                  fontSize: 28,
                  fontWeight: fontWeightMedium),
            ),
            SizedBox(
              height: 10,
            ),
            Text(item["subTitle"],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorLightBlack3,
                    fontFamily: poppins,
                    fontSize: 14,
                    fontWeight: fontWeightMedium)),
            SizedBox(
              height: 24,
            ),
            _buildImage(item["image"])
          ],
        ),
        titleWidget: Container());
  }
}
