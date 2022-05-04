import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_utils.dart';

Future<File> getImageByCamera(BuildContext context) async {
  var isGranted = true;
  await PermissionUtils.requestPermission([Permission.camera], context,
      isOpenSettings: true, permissionGrant: () async {}, permissionDenied: () {
    isGranted = false;
  });
  if (isGranted) {
    return await getImage(context, ImageSource.camera);
  } else {
    return null;
  }
}

Future<File> getImageByGallery(BuildContext context) async {
  var isGranted = true;
  await PermissionUtils.requestPermission(
      Platform.isAndroid ? [Permission.storage] : [Permission.photos], context,
      isOpenSettings: true, permissionGrant: () async {}, permissionDenied: () {
    isGranted = false;
  });
  if (isGranted) {
    return await getImage(context, ImageSource.gallery);
  } else {
    return null;
  }
}

Future<File> getImage(BuildContext context, ImageSource source) async {
  final _picker = ImagePicker();
  var pickedfile = await _picker.pickImage(source: source, imageQuality: 10);
  return pickedfile != null ? File(pickedfile.path) : null;
}
