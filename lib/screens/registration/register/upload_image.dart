import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/permission_utils.dart';

class UploadImage extends StatefulWidget {
  final Function? onImagePicked;
  final String? image;

  const UploadImage({Key? key, this.onImagePicked, this.image})
      : super(key: key);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  XFile? imageFile;
  late File _file;
  final _picker = ImagePicker();

  _openImageDialog(source) {
    // PermissionUtils.requestPermission(
    //     [source == ImageSource.gallery ? Permission.photos : Permission.camera],
    //     context, permissionGrant: () {
    _pickImage(source);
    // });
  }

  void showPickerDialog() {
    FocusScope.of(context).unfocus();

    showCommonUploadDialog(
      context,
      Localization.of(context)!.picker,
      Localization.of(context)!.uploadPhoto,
      onTop: () {
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        _openImageDialog(ImageSource.camera);
      },
      onBottom: () {
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        _openImageDialog(ImageSource.gallery);
      },
    );
  }

  Future<Null> _pickImage(source) async {
    imageFile = await _picker.pickImage(source: source);
    if (imageFile != null) _cropImage();
  }

  Future<Null> _cropImage() async {
    var croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.goldenTainoi,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ]);
    if (croppedFile != null) {
      imageFile = XFile(croppedFile.path);
      var path = File(imageFile!.path);
      widget.onImagePicked!(path);
      setState(() {
        _file = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: showPickerDialog,
          child: Container(
            child: imageFile == null
                ? widget.image == null
                    ? Container(
                        width: spacing40,
                        height: spacing40,
                        child: Image.asset(FileConstants.icUser),
                      )
                    : ClipOval(
                        child: Image.network(
                          ApiBaseHelper.imageUrl + widget.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                : ClipOval(
                    child: Image.file(
                      _file,
                      fit: BoxFit.cover,
                    ),
                  ),
            width: spacing70,
            height: spacing70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(
          height: spacing7,
        ),
        GestureDetector(
          onTap: showPickerDialog,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                FileConstants.icUpload2,
                height: spacing20,
                width: spacing20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Localization.of(context)!.uploadPhoto,
                style: TextStyle(
                    color: colorPurple100.withOpacity(0.85),
                    fontSize: fontSize14,
                    fontFamily: gilroyMedium),
              )
            ],
          ),
        )
      ],
    );
  }
}
