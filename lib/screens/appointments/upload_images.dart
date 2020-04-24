import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesScreen extends StatefulWidget {
  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  File croppedFile;
  JsonDecoder _decoder = new JsonDecoder();

  List<String> imagesList = List();
  InheritedContainerState _container;
  Map _consentToTreatMap;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _consentToTreatMap = _container.consentToTreatMap;

    super.didChangeDependencies();
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
        onForwardTap: () {
          _uploadImage(imagesList, imagesList.length > 0 ? 'Uploaded!' : null);

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
              // child: Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: SizedBox(
              //         height: 55.0,
              //         child: FancyButton(
              //           title: "Upload images",
              //           buttonIcon: "ic_send_request",
              //           buttonColor: AppColors.windsor,
              //           onPressed: () {
              //             imagesList.length > 0
              //                 ? _uploadImage(imagesList, 'Uploaded!')
              //                 : Widgets.showToast(
              //                     "Please select image(s) to upload");
              //           },
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 22.0),
              //     ArrowButton(
              //       buttonWidth: 58.0,
              //       buttonColor: AppColors.windsor.withOpacity(0.10),
              //       iconData: Icons.camera_alt,
              //       iconColor: AppColors.windsor,
              //       onTap: () => showPickerDialog(),
              //     ),
              //   ],
              // ),
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
                  fit: BoxFit.fill,
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
                        _uploadImage(imagesList, null);
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
    var image = await ImagePicker.pickImage(
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      croppedFile = await ImageCropper.cropImage(
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
      if (croppedFile == null) {
      } else {
        setState(() => imagesList.add(image.path));
      }
    }
  }

  _uploadImage(List<String> imagesList, String message) async {
    try {
      SharedPref().getToken().then((token) async {
        setLoading(true);
        Uri uri = Uri.parse(ApiBaseHelper.base_url +
            "api/patient/appointment-details/" +
            _container.appointmentIdMap["appointmentId"]);
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.headers['authorization'] = token;

        request.fields['consentToTreat'] = '1';
        request.fields['problemTimeSpan'] =
            _consentToTreatMap["problemTimeSpan"];
        request.fields['isProblemImproving'] =
            _consentToTreatMap["isProblemImproving"];
        request.fields['isTreatmentReceived'] =
            _consentToTreatMap["isTreatmentReceived"];
        request.fields['description'] =
            _consentToTreatMap["description"].toString().trim();

        if (_consentToTreatMap["medicalHistory"] != null &&
            _consentToTreatMap["medicalHistory"].length > 0) {
          for (int i = 0;
              i < _consentToTreatMap["medicalHistory"].length;
              i++) {
            request.fields["medicalHistory[$i]"] =
                _consentToTreatMap["medicalHistory"][i];
          }
        }

        if (imagesList != null && imagesList.length > 0) {
          List<MultipartFile> newList = List<MultipartFile>();

          for (int i = 0; i < imagesList.length; i++) {
            File imageFile = File(imagesList[i].toString());
            var stream =
                http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
            var length = await imageFile.length();
            var multipartFile = http.MultipartFile("images", stream, length,
                filename: imageFile.path);
            newList.add(multipartFile);
          }

          request.files.addAll(newList);
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          var respStr = await response.stream.bytesToString();
          var responseJson = _decoder.convert(respStr);

          responseJson["response"].toString().debugLog();

          if (message != null) Widgets.showToast(message);
        }

        setLoading(false);
      });
    } on Exception catch (error) {
      setLoading(false);
      error.toString().debugLog();
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
