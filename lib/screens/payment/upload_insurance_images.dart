import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/dashed_border.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hutano/widgets/fancy_button.dart';

class UploadInsuranceImagesScreen extends StatefulWidget {
  final bool isPayment;

  const UploadInsuranceImagesScreen({Key key, this.isPayment})
      : super(key: key);

  @override
  _UploadInsuranceImagesScreenState createState() =>
      _UploadInsuranceImagesScreenState();
}

class _UploadInsuranceImagesScreenState
    extends State<UploadInsuranceImagesScreen> {
  File croppedFile;
  JsonDecoder _decoder = new JsonDecoder();

  InheritedContainerState _container;
  Map _insuranceMap;
  String frontImagePath, backImagePath;

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
        isAddBack: !widget.isPayment,
        addBackButton: widget.isPayment,
        onForwardTap: _uploadImages,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Stack(
          children: <Widget>[
            ListView(
              children: widgetList(),
            ),
            if (widget.isPayment)
              Container()
            else
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width,
                  child: FancyButton(
                    title: 'Save',
                    onPressed: _uploadImages,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _uploadImages() {
    if (frontImagePath == null) {
      Widgets.showToast("Please upload front insurance card image");
    } else {
      _uploadImage(
        'Insurance card added successfully',
      );
    }
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

    formWidget.add(
      Row(
        children: <Widget>[
          Expanded(
            child: DashedBorder(
              onTap: () => showPickerDialog(true),
              child: frontImagePath == null
                  ? uploadWidget(
                      "Front", AssetImage("images/ic_front_image.png"))
                  : imageWidget(frontImagePath, true),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: InkWell(
              splashColor: Colors.grey,
              onTap: () => showPickerDialog(false),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(14),
                color: Colors.black26,
                dashPattern: [6, 6],
                strokeWidth: 0.5,
                child: backImagePath == null
                    ? uploadWidget(
                        "Back", AssetImage("images/ic_back_image.png"))
                    : imageWidget(backImagePath, false),
              ),
            ),
          ),
        ],
      ),
    );

    return formWidget;
  }

  uploadWidget(title, image) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: image,
            height: 48.0,
            width: 48.0,
          ),
        ),
        SizedBox(width: 6.0),
        Text(
          title,
        )
      ],
    );
  }

  Widget imageWidget(String path, bool isFront) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              File(path),
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
                    setState(
                      () => isFront
                          ? frontImagePath = null
                          : backImagePath = null,
                    );
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
    );
  }

  Future getImage(bool isFront, int source) async {
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
          () => isFront
              ? frontImagePath = croppedFile.path
              : backImagePath = croppedFile.path,
        );
      }
    }
  }

  _uploadImage(String message) async {
    try {
      SharedPref().getToken().then((token) async {
        setLoading(true);
        Uri uri = Uri.parse(ApiBaseHelper.base_url + "api/profile/update");
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.headers['authorization'] = token;

        request.fields["insuranceId[]"] =
            _insuranceMap["insuranceId"].toString();

        if (frontImagePath != null) {
          File frontImage = File(frontImagePath);
          var stream = http.ByteStream(DelegatingStream(frontImage.openRead()));
          var length = await frontImage.length();
          var frontMultipartFile = http.MultipartFile(
            "insuranceDocumentFront",
            stream.cast(),
            length,
            filename: frontImage.path,
          );

          request.files.add(frontMultipartFile);

          if (backImagePath != null) {
            File backImage = File(backImagePath);
            var stream =
                http.ByteStream(DelegatingStream(backImage.openRead()));
            var length = await backImage.length();
            var backMultipartFile = http.MultipartFile(
              "insuranceDocumentBack",
              stream.cast(),
              length,
              filename: backImage.path,
            );

            request.files.add(backMultipartFile);
          }
        }

        var response = await request.send();
        final int statusCode = response.statusCode;
        log("Status code: $statusCode");

        String respStr = await response.stream.bytesToString();
        var responseJson = _decoder.convert(respStr);

        if (statusCode < 200 || statusCode > 400 || json == null) {
          setLoading(false);
          if (responseJson["response"] is String)
            Widgets.showToast(responseJson["response"]);
          else if (responseJson["response"] is Map)
            Widgets.showToast(responseJson);
          else {
            responseJson["response"]
                .map((m) => Widgets.showToast(m.toString()))
                .toList();
          }

          responseJson["response"].toString().debugLog();
          throw Exception(responseJson);
        } else {
          setLoading(false);

          responseJson.toString().debugLog();
          Navigator.popUntil(
              context, ModalRoute.withName(Routes.paymentMethodScreen));

          if (message != null) Widgets.showToast(message);
        }
      });
    } on Exception catch (error) {
      setLoading(false);
      error.toString().debugLog();
    }
  }

  void showPickerDialog(bool isFront) {
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
                getImage(isFront, 2);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () {
                getImage(isFront, 3);
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
