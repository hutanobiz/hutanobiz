import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
        'title': Strings.introTitle1,
        'subTitle': Strings.introSubTitle1,
        'image': 'images/ic_intro1.png',
      },
      {
        'title': Strings.introTitle2,
        'subTitle': Strings.introSubTitle2,
        'image': 'images/ic_intro2.png',
      },
      {
        'title': Strings.introTitle3,
        'subTitle': Strings.introSubTitle3,
        'image': 'images/ic_intro3.png',
      },
      {
        'title': Strings.introTitle4,
        'subTitle': Strings.introSubTitle4,
        'image': 'images/ic_intro4.png',
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
    await SharedPref().setBoolValue('isIntro', true);
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
                color: AppColors.colorDarkYellow2,
                label: Strings.start,
                margin: 20,
              )
            : Text(Strings.swipeLeft,
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumStyle(
                  color: AppColors.colorLightGrey3,
                  fontSize: 17,
                )),
        SizedBox(
          height: 35,
        ),
        Image.asset(
          'images/ic_logo_black.png',
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
              Strings.skip,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.colorBlue2,
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
                      skip: Text(Strings.swipeLeft),
                      done: const SizedBox(),
                      onChange: (i) {
                        setState(() {
                          _pagePosition = i;
                        });
                      },
                      dotsDecorator: DotsDecorator(
                        size: Size(8, 8),
                        color: AppColors.colorLightYellow2,
                        activeColor: AppColors.colorDarkYellow2,
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
              style: AppTextStyle.mediumStyle(
                color: Colors.black,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(item["subTitle"],
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumStyle(
                  color: AppColors.colorLightBlack3,
                  fontSize: 14,
                )),
            SizedBox(
              height: 24,
            ),
            _buildImage(item["image"])
          ],
        ),
        titleWidget: Container());
  }
}
