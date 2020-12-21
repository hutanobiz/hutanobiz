import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/dashed_border.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadInsuranceImagesScreen extends StatefulWidget {
  final Map insuranceViewMap;

  const UploadInsuranceImagesScreen({Key key, this.insuranceViewMap})
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
  Map _insuranceViewMap = {};

  String insuranceName = '', userInsuranceId = '', insuranceId = '';

  dynamic uploadedInsurance;

  String token;
  bool isFromRegister = false;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) => this.token = token);

    if (widget.insuranceViewMap != null) {
      _insuranceViewMap = widget.insuranceViewMap;

      if (_insuranceViewMap['isFromRegister'] != null) {
        isFromRegister = _insuranceViewMap['isFromRegister'];
      }

      if (_insuranceViewMap['insurance'] != null) {
        if (_insuranceViewMap['insurance']['insuranceName'] != null) {
          insuranceName = _insuranceViewMap['insurance']['insuranceName'];
        }
        if (_insuranceViewMap['insurance']['_id'] != null) {
          userInsuranceId = _insuranceViewMap['insurance']['_id'];
        }
        if (_insuranceViewMap['insurance']['insuranceId'] != null) {
          insuranceId = _insuranceViewMap['insurance']['insuranceId'];
        }
        if (_insuranceViewMap['insurance']['insuranceDocumentFront'] != null) {
          frontImagePath = ApiBaseHelper.imageUrl +
              _insuranceViewMap['insurance']['insuranceDocumentFront'];
        }
        if (_insuranceViewMap['insurance']['insuranceDocumentBack'] != null) {
          backImagePath = ApiBaseHelper.imageUrl +
              _insuranceViewMap['insurance']['insuranceDocumentBack'];
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
    _insuranceMap = _container.insuranceDataMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title:
            _insuranceViewMap['isViewDetail'] ? insuranceName : "Upload insurance images",
        isLoading: _isLoading,
        isAddBack: !_insuranceViewMap['isPayment'],
        addBackButton: _insuranceViewMap['isPayment'],
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        rightButtonText: !_insuranceViewMap['isViewDetail'] ? null : 'Delete',
        onRightButtonTap: !_insuranceViewMap['isViewDetail']
            ? null
            : () {
                Widgets.showAlertDialog(
                  context,
                  "Delete Insurance",
                  "Are you sure you want to delete the insurance?",
                  () {
                    _isLoading = true;

                    ApiBaseHelper _api = ApiBaseHelper();

                    SharedPref().getToken().then((token) {
                      _api
                          .deleteinsurance(token, userInsuranceId)
                          .then((value) {
                        _isLoading = false;
                        Widgets.showToast('Insurance deleted successfullly');
                        Navigator.pop(context, true);
                      }).futureError((error) {
                        _isLoading = false;
                        error.toString().debugLog();
                      });
                    });
                  },
                );
              },
        child: Stack(
          children: <Widget>[
            ListView(
              children: widgetList(),
            ),
            if (_insuranceViewMap['isViewDetail'])
              Container()
            else
              Padding(
                padding: EdgeInsets.only(
                    left: _insuranceViewMap['isPayment'] ? 80 : 0),
                child: Align(
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
      if (isFromRegister) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.dashboardScreen, (Route<dynamic> route) => false);
      } else {
        Navigator.popUntil(
          context,
          ModalRoute.withName(Routes.paymentMethodScreen),
        );
      }
    }
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = List();

    // formWidget.add(Text(
    //   "Upload insurance front and back (optional) image",
    //   style: TextStyle(
    //     fontSize: 14.0,
    //     fontWeight: FontWeight.w500,
    //   ),
    // ));

    formWidget.add(SizedBox(height: 20));

    formWidget.add(
      Row(
        children: <Widget>[
          Expanded(
            child: DashedBorder(
              onTap: frontImagePath != null
                  ? frontImagePath.toLowerCase().endsWith("pdf")
                      ? () async {
                          var url = frontImagePath;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      : () {
                          Navigator.of(context).pushNamed(
                            Routes.providerImageScreen,
                            arguments: frontImagePath,
                          );
                        }
                  : () {
                      showPickerDialog(true);
                    },
              child: frontImagePath == null
                  ? uploadWidget(
                      "Front", AssetImage("images/ic_front_image.png"))
                  : imageWidget(
                      frontImagePath,
                      true,
                    ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: DashedBorder(
              onTap: backImagePath != null
                  ? backImagePath.toLowerCase().endsWith("pdf")
                      ? () async {
                          var url = backImagePath;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      : () {
                          Navigator.of(context).pushNamed(
                            Routes.providerImageScreen,
                            arguments: backImagePath,
                          );
                        }
                  : () {
                      showPickerDialog(false);
                    },
              child: backImagePath == null
                  ? uploadWidget("Back", AssetImage("images/ic_back_image.png"))
                  : imageWidget(
                      backImagePath,
                      false,
                    ),
            ),
          ),
        ],
      ),
    );

    return formWidget;
  }

  Widget uploadWidget(title, image) {
    return SizedBox(
      height: 100.0,
      width: 180.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Image(
              image: image,
              height: 48.0,
              width: 48.0,
            ),
          ),
          SizedBox(width: 3.0),
          Text(
            title,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }

  Widget imageWidget(String path, bool isFront) {
    return Container(
      height: 100.0,
      width: 180.0,
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
            child: (path.contains('http') || path.contains('https'))
                ? Image.network(
                    path,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(path),
                    width: double.maxFinite,
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
                  constraints: const BoxConstraints(
                    minWidth: 22.0,
                    minHeight: 22.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage(bool isFront, int source) async {
    ImagePicker _picker = ImagePicker();

    PickedFile image = await _picker.getImage(
        imageQuality: 25,
        source: (source == 2) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);

      croppedFile = await ImageCropper.cropImage(
        compressQuality: imageFile.lengthSync() > 100000 ? 25 : 100,
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
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
          aspectRatioLockDimensionSwapEnabled: true,
        ),
      );
      if (croppedFile != null) {
        setState(
          () => isFront
              ? frontImagePath = croppedFile.path
              : backImagePath = croppedFile.path,
        );

        if (userInsuranceId == ''){ 
          _uploadImage(
            'Insurance images uploaded successfully',
          );
        } else {
          _updateInsurance('Insurance Images updated');
        }
      }
    }
  }

  _uploadImage(String message) async {
    try {
      setLoading(true);
      Uri uri = Uri.parse(ApiBaseHelper.base_url + "api/profile/update");
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.headers['authorization'] = token;

      request.fields["insuranceId[]"] = _insuranceMap["insuranceId"].toString();

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
      }

      if (backImagePath != null) {
        File backImage = File(backImagePath);
        var stream = http.ByteStream(DelegatingStream(backImage.openRead()));
        var length = await backImage.length();
        var backMultipartFile = http.MultipartFile(
          "insuranceDocumentBack",
          stream.cast(),
          length,
          filename: backImage.path,
        );

        request.files.add(backMultipartFile);
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

        if (responseJson['response'] != null) {
          List insuranceList = responseJson['response']['insurance'];

          if (insuranceList != null) {
            dynamic insurance = insuranceList[insuranceList.length - 1];

            userInsuranceId = insurance['_id'];
            insuranceId = insurance['insuranceId'];
          }
        }

        if (message != null) Widgets.showToast(message);
      }
    } on Exception catch (error) {
      setLoading(false);
      error.toString().debugLog();
    }
  }

  _updateInsurance(String message) async {
    try {
      setLoading(true);
      Uri uri =
          Uri.parse(ApiBaseHelper.base_url + "api/patient/update-insurance");
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.headers['authorization'] = token;

      request.fields["userInsuranceId"] = userInsuranceId;
      request.fields["insuranceId"] = insuranceId;

      if (frontImagePath != null &&
          !(frontImagePath.contains('http') ||
              frontImagePath.contains('https'))) {
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
      }

      if (backImagePath != null &&
          !(backImagePath.contains('http') ||
              backImagePath.contains('https'))) {
        File backImage = File(backImagePath);
        var stream = http.ByteStream(DelegatingStream(backImage.openRead()));
        var length = await backImage.length();
        var backMultipartFile = http.MultipartFile(
          "insuranceDocumentBack",
          stream.cast(),
          length,
          filename: backImage.path,
        );

        request.files.add(backMultipartFile);
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

        if (message != null) Widgets.showToast(message);
      }
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
