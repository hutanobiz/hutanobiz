import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesScreen extends StatefulWidget {
  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<String> imagesList = List();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Upload Images",
        isLoading: _isLoading,
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          // if (imagesList != null && imagesList.length > 0) {
          //   _container.setConsentToTreatData("imagesList", imagesList);
          // }

          Navigator.of(context).pushNamed(Routes.uploadDocumentsScreen);
        },
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 65),
              child: ListView(
                children: widgetList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 55.0,
                child: FancyButton(
                  title: "Upload images",
                  buttonIcon: "ic_upload",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    showPickerDialog();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = List();

    formWidget.add(Text(
      imagesList.isEmpty
          ? "Images can, at times, help your clinician understand the extent of your injury or condition. Please upload any images that might help your clinician diagnoses your condition. Images, especially of skin conditions can help your provider understand the nature of your condition. Images are kept confidential and will be part of your digital medical chart that you can access from from the cloud."
          : "Images can, at times, help your clinician understand the extent of your injury. Please upload any images that might help your clinician diagnoses your condition.",
      style: TextStyle(
        fontSize: 14.0,
      ),
    ));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Wrap(
      spacing: 16,
      runSpacing: 20,
      children: images(),
    ));

    return formWidget;
  }

  images() {
    List<Widget> columnContent = [];

    for (String content in imagesList) {
      columnContent.add(
        Container(
          height: 110.0,
          width: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.grey[300],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  File(content),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() => imagesList.remove(content));
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 16.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      constraints:
                          const BoxConstraints(minWidth: 22.0, minHeight: 22.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return columnContent;
  }

  Future getImage(int source) async {
    ImagePicker _picker = ImagePicker();

    PickedFile image = await _picker.getImage(
        imageQuality: 25,
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);

      File croppedFile = await ImageCropper.cropImage(
        compressQuality: imageFile.lengthSync() > 100000 ? 25 : 100,
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.transparent,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        setState(() => imagesList.add(croppedFile.path));

        setLoading(true);
        SharedPref().getToken().then((token) {
          ApiBaseHelper api = ApiBaseHelper();

          api
              .multipartPost(
            ApiBaseHelper.base_url + 'api/patient/images',
            token,
            'images',
            croppedFile,
          )
              .then((value) {
            setLoading(false);
          }).futureError((error) => setLoading(false));
        });
      }
    }
  }

  void showPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Picker"),
          content: new Text("Select image picker type."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Camera"),
              onPressed: () {
                getImage(1);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () {
                getImage(2);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
