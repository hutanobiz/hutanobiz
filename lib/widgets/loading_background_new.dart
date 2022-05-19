import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/users/linked_account_provider.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/bottom_arrows.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:provider/provider.dart';

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
      this.onUpperBackTap,
      this.showUserPicture: false})
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
  final bool showUserPicture;

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
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: showUserPicture ? 11 : 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showUserPicture)
                        GestureDetector(
                          onTap: () {
                            return showUsersDialog(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              ApiBaseHelper.imageUrl +
                                  json.decode(
                                      getString('selectedAccount'))['avatar'],
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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

  showUsersDialog(BuildContext context) async {
    showDialog<void>(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: new Container(
                color: Colors.black.withOpacity(.5),
                // height: 100,
                // width: 100,
                // color: Colors.transparent,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 17),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount:
                      Provider.of<LinkedAccountProvider>(context, listen: true)
                          .getLinkedAccounts()
                          .length,
                  itemBuilder: (context, index) {
                    return index ==
                            Provider.of<LinkedAccountProvider>(context,
                                        listen: false)
                                    .getLinkedAccounts()
                                    .length -
                                1
                        ? GestureDetector(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 20),
                                Container(
                                    height: 40,
                                    width: 40,
                                    // padding: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.green,
                                      // border: Border.all(color: Colors.grey)
                                    ),
                                    child: Icon(Icons.add,
                                        color: Colors.white, size: 40)),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  child: Text('Add/Link New',
                                      style: AppTextStyle.mediumStyle(
                                          fontSize: 16,
                                          color: AppColors.windsor)),
                                )
                              ],
                            ),
                            onTap: () {
                              // Navigator.pop(context);
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: AppColors.snow,
                                  isScrollControlled: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  builder: (ctx) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 6,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: colorGrey,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: FancyButton(
                                                title: 'Add Account',
                                                onPressed: () {
                                                  return Navigator.pushNamed(
                                                      context,
                                                      Routes.addNewUserType);
                                                }),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 0, 20, 30.0),
                                              child: FancyButton(
                                                title: 'Link Account',
                                                buttonColor: Colors.white,
                                                textColor: AppColors.windsor,
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      Routes.linkNumber);
                                                },
                                              ))
                                        ],
                                      ));
                            },
                          )
                        : GestureDetector(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 20),
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                        ApiBaseHelper.imageUrl +
                                            (index == 0
                                                ? Provider.of<LinkedAccountProvider>(
                                                            context,
                                                            listen: false)
                                                        .linkedAccounts[index]
                                                    ['avatar']
                                                : Provider.of<LinkedAccountProvider>(
                                                                    context,
                                                                    listen: false)
                                                                .linkedAccounts[
                                                            index]['linkToAccount']
                                                        ['avatar'] ??
                                                    ''),
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  child: Text(
                                      (index == 0
                                          ? Provider.of<LinkedAccountProvider>(
                                                  context,
                                                  listen: false)
                                              .linkedAccounts[index]['fullName']
                                          : Provider.of<LinkedAccountProvider>(
                                                      context,
                                                      listen: false)
                                                  .linkedAccounts[index]
                                              ['linkToAccount']['fullName']),
                                      style: AppTextStyle.mediumStyle(
                                          fontSize: 16,
                                          color: AppColors.windsor)),
                                ),
                                // (index == 0
                                //             ? Provider.of<LinkedAccountProvider>(context, listen: false)
                                //                 .linkedAccounts[index]['_id']
                                //             : Provider.of<LinkedAccountProvider>(context, listen: false)
                                //                     .linkedAccounts[index]
                                //                 ['linkToAccount']['_id']) ==
                                //         json.decode(
                                //             getString('selectedAccount'))['_id']
                                //     ? Padding(
                                //         padding:
                                //             const EdgeInsets.only(right: 16.0),
                                //         child: Icon(
                                //           Icons.check_circle,
                                //           color: AppColors.windsor,
                                //           size: 24,
                                //         ),
                                //       )
                                //     : (index != 0 &&
                                //             Provider.of<LinkedAccountProvider>(context, listen: false)
                                //                         .linkedAccounts[index]
                                //                     ['whom'] ==
                                //                 2 &&
                                //             (Provider.of<LinkedAccountProvider>(context, listen: false).linkedAccounts[index]
                                //                         ['isOtpVerified'] ==
                                //                     null ||
                                //                 Provider.of<LinkedAccountProvider>(context, listen: false).linkedAccounts[index]['isOtpVerified'] != 1))
                                //         ? Padding(
                                //             padding: const EdgeInsets.only(
                                //                 right: 16.0),
                                //             child: Icon(
                                //               Icons.error_outline_rounded,
                                //               color: AppColors.goldenTainoi,
                                //               size: 24,
                                //             ),
                                //           )
                                //         : SizedBox(),
                              ],
                            ),
                            onTap: () async {
                              if (index != 0 &&
                                  Provider.of<LinkedAccountProvider>(context,
                                              listen: false)
                                          .linkedAccounts[index]['whom'] ==
                                      2 &&
                                  (Provider.of<LinkedAccountProvider>(context,
                                                      listen: false)
                                                  .linkedAccounts[index]
                                              ['isOtpVerified'] ==
                                          null ||
                                      Provider.of<LinkedAccountProvider>(
                                                      context,
                                                      listen: false)
                                                  .linkedAccounts[index]
                                              ['isOtpVerified'] !=
                                          1)) {
                                var request = {
                                  'phoneNumber':
                                      Provider.of<LinkedAccountProvider>(
                                              context,
                                              listen: false)
                                          .linkedAccounts[index]['phoneNumber']
                                          .toString(),
                                  'relation':
                                      Provider.of<LinkedAccountProvider>(
                                              context,
                                              listen: false)
                                          .linkedAccounts[index]['relation']
                                };
                                ProgressDialogUtils.showProgressDialog(context);
                                try {
                                  var res = await ApiManager()
                                      .sendLinkAccountCode(request);
                                  ProgressDialogUtils.dismissProgressDialog();
                                  if (res is String) {
                                    Widgets.showAppDialog(
                                        context: context, description: res);
                                  } else {
                                    Navigator.of(context).pushNamed(
                                        Routes.linkVerification,
                                        arguments: request);
                                  }
                                } on ErrorModel catch (e) {
                                  ProgressDialogUtils.dismissProgressDialog();
                                  DialogUtils.showAlertDialog(
                                      context, e.response);
                                } catch (e) {
                                  ProgressDialogUtils.dismissProgressDialog();
                                }
                              } else {
                                updateUser(
                                  context,
                                  index == 0
                                      ? Provider.of<LinkedAccountProvider>(
                                              context,
                                              listen: false)
                                          .linkedAccounts[index]
                                      : Provider.of<LinkedAccountProvider>(
                                                  context,
                                                  listen: false)
                                              .linkedAccounts[index]
                                          ['linkToAccount'],
                                );
                              }
                            },
                          );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  updateUser(context, dynamic value) async {
    ProgressDialogUtils.showProgressDialog(context);
    var fcmId = await SharedPref().getValue('deviceToken');
    var deviceId = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    var a = await ApiBaseHelper().switchAccount(
        'Bearer ${getString('primaryUserToken')}',
        {'_id': value['_id'], 'deviceId': deviceId, 'fcmId': fcmId});

    setBool(PreferenceKey.perFormedSteps, true);
    setBool(PreferenceKey.isEmailVerified, a['isEmailVerified']);
    setString(PreferenceKey.fullName, a['fullName']);
    setString(PreferenceKey.id, a['_id']);
    setString(PreferenceKey.tokens, a['token']);
    setString(PreferenceKey.phone, a['phoneNumber'].toString());
    setInt(PreferenceKey.gender, a['gender']);
    setString('patientSocialHistory', jsonEncode(a['patientSocialHistory']));
    setString('selectedAccount', jsonEncode(a));
    setBool(PreferenceKey.intro, true);
    SharedPref().saveToken(a['token']);
    ProgressDialogUtils.dismissProgressDialog();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homeMain,
      (Route<dynamic> route) => false,
    );
  }
}
