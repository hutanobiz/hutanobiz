import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';

import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingUploadImages extends StatefulWidget {
  dynamic args;
  BookingUploadImages({Key? key, this.args}) : super(key: key);
  @override
  _BookingUploadImagesState createState() => _BookingUploadImagesState();
}

class _BookingUploadImagesState extends State<BookingUploadImages>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late List tabs;
  int _currentIndex = 0;
  List<Map?> imagesList = [];
  List<Map?> filteredImagesList = [];

  bool _isLoading = false;
  ApiBaseHelper _api = ApiBaseHelper();

  String? token;

  String? imageName = '';
  bool isBottomButtonsShow = true;
  bool isFromAppointment = false;

  List<Map?> _selectedImagesList = [];
  TextEditingController _imageDateController = TextEditingController();
  String? defaultBodyPart;
  Map sidesMap = {1: "Left", 2: "Right", 3: "Top", 4: "Bottom", 5: "All Over"};

  @override
  void dispose() {
    _tabController!.dispose();
    _imageDateController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    setLoading(true);
    _imageDateController.text =
        DateFormat(Strings.datePattern).format(DateTime.now());
    SharedPref().getToken().then((token) {
      // if (mounted) {
      //   setState(() {
      this.token = token;
      //   });
      // }

      _api.getPatientDocuments(token).then((value) {
        if (value != null) {
          setLoading(false);
          if (mounted) {
            setState(() {
              if (value['medicalImages'] != null &&
                  value['medicalImages'].isNotEmpty) {
                if (widget.args['medicalImages'] != null &&
                    widget.args['medicalImages'].length > 0) {
                  for (dynamic img in widget.args['medicalImages']) {
                    img['isArchive'] = false;
                    imagesList.add(img);
                    _selectedImagesList.add(img);
                  }
                  for (dynamic images in value['medicalImages']) {
                    if ((imagesList.singleWhere(
                            (img) => img!['_id'] == images['_id'],
                            orElse: () => null)) !=
                        null) {
                      imagesList.removeWhere(
                          (element) => element!['_id'] == images['_id']);
                      _selectedImagesList.removeWhere(
                          (element) => element!['_id'] == images['_id']);
                      images['isArchive'] = false;
                      _selectedImagesList.add(images);
                      imagesList.add(images);
                      print('Already exists!');
                    } else {
                      imagesList.add(images);
                    }
                  }
                } else {
                  for (dynamic images in value['medicalImages']) {
                    imagesList.add(images);
                  }
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
    _imageDateController.addListener(() {
      setState(() {});
    });
    tabs = ['Recent', 'Archive', 'View all'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(_handleTabControllerTick);

    if (Provider.of<HealthConditionProvider>(context, listen: false)
                .allHealthIssuesData !=
            null &&
        Provider.of<HealthConditionProvider>(context, listen: false)
                .allHealthIssuesData
                .length >
            0) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
                  .allHealthIssuesData[0]
                  .bodyPart !=
              null &&
          Provider.of<HealthConditionProvider>(context, listen: false)
                  .allHealthIssuesData[0]
                  .bodyPart!
                  .length >
              0) {
        var part = Provider.of<HealthConditionProvider>(context, listen: false)
            .allHealthIssuesData[0]
            .bodyPart![0]
            .name;
        var side = sidesMap[int.parse(
            Provider.of<HealthConditionProvider>(context, listen: false)
                .allHealthIssuesData[0]
                .bodyPart![0]
                .sides![0])];

        defaultBodyPart = side + ' ' + part;
      }
    }
    if (widget.args['appointmentProblems'] != null) {
      if (widget.args['appointmentProblems']['bodyPart'] != null &&
          widget.args['appointmentProblems']['bodyPart'].length > 0) {
        var part = widget.args['appointmentProblems']['bodyPart'][0]['name'];
        var side = sidesMap[widget.args['appointmentProblems']['bodyPart'][0]
            ['sides'][0]];

        defaultBodyPart = side + ' ' + part;
      }
    }
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        isAddAppBar: false,
        addHeader: true,
        title: "",
        isSkipLater: !widget.args['isEdit'],
        isLoading: _isLoading,
        addBottomArrows: true,
        onSkipForTap: () {
          if (widget.args['isEdit']) {
            Navigator.pop(context);
          } else {
            Provider.of<HealthConditionProvider>(context, listen: false)
                .updateImages([]);
            Navigator.of(context).pushNamed(Routes.bookingUploadMedicalDocument,
                arguments: {'isEdit': false});
          }
        },
        onForwardTap: () {
          if (widget.args['isEdit']) {
            List<String?> selectedImagesId = [];
            if (_selectedImagesList != null && _selectedImagesList.length > 0) {
              _selectedImagesList.forEach((element) {
                selectedImagesId.add(MedicalImages.fromJson(element as Map<String, dynamic>).sId);
              });
            }
            Map<String, dynamic> model = {};
            model['medicalImages'] = selectedImagesId;
            model['appointmentId'] = widget.args['appointmentId'];
            setLoading(true);
            ApiManager().updateAppointmentData(model).then((value) {
              setLoading(false);
              Navigator.pop(context);
            });
          } else {
            List<MedicalImages> _selectedMedicalImages = [];
            if (_selectedImagesList != null && _selectedImagesList.length > 0) {
              _selectedImagesList.forEach((element) {
                _selectedMedicalImages.add(MedicalImages.fromJson(element as Map<String, dynamic>));
              });
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateImages(_selectedMedicalImages);
            }
            Navigator.of(context)
                .pushNamed(Routes.bookingUploadMedicalDocument, arguments: {
              'isEdit': false,
              'medicalDocuments': Provider.of<HealthConditionProvider>(context,
                              listen: false)
                          .previousAppointment !=
                      null
                  ? Provider.of<HealthConditionProvider>(context, listen: false)
                      .previousAppointment['medicalDocuments']
                  : null
            });
          }
        },
        padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
        child: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.windsor,
              controller: _tabController,
              tabs: _tabsHeader(),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
            ),
            SizedBox(height: spacing10),
            _uploadImagesBanner(context),
            SizedBox(height: 0),
            Expanded(
              child: _uploadedImageViews(context, imagesList),
            )
          ],
        ),
      ),
    );
  }

  // Widget _tabsContent() => _currentIndex == 0
  //     ? UploadImagesScreen()
  //     : _currentIndex == 1
  //         ? ComingSoon(isFromUpload: true, isBackRequired: false)
  //         : ViewAllDocumentImages();

  List<Widget> _tabsHeader() {
    return tabs
        .asMap()
        .map((index, text) => MapEntry(
              index,
              Container(
                height: 50,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _tabController!.index == index
                              ? AppColors.windsor
                              : colorBlack2,
                          fontSize: fontSize14,
                          fontWeight: _tabController!.index == index
                              ? fontWeightMedium
                              : fontWeightRegular),
                    )
                  ],
                ),
              ),
            ))
        .values
        .toList();
  }

  Widget _uploadedImageViews(BuildContext context, imagesList) {
    filteredImagesList.clear();
    if (_currentIndex == 0) {
      for (dynamic m in imagesList) {
        if (m['isArchive'] != null && m['isArchive'] == false) {
          filteredImagesList.add(m);
        }
      }
    } else if (_currentIndex == 1) {
      for (dynamic m in imagesList) {
        if (m['isArchive'] == null || m['isArchive'] == true) {
          filteredImagesList.add(m);
        }
      }
    } else {
      for (dynamic m in imagesList) {
        filteredImagesList.add(m);
      }
    }
    return GridView.builder(
      itemCount: filteredImagesList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        String? imageFile =
            filteredImagesList[index]![ArgumentConstant.imagesKey];
        if (!filteredImagesList[index]![ArgumentConstant.imagesKey]
            .toString()
            .contains('image_cropper')) {
          imageFile = ApiBaseHelper.imageUrl +
              filteredImagesList[index]![ArgumentConstant.imagesKey];
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
                Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                            height: 32,
                            width: 32,
                            child: RoundCornerCheckBox(
                                value: _selectedImagesList
                                    .contains(filteredImagesList[index]),
                                onCheck: (value) {
                                  if (value) {
                                    if (!_selectedImagesList
                                        .contains(filteredImagesList[index])) {
                                      setState(() {
                                        _selectedImagesList
                                            .add(filteredImagesList[index]);
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _selectedImagesList
                                          .remove(filteredImagesList[index]);
                                    });
                                  }
                                })))),
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
                                  filteredImagesList[index]!
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
                                  filteredImagesList[index]!
                                          [ArgumentConstant.dateKey] ??
                                      '---+---',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: fontSize12,
                                      fontWeight: fontWeightRegular,
                                      color: Colors.black)))
                        ]),
                  ).onClick(onTap: () {
                    if (!_selectedImagesList
                        .contains(filteredImagesList[index])) {
                      setState(() {
                        _selectedImagesList.add(filteredImagesList[index]);
                      });
                    } else {
                      setState(() {
                        _selectedImagesList.remove(filteredImagesList[index]);
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
  }

  Widget _uploadImagesBanner(BuildContext context) => (!isFromAppointment)
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
          uiSettings: [
            AndroidUiSettings(
                toolbarColor: Colors.transparent,
                toolbarWidgetColor: Colors.transparent,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioLockDimensionSwapEnabled: true,
            ),
          ]);
      if (croppedFile != null) {
        uploadImageBottomSheet(File(croppedFile.path));
      }
    }
  }

  void uploadImageBottomSheet(File imageFile) {
    imageName = defaultBodyPart;

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
          TextFormField(
            onChanged: (value) {
              imageName = value;
            },
            initialValue: imageName ?? '',
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
                      ),
                    ),
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
                        // _imageDateController.text = '';
                        setState(() {
                          _api.getPatientDocuments(token).then((value) {
                            if (value != null) {
                              setLoading(false);

                              if (mounted) {
                                setState(() {
                                  if (value['medicalImages'] != null &&
                                      value['medicalImages'].isNotEmpty) {
                                    value['medicalImages'].last['isArchive'] =
                                        false;
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
