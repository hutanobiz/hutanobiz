import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class UploadInsuranceImagesScreen extends StatefulWidget {
  @override
  _UploadInsuranceImagesScreenState createState() =>
      _UploadInsuranceImagesScreenState();
}

class _UploadInsuranceImagesScreenState
    extends State<UploadInsuranceImagesScreen> {
  File croppedFile;
  JsonDecoder _decoder = new JsonDecoder();

  Map<String, String> imagesList = Map();
  InheritedContainerState _container;
  Map _insuranceMap;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _insuranceMap = _container.insuranceDataMap;

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
          if (imagesList["0"] == null) {
            Widgets.showToast("Please upload front insurance card image");
          } else {
            _uploadImage(
              imagesList,
              imagesList.length > 0
                  ? 'Insurance card added successfully'
                  : null,
            );
          }
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
                  title: "Upload Insurance images",
                  buttonIcon: "ic_upload",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    showImageTypeDialog();
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
      "Upload insurance front and back (optional) image",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
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

    imagesList.forEach((key, value) {
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
                  File(value),
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
                        setState(() => imagesList.remove(key));
                        // _uploadImage(imagesList, null);
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
    });

    return columnContent;
  }

  Future getImage(int imageType, int source) async {
    var image = await ImagePicker.pickImage(
        imageQuality: 25,
        source: (source == 2) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      croppedFile = await ImageCropper.cropImage(
        compressQuality: 25,
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
        setState(
          () => imageType == 0
              ? imagesList["0"] = croppedFile.path
              : imagesList["1"] = croppedFile.path,
        );
      }
    }
  }

  _uploadImage(Map<String, String> imagesList, String message) async {
    try {
      SharedPref().getToken().then((token) async {
        setLoading(true);
        Uri uri = Uri.parse(ApiBaseHelper.base_url + "api/profile/update");
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.headers['authorization'] = token;

        request.fields["insuranceId[]"] =
            _insuranceMap["insuranceId"].toString();

        if (imagesList != null && imagesList.length > 0) {
          File frontImage = File(imagesList["0"]);
          var stream =
              http.ByteStream(DelegatingStream.typed(frontImage.openRead()));
          var length = await frontImage.length();
          var frontMultipartFile = http.MultipartFile(
            "insuranceDocumentFront",
            stream,
            length,
            filename: frontImage.path,
          );

          request.files.add(frontMultipartFile);

          if (imagesList["1"] != null) {
            File backImage = File(imagesList["1"]);
            var stream =
                http.ByteStream(DelegatingStream.typed(backImage.openRead()));
            var length = await backImage.length();
            var backMultipartFile = http.MultipartFile(
              "insuranceDocumentBack",
              stream,
              length,
              filename: backImage.path,
            );

            request.files.add(backMultipartFile);
          }
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          var respStr = await response.stream.bytesToString();
          var responseJson = _decoder.convert(respStr);

          responseJson.toString().debugLog();
          Navigator.popUntil(
              context, ModalRoute.withName(Routes.paymentMethodScreen));

          if (message != null) Widgets.showToast(message);
        }

        setLoading(false);
      });
    } on Exception catch (error) {
      setLoading(false);
      error.toString().debugLog();
    }
  }

  void showPickerDialog(int imageType) {
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
                getImage(imageType, 2);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () {
                getImage(imageType, 3);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showImageTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Picker"),
          content: new Text("Select image type."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Front image"),
              onPressed: () {
                Navigator.pop(context);
                showPickerDialog(0);
              },
            ),
            new FlatButton(
              child: new Text("Back image"),
              onPressed: () {
                Navigator.pop(context);
                showPickerDialog(1);
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
