import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/bottom_arrows.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/custom_back_button.dart';

class LoadingBackgroundNew extends StatelessWidget {
  LoadingBackgroundNew(
      {Key key,
      this.isLoading: false,
      @required this.title,
      this.isAddBack: true,
      this.padding,
      @required this.child,
      this.isAddAppBar: true,
      this.addBottomArrows: false,
      this.addBackButton: false,
      this.color: AppColors.snow,
      this.buttonColor = AppColors.goldenTainoi,
      this.onForwardTap,
      this.rightButtonText,
      this.onRightButtonTap,
      this.addHeader = false,
      this.addTitle = false,
      this.rightButton = false,
      this.onRButtonTap,
      this.isBackRequired = true,
      this.centerTitle = false,
      this.isSkipLater = false,
      this.onSkipForTap,
      this.isCameraVisible = false,
      this.onCameraForTap,
      this.notificationCount,
      this.onUpperBackTap})
      : super(key: key);

  final bool isLoading;
  final Widget child;
  final bool addHeader;
  final bool addTitle;
  final bool isAddBack;
  final String title, rightButtonText;
  final EdgeInsets padding;
  final bool isAddAppBar, addBottomArrows;
  final color;
  final bool addBackButton;
  final Function onForwardTap;
  final Color buttonColor;
  final Function onRightButtonTap;
  final bool rightButton;
  final Function onRButtonTap;
  final bool isBackRequired;
  final bool centerTitle;
  final bool isSkipLater;
  final Function onSkipForTap;
  final int notificationCount;
  final bool isCameraVisible;
  final Function onCameraForTap;
  final Function onUpperBackTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (addHeader)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isBackRequired)
                        CustomBackButton(
                          margin: const EdgeInsets.all(0),
                          size: 26,
                          onTap: onUpperBackTap,
                        ),
                      if (!addTitle) ...[
                        Spacer(),
                        Image.asset(
                          FileConstants.icHutanoHeader,
                          height: 30,
                          width: 90,
                        )
                      ] else ...[
                        centerTitle ? Spacer() : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(title,
                              style: const TextStyle(
                                  color: colorBlack2,
                                  fontWeight: fontWeightBold,
                                  fontSize: fontSize18),
                              textAlign: TextAlign.left),
                        )
                      ],
                      Spacer(),
                      rightButton
                          ? InkWell(
                              onTap:
                                  onRButtonTap != null ? onRButtonTap : () {},
                              child: Icon(Icons.add))
                          : InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.activityNotification);
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(spacing5),
                                    child: Image.asset(
                                      FileConstants.icNotification,
                                      height: 22,
                                      width: 22,
                                    ),
                                  ),
                                  (notificationCount ?? 0) > 0
                                      ? Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.red),
                                            child: Center(
                                              child: Text(
                                                '${notificationCount ?? "1"}',
                                                style:
                                                    AppTextStyle.semiBoldStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              (isAddAppBar && !addHeader)
                  ? Padding(
                      padding: isAddBack
                          ? const EdgeInsets.fromLTRB(11.0, 17.0, 0.0, 17.0)
                          : (rightButtonText != null &&
                                  onRightButtonTap != null)
                              ? const EdgeInsets.fromLTRB(21.0, 17.0, 0.0, 17.0)
                              : const EdgeInsets.fromLTRB(
                                  21.0, 27.0, 0.0, 27.0),
                      child: Row(
                        children: <Widget>[
                          isAddBack
                              ? InkWell(
                                  child: Image.asset(
                                      "assets/images/ic_back_arrow.png"),
                                  onTap: () => Navigator.pop(context),
                                )
                              : Container(),
                          isAddBack ? SizedBox(width: 10.0) : Container(),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (rightButtonText != null &&
                              onRightButtonTap != null)
                            InkWell(
                              onTap: onRightButtonTap,
                              child: rightButtonText.contains('do not')
                                  ? Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.windsor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        rightButtonText,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        rightButtonText,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                            )
                          else
                            Container(),
                        ],
                      ),
                    )
                  : Container(),
              Expanded(
                child: Container(
                    padding: padding ?? const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: color,
                    ),
                    child: child),
              ),
            ],
          ),
          isLoading ? CircularLoader() : Container(),
          addBackButton
              ? Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: ArrowButton(
                      iconData: Icons.arrow_back,
                      buttonColor: buttonColor,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                )
              : Container(),
          addBottomArrows
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: BottomArrows(
                      onForwardTap: onForwardTap,
                      isSkipLater: isSkipLater,
                      onSkipForTap: onSkipForTap,
                      isCameraVisible: isCameraVisible,
                      onCameraForTap: onCameraForTap),
                )
              : Container(),
        ],
      ),
    );
  }
}
