import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadImagesScreen extends StatefulWidget {
  UploadImagesScreen({Key? key, this.isBottomButtonsShow}) : super(key: key);

  final Map? isBottomButtonsShow;

  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  List<Map?> imagesList = [];

  bool _isLoading = false;
  ApiBaseHelper _api = ApiBaseHelper();

  String? token;

  String? imageName = '';
  bool? isBottomButtonsShow = true;
  bool? isFromAppointment = false;

  List<Map?> _selectedImagesList = [];
  TextEditingController _imageDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageDateController.addListener(() {
      setState(() {});
    });
    if (widget.isBottomButtonsShow != null) {
      if (widget.isBottomButtonsShow!['isBottomButtonsShow'] != null) {
        isBottomButtonsShow = widget.isBottomButtonsShow!['isBottomButtonsShow'];
      }
      if (widget.isBottomButtonsShow!['isFromAppointment'] != null) {
        isFromAppointment = widget.isBottomButtonsShow!['isFromAppointment'];
      }

      if (isFromAppointment!) {
        if (widget.isBottomButtonsShow!['medicalImages'] != null &&
            widget.isBottomButtonsShow!['medicalImages'].length > 0) {
          for (dynamic images in widget.isBottomButtonsShow!['medicalImages']) {
            imagesList.add(images);
          }
        }
      }
    }

    if (!isFromAppointment!) {
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
  void dispose() {
    _imageDateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isBottomButtonsShow! ? AppColors.goldenTainoi : Colors.white,
      body: LoadingBackgroundNew(
        title: "Images",
        isLoading: _isLoading,
        isAddAppBar: false,
        isAddBack: false,
        addHeader: false,
        color: Colors.white,
        isSkipLater: true,
        addBottomArrows: isBottomButtonsShow,
        onSkipForTap: () {
          Provider.of<HealthConditionProvider>(context, listen: false)
              .updateImages([]);
          Navigator.of(context).pushNamed(Routes.allDocumentsTabsScreen);
        },
        onForwardTap: () {
          List<MedicalImages> _selectedMedicalImages = [];
          if (_selectedImagesList != null && _selectedImagesList.length > 0) {
            _selectedImagesList.forEach((element) {
              _selectedMedicalImages.add(MedicalImages.fromJson(element as Map<String, dynamic>));
            });
            Provider.of<HealthConditionProvider>(context, listen: false)
                .updateImages(_selectedMedicalImages);
          }
          Navigator.of(context).pushNamed(Routes.allDocumentsTabsScreen);
        },
        padding: EdgeInsets.fromLTRB(
            0, 0, 0, isBottomButtonsShow! ? spacing70 : spacing20),
        child: ListView(
          children: widgetList(context),
        ),
      ),
    );
  }

  List<Widget> widgetList(BuildContext context) {
    List<Widget> formWidget = [];
    formWidget.add(SizedBox(height: spacing10));
    formWidget.add(_uploadImagesBanner(context));
    formWidget.add(SizedBox(height: spacing30));
    formWidget.add(_uploadedImageViews(context));
    return formWidget;
  }

  Widget _uploadedImageViews(BuildContext context) => GridView.builder(
        itemCount: imagesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String? imageFile = imagesList[index]![ArgumentConstant.imagesKey];
          if (!imagesList[index]![ArgumentConstant.imagesKey]
              .toString()
              .contains('image_cropper')) {
            imageFile = ApiBaseHelper.imageUrl +
                imagesList[index]![ArgumentConstant.imagesKey];
          }
          return Padding(
            padding: const EdgeInsets.all(spacing5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: imageFile!.contains('http') ||
                              imageFile.contains('https')
                          ? Image.network(imageFile, fit: BoxFit.cover)
                          : Image.file(File(imageFile), fit: BoxFit.cover)),
                  isBottomButtonsShow!
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: RoundCornerCheckBox(
                                      value: _selectedImagesList
                                          .contains(imagesList[index]),
                                      onCheck: (value) {
                                        if (value) {
                                          if (!_selectedImagesList
                                              .contains(imagesList[index])) {
                                            setState(() {
                                              _selectedImagesList
                                                  .add(imagesList[index]);
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _selectedImagesList
                                                .remove(imagesList[index]);
                                          });
                                        }
                                      }))))
                      : isFromAppointment!
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
                                          Widgets.showConfirmationDialog(
                                              context: context,
                                              description:
                                                  "Are you sure to delete this image?",
                                              onLeftPressed: () {
                                                setLoading(true);
                                                _api
                                                    .deletePatientImage(
                                                  token,
                                                  imagesList[index]!
                                                      [ArgumentConstant.idKey],
                                                )
                                                    .whenComplete(() {
                                                  setLoading(false);
                                                  setState(() =>
                                                      imagesList.remove(
                                                          imagesList[index]));
                                                }).futureError((error) {
                                                  setLoading(false);
                                                  error.toString().debugLog();
                                                });
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
                                      )))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: spacing60,
                      padding: const EdgeInsets.all(
                        spacing10,
                      ),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    imagesList[index]!
                                            [ArgumentConstant.nameKey] ??
                                        '---+---',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: fontSize14,
                                        fontWeight: fontWeightSemiBold,
                                        color: Color(0xff1b1200)))),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    imagesList[index]!
                                            [ArgumentConstant.dateKey] ??
                                        '---+---',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: fontSize12,
                                        fontWeight: fontWeightRegular,
                                        color: Colors.black)))
                          ]),
                    ).onClick(onTap: () {
                      if (!_selectedImagesList.contains(imagesList[index])) {
                        setState(() {
                          _selectedImagesList.add(imagesList[index]);
                        });
                      } else {
                        setState(() {
                          _selectedImagesList.remove(imagesList[index]);
                        });
                      }
                    }),
                  ),
                ],
              ).onClick(
                onTap: imageFile.toLowerCase().endsWith("pdf")
                    ? () async {
                        var url = imageFile!;
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
            ),
          );
        },
      );

  Widget _uploadImagesBanner(BuildContext context) => (!isFromAppointment!)
      ? ListTile(
          onTap: showPickerDialog,
          leading: CircleAvatar(
            radius: spacing30,
            backgroundColor: AppColors.goldenTainoi,
            child: Image.asset(
              FileConstants.icCamera,
              width: spacing20,
              height: spacing20,
              color: Colors.white,
            ),
          ),
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              Localization.of(context)!.uploadMedicalImagesLabel,
              style: TextStyle(
                  fontSize: fontSize15,
                  fontWeight: fontWeightSemiBold,
                  color: Colors.black),
            ),
            subtitle: Text(
              Localization.of(context)!.uploadMedicalImagesSubLabel,
              style: TextStyle(
                  fontSize: fontSize12,
                  fontWeight: fontWeightRegular,
                  color: Color(0xff1b1200)),
            ),
            trailing: Icon(Icons.add, color: AppColors.goldenTainoi, size: 30),
          ),
        )
      : SizedBox();

  Future getImage(int source) async {
    ImagePicker _picker = ImagePicker();

     XFile? image = await _picker.pickImage(
        imageQuality: 25,
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);

      var croppedFile = await ImageCropper().cropImage(
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
       uiSettings: [AndroidUiSettings(
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.transparent,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
       IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockDimensionSwapEnabled: true,
        ),]
      );
      if (croppedFile != null) {
        uploadImageBottomSheet(File(croppedFile.path));
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
                  color: Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: spacing25),
          TextField(
            enabled: false,
            controller: _imageDateController,
            decoration: getInputDecoration('Date'),
          ).onClick(onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              onConfirm: (date) {
                if (date != null)
                  _imageDateController.text =
                      DateFormat(Strings.datePattern).format(date);
              },
              currentTime: DateTime.now(),
              maxTime: DateTime.now(),
              locale: LocaleType.en,
            );
          }),
          SizedBox(height: spacing40),
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonTheme(
                  height: 55,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(14.0),
                    ),),
                    // highlightedBorderColor: AppColors.windsor,
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
                    if (imageName == null || imageName!.isEmpty) {
                      Widgets.showToast("Image name can't be empty");
                    } else if (_imageDateController.text == null ||
                        _imageDateController.text.isEmpty) {
                      Widgets.showToast(Localization.of(context)!.errImageDate);
                      return;
                    } else {
                      Map<String, String> fileMap = {};
                      fileMap[ArgumentConstant.nameKey] = imageName!;
                      fileMap[ArgumentConstant.dateKey] =
                          _imageDateController.text;
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
                        _imageDateController.text = '';
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

                                  if (isBottomButtonsShow!) {
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

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.grey),
      labelText: label,
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
    );
  }

  void showPickerDialog() {
    showCommonUploadDialog(
      context,
      Localization.of(context)!.picker,
      Localization.of(context)!.uploadPhoto,
      onTop: () {
        getImage(1);
        Navigator.pop(context);
      },
      onBottom: () {
        getImage(2);
        Navigator.pop(context);
      },
    );
  }

  void setLoading(bool value) {
    if (mounted) {
      setState(() => _isLoading = value);
    }
  }
}
