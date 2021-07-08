import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadImagesScreen extends StatefulWidget {
  UploadImagesScreen({Key key, this.isBottomButtonsShow}) : super(key: key);

  final Map isBottomButtonsShow;

  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<Map> imagesList = List();

  bool _isLoading = false;
  ApiBaseHelper _api = ApiBaseHelper();

  String token;

  String imageName = '';
  bool isBottomButtonsShow = true;
  bool isFromAppointment = false;

  List<Map> _selectedImagesList = [];

  InheritedContainerState _container;

  @override
  void initState() {
    super.initState();

    if (widget.isBottomButtonsShow != null) {
      if (widget.isBottomButtonsShow['isBottomButtonsShow'] != null) {
        isBottomButtonsShow = widget.isBottomButtonsShow['isBottomButtonsShow'];
      }
      if (widget.isBottomButtonsShow['isFromAppointment'] != null) {
        isFromAppointment = widget.isBottomButtonsShow['isFromAppointment'];
      }

      if (isFromAppointment) {
        if (widget.isBottomButtonsShow['medicalImages'] != null &&
            widget.isBottomButtonsShow['medicalImages'].length > 0) {
          for (dynamic images in widget.isBottomButtonsShow['medicalImages']) {
            imagesList.add(images);
          }
        }
      }
    }

    if (!isFromAppointment) {
      setLoading(true);
      imagesList.clear();

      SharedPref().getToken().then((token) {
        if (mounted) {
          setState(() {
            this.token = token;
          });
        }

        _api.getPatientDocuments(token).then((value) {
          if (value != null) {
            setLoading(false);

            if (mounted) {
              setState(() {
                if (value['medicalImages'] != null &&
                    value['medicalImages'].isNotEmpty) {
                  for (dynamic images in value['medicalImages']) {
                    imagesList.add(images);
                  }
                }
              });
            }
          }
        }).futureError((error) {
          error.toString().debugLog();
          setLoading(false);
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isBottomButtonsShow ? AppColors.goldenTainoi : Colors.white,
      body: LoadingBackground(
        title: "Images",
        isLoading: _isLoading,
        isAddAppBar: isBottomButtonsShow,
        isAddBack: false,
        addBackButton: isBottomButtonsShow,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 20, 20, isBottomButtonsShow ? 20 : 20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 65.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: widgetList(),
                    ),
                  ),
                  isFromAppointment
                      ? Container()
                      : Align(
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
            Divider(height: 0.5),
            isBottomButtonsShow
                ? Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width - 76.0,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(right: 0.0, left: 40.0),
                      child: FancyButton(
                        title: "Continue",
                        onPressed: () {
                          if (_selectedImagesList != null &&
                              _selectedImagesList.length > 0) {
                            _container.setConsentToTreatData(
                                "imagesList", _selectedImagesList);
                          }

                          Navigator.of(context)
                              .pushNamed(Routes.uploadDocumentsScreen);
                        },
                      ),
                    ),
                  )
                : SizedBox()
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
      if (content['images'] != null) {
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
                  child:
                      imageFile.contains('http') || imageFile.contains('https')
                          ? Image.network(
                              imageFile,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imageFile),
                              fit: BoxFit.cover,
                            ),
                ),
                isBottomButtonsShow
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: RoundCornerCheckBox(
                              value: _selectedImagesList.contains(content),
                              onCheck: (value) {
                                if (value) {
                                  if (!_selectedImagesList.contains(content)) {
                                    setState(() {
                                      _selectedImagesList.add(content);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _selectedImagesList
                                        .remove(content['_id'].toString());
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    : isFromAppointment
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: SizedBox(
                                height: 22,
                                width: 22,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setLoading(true);

                                    _api
                                        .deletePatientImage(
                                      token,
                                      content['_id'],
                                    )
                                        .whenComplete(() {
                                      setLoading(false);
                                      setState(
                                          () => imagesList.remove(content));
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
                                  constraints: const BoxConstraints(
                                      minWidth: 22.0, minHeight: 22.0),
                                ),
                              ),
                            ),
                          ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8.0),
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
                        "ic_image".imageIcon(
                          width: 20,
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            content['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ).onClick(onTap: () {
                    if (!_selectedImagesList.contains(content)) {
                      setState(() {
                        _selectedImagesList.add(content);
                      });
                    } else {
                      setState(() {
                        _selectedImagesList.remove(content);
                      });
                    }
                  }),
                ),
              ],
            ),
          ).onClick(
            onTap: imageFile.toLowerCase().endsWith("pdf")
                ? () async {
                    var url = imageFile;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                : () {
                    Navigator.of(context).pushNamed(
                      Routes.providerImageScreen,
                      arguments: imageFile,
                    );
                  },
          ),
        );
      }
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
        uploadImageBottomSheet(croppedFile);
      }
    }
  }

  void uploadImageBottomSheet(File imageFile) {
    imageName = null;

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
              labelText: "what body part is this?",
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
                  onPressed: () async {
                    if (imageName == null || imageName.isEmpty) {
                      Widgets.showToast("Image name can't be empty");
                    } else {
                      Map<String, String> fileMap = {};
                      fileMap['name'] = imageName;
                      Navigator.pop(context);

                      setLoading(true);

                      var stream =
                          ByteStream(DelegatingStream(imageFile.openRead()));
                      var length = await imageFile.length();
                      var multipartFile = MultipartFile(
                          'images', stream.cast(), length,
                          filename: imageFile.path);

                      List<MultipartFile> multipartList = [];
                      multipartList.add(multipartFile);
                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url + 'api/patient/images',
                        token,
                        fileMap,
                        multipartList,
                      )
                          .then((value) {
                        setState(() {
                          _api.getPatientDocuments(token).then((value) {
                            if (value != null) {
                              setLoading(false);

                              if (mounted) {
                                setState(() {
                                  if (value['medicalImages'] != null &&
                                      value['medicalImages'].isNotEmpty) {
                                    imagesList.add(value['medicalImages'].last);
                                  }

                                  if (isBottomButtonsShow) {
                                    setState(() {
                                      _selectedImagesList.add(imagesList.last);
                                    });
                                  }
                                });
                              }
                            }
                          }).futureError((error) {
                            error.toString().debugLog();
                            setLoading(false);
                          });
                        });
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
    if (mounted) {
      setState(() => _isLoading = value);
    }
  }
}
