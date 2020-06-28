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
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesScreen extends StatefulWidget {
  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<Map> imagesList = List();

  bool _isLoading = false;
  ApiBaseHelper _api = ApiBaseHelper();

  String token;

  String imageName = '';

  @override
  void initState() {
    super.initState();

    setLoading(true);
    imagesList.clear();

    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
      });

      _api.getPatientDocuments(token).then((value) {
        if (value != null) {
          setLoading(false);

          setState(() {
            if (value['medicalImages'] != null &&
                value['medicalImages'].isNotEmpty) {
              for (dynamic images in value['medicalImages']) {
                imagesList.add(images);
              }
            }
          });
        }
      }).futureError((error) {
        error.toString().debugLog();
        setLoading(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Upload Images",
        isLoading: _isLoading,
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () =>
            Navigator.of(context).pushNamed(Routes.uploadDocumentsScreen),
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
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
                  onPressed: showPickerDialog,
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

    formWidget.add(
      Wrap(
        spacing: 10,
        runSpacing: 20,
        children: images(),
      ),
    );

    return formWidget;
  }

  List<Widget> images() {
    List<Widget> columnContent = [];

    for (dynamic content in imagesList) {
      String imageFile = content['images'];

      if (!content['images'].toString().contains('image_cropper')) {
        imageFile = ApiBaseHelper.imageUrl + content['images'];
      }

      columnContent.add(
        Container(
          height: 120.0,
          width: 180.0,
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
                child: imageFile.contains('http') || imageFile.contains('https')
                    ? Image.network(
                        imageFile,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imageFile),
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
                        setLoading(true);

                        int urlIndex = imageFile.lastIndexOf('/');
                        String imageName =
                            imageFile.substring(urlIndex + 1, content.length);

                        _api
                            .deletePatientImage(
                          token,
                          imageName,
                        )
                            .whenComplete(() {
                          setLoading(false);
                          setState(() => imagesList.remove(content));
                        }).futureError((error) {
                          setLoading(false);
                          error.toString().debugLog();
                        });
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.grey[100],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      "ic_image".imageIcon(width: 20, height: 15),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Text(
                          content['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
        uploadImageBottomSheet(croppedFile);
      }
    }
  }

  void uploadImageBottomSheet(File imageFile) {
    Widgets.uploadBottomSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Image',
            style: TextStyle(
              color: AppColors.midnight_express,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              imageFile,
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 39),
          TextField(
            onChanged: (value) {
              imageName = value;
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              labelText: "Name",
              alignLabelWithHint: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.grey[300],
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.grey[300],
                  width: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 39),
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonTheme(
                  height: 55,
                  child: OutlineButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(14.0),
                    ),
                    highlightedBorderColor: AppColors.windsor,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.windsor,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: FancyButton(
                  title: 'Upload',
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    if (imageName == null || imageName.isEmpty) {
                      Widgets.showToast("Image name can't be empty");
                    } else {
                      Map<String, String> fileMap = {};
                      fileMap['name'] = imageName;
                      Navigator.pop(context);

                      setLoading(true);

                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url + 'api/patient/images',
                        token,
                        'images',
                        fileMap,
                        imageFile,
                      )
                          .then((value) {
                        setState(() {
                          Map imageMap = {};
                          imageMap['name'] = imageName;
                          imageMap['images'] = imageFile.path;

                          imagesList.add(imageMap);
                        });
                        setLoading(false);
                      }).futureError((error) => setLoading(false));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
