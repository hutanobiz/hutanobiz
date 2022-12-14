import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:hutano/strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dialog_utils.dart';

class PermissionUtils {
  static void requestPermission(
      List<Permission> permission, BuildContext context,
      {Function? permissionGrant,
      Function? permissionDenied,
      Function? permissionNotAskAgain,
      bool isOpenSettings = false,
      bool isShowMessage = true}) async {
    final statuses = await permission.request();

    var allPermissionGranted = true;

    statuses.forEach((key, value) {
      print(statuses);
      if (value == PermissionStatus.granted) {
        allPermissionGranted = allPermissionGranted && true;
      } else {
        allPermissionGranted = allPermissionGranted && false;
      }
    });

    if (allPermissionGranted) {
      if (permissionGrant != null) {
        permissionGrant();
      }
    } else {
      if (permissionDenied != null) {
        permissionDenied();
      }
      if (isOpenSettings) {
      DialogUtils.showOkCancelAlertDialog(
        context: context,
        message: Strings.enablelPermission,
        okButtonTitle: Strings.goToSetting,
        cancelButtonTitle: Strings.cancel,
        cancelButtonAction: () {},
        okButtonAction: () {
          AppSettings.openAppSettings();
        },
      );
      } else if (isShowMessage) {
        // DialogUtils.displayToast(
        //     Strings.alertPermissionNotRestricted);
      }
    }
  }

  // static void checkPermissionStatus(
  //     PermissionGroup permission, BuildContext context,
  //     {Function permissionGrant, Function permissionDenied}) {
  //   PermissionHandler().checkPermissionStatus(permission).then((value) {
  //     if (value == PermissionStatus.granted) {
  //       permissionGrant();
  //     } else {
  //       permissionDenied();
  //     }
  //   });
  // }
}
