import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:provider/provider.dart';

import '../../apis/api_manager.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/reusable_functions.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_textfield.dart';
import 'model/req_remove_medical_images.dart';
import 'model/req_upload_images.dart';
import 'model/res_medical_images_upload.dart';
import 'provider/appoinment_provider.dart';

class UploadSymptomsImages extends StatefulWidget {
  @override
  _UploadSymptomsImagesState createState() => _UploadSymptomsImagesState();
}

class _UploadSymptomsImagesState extends State<UploadSymptomsImages> {
  // int count = 10;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _imagenameController = TextEditingController();
  final List<String> _images = [];
  final List<String> _imagesNames = [];

  _uploadImages() async {
    if (_images.length == 0) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context)!.selecteOnImage);
      return;
    }
    var appointmentId =
        Provider.of<SymptomsInfoProvider>(context, listen: false).appoinmentId;

    final _imageFile = <File>[];
    for (var imagePath in _images) {
      _imageFile.add(File(imagePath));
    }
    ProgressDialogUtils.showProgressDialog(context);

    for (var i = 0; i < _imageFile.length; i++) {
      try {
        final request =
            ReqUploadImage(name: _imagesNames[i], appointmentId: appointmentId);
        var res = await ApiManager().uploadPainImages(request, _imageFile[i]);
        if (res.data!.medicalImages!.length == _imageFile.length) {
          ProgressDialogUtils.dismissProgressDialog();
          _sortList(res.data!.medicalImages);
          // DialogUtils.showAlertDialog(
          //     context, Localization.of(context).imagesUploaded);
          Navigator.of(context).pushNamed(routeUploadTestDocuments);
        }
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response!);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        print(e);
      }
    }
  }

  void _sortList(medicalImages) {
    if (medicalImages.length == 0) return;
    if (_imagesNames.length == 0) {
      Provider.of<SymptomsInfoProvider>(context, listen: false)
          .setMedicalImages([]);
      return;
    }
    var _sortedImageList = <MedicalImages>[];
    for (var i = 0; i < _imagesNames.length; i++) {
      var _item = medicalImages
          .firstWhere((element) => element.name == _imagesNames[i]);
      if (_item != null) _sortedImageList.add(_item);
    }

    Provider.of<SymptomsInfoProvider>(context, listen: false)
        .setMedicalImages(_sortedImageList);
  }

  _callRemoveImageApi(imageId) async {
    ProgressDialogUtils.showProgressDialog(context);
    var appointmentId =
        Provider.of<SymptomsInfoProvider>(context, listen: false).appoinmentId;

    try {
      final request = ReqRemoveMedicalImages(
          imageId: imageId, appointmentId: appointmentId);
      var res = await ApiManager().removeMedicalImages(request);
      ProgressDialogUtils.dismissProgressDialog();
      _sortList(res.data!.medicalImages);
      Navigator.of(context).pushNamed(routeUploadTestDocuments);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response!);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  _onImageRemove(index) {
    var _imageList =
        Provider.of<SymptomsInfoProvider>(context, listen: false).medicalImages;

    if (_imageList.length == 0) {
      _images.removeAt(index);
      _imagesNames.removeAt(index);
      setState(() {});
    } else {
      _callRemoveImageApi(_imageList[index].sId);
    }
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildContent(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: spacing10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing10),
                child: HTProgressBar(totalSteps: 5, currentSteps: 3),
              ),
              AppLogo(),
              SizedBox(height: spacing15),
              Text(
                "Photos",
                style: TextStyle(
                    fontSize: fontSize13, fontWeight: fontWeightSemiBold),
              ),
              SizedBox(height: spacing15),
              Text(
                "Do you have any photos that may help the\n"
                "provider understand your condition?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: fontSize12,
                    fontWeight: fontWeightMedium),
              ),
              _images.length > 0
                  ? _buildImageList()
                  : Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.2),
                      child: Text(
                        "no images",
                        style: TextStyle(
                            fontSize: fontSize13,
                            fontWeight: fontWeightSemiBold),
                      ),
                    ),
            ],
          ),
        ),
      );

  Widget _buildImageList() => GridView.builder(
        padding:
            EdgeInsets.symmetric(horizontal: spacing20, vertical: spacing40),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: spacing15,
            mainAxisSpacing: spacing15,
            crossAxisCount: 2,
            childAspectRatio: 5 / 4),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacing10, vertical: spacing7),
                      child: Image.file(
                        File(_images[index]),
                        fit: BoxFit.contain,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(width: 0.5, color: colorGreyBackground),
                      ),
                    ),
                    Positioned(
                      top: spacing7,
                      right: spacing7,
                      child: InkWell(
                        onTap: () {
                          _onImageRemove(index);
                        },
                        child: Container(
                          height: 16,
                          width: 16,
                          child: Image.asset(
                            FileConstants.icClose,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _imagesNames[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize17,
                  fontWeight: fontWeightRegular,
                ),
              )
            ],
          );
        },
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: HutanoButton(
                    buttonType: HutanoButtonType.withPrefixIcon,
                    icon: FileConstants.icupload,
                    iconSize: 22,
                    label: "Images are worth a thousand words!",
                    color: primaryColor,
                    // onPressed: _uploadImages,
                    onPressed: () {
                      presentBottomSheet();
                    },
                  ),
                ),
                SizedBox(width: spacing20),
              ],
            ),
            SizedBox(height: spacing40),
            Row(
              children: [
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context)!.skip,
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(routeUploadTestDocuments);
                    },
                  ),
                ),
                SizedBox(width: spacing70),
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context)!.next,
                    // onPressed: () {
                    //   Navigator.of(context).pushNamed( routeUploadTestDocuments);
                    // },
                    onPressed: _uploadImages,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void presentBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(spacing15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _key,
                      child: HutanoTextField(
                        controller: _imagenameController,
                        hintText: "bodypart name",
                        focusNode: FocusNode(),
                        labelText: "Body Part",
                        validationMethod: (value) {
                          if (value == null || value == '') {
                            return "please enter name of bodypart";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: spacing15),
                    HutanoButton(
                      label: "Camera",
                      color: primaryColor,
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          var file = await getImageByCamera(context);
                          print(file?.path);
                          if (file != null) {
                            _images.add(file.path);
                            _imagesNames.add(_imagenameController.text);
                            _imagenameController.text = "";
                            setState(() {});
                          }
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    SizedBox(height: spacing15),
                    HutanoButton(
                      label: "Gallery",
                      color: primaryColor,
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          var file = await getImageByGallery(context);
                          print(file?.path);
                          if (file != null) {
                            _images.add(file.path);
                            _imagesNames.add(_imagenameController.text);
                            _imagenameController.text = "";
                            setState(() {});
                          }
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
