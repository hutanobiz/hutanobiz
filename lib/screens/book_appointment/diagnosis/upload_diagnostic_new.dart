import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/screens/book_appointment/diagnosis/model/res_diagnostic_test_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';

import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import 'package:hutano/widgets/text_with_image.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes.dart';
import '../../../strings.dart';
import 'model/res_diagnostic_test_model.dart';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';

class UploadDiagnosticNew extends StatefulWidget {
  UploadDiagnosticNew({Key key, this.args}) : super(key: key);

  final Map args;

  @override
  _UploadDiagnosticNewState createState() => _UploadDiagnosticNewState();
}

class _UploadDiagnosticNewState extends State<UploadDiagnosticNew> {
  bool _getData = false;
  bool _indicatorLoading = true;
  ApiBaseHelper _api = ApiBaseHelper();
  String token;
  final documentTypeController = TextEditingController();
  final documentDateController = TextEditingController();
  String documentName = '';
  List<String> _documentTypeList = [
    'X-Ray',
    'MRI',
    'CAT Scan',
    'Labs',
    'Ultrasound',
    'EKG',
    'Other',
  ];
  InheritedContainerState _container;
  List<DiagnosticTest> _finalTestList = [];

  List<Map> docsList = List();
  Map<String, String> filesPaths;
  List<Map> _selectedDocsList = [];
  bool isLoading = false;
  String defaultBodyPart;
  Map sidesMap = {1: "Left", 2: "Right", 3: "Top", 4: "Bottom", 5: "All Over"};

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getTestDiagnostics(context);
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
      });
      getMedicalDocuments();
    });

    documentDateController.text =
        DateFormat(Strings.datePattern).format(DateTime.now());

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
                  .bodyPart
                  .length >
              0) {
        var part = Provider.of<HealthConditionProvider>(context, listen: false)
            .allHealthIssuesData[0]
            .bodyPart[0]
            .name;
        var side = sidesMap[int.parse(
            Provider.of<HealthConditionProvider>(context, listen: false)
                .allHealthIssuesData[0]
                .bodyPart[0]
                .sides[0])];

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

  @override
  void dispose() {
    documentTypeController.dispose();
    documentDateController.dispose();
    super.dispose();
  }

  void getMedicalDocuments({bool isAdd = false}) {
    ProgressDialogUtils.showProgressDialog(context);
    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
      });

      _api.getPatientDocuments(token).then((value) {
        if (value != null) {
          ProgressDialogUtils.dismissProgressDialog();
          setState(() {
            if (value['medicalDiagnostics'] != null &&
                value['medicalDiagnostics'].isNotEmpty) {
              if (isAdd) {
                docsList.add(value['medicalDiagnostics'].last);
                _selectedDocsList.add(docsList.last);
              } else {
                if (widget.args['medicalDiagnostics'] != null &&
                    widget.args['medicalDiagnostics'].length > 0) {
                  for (dynamic img in widget.args['medicalDiagnostics']) {
                    // img['isArchive'] = false;
                    docsList.add(img);
                    _selectedDocsList.add(img);
                  }
                  for (dynamic images in value['medicalDiagnostics']) {
                    if ((docsList.singleWhere(
                            (img) => img['_id'] == images['_id'],
                            orElse: () => null)) !=
                        null) {
                      docsList.removeWhere(
                          (element) => element['_id'] == images['_id']);
                      _selectedDocsList.removeWhere(
                          (element) => element['_id'] == images['_id']);
                      // images['isArchive'] = false;
                      _selectedDocsList.add(images);
                      docsList.add(images);
                      print('Already exists!');
                    } else {
                      docsList.add(images);
                    }
                  }
                } else {
                  docsList.clear();
                  for (dynamic docs in value['medicalDiagnostics']) {
                    docsList.add(docs);
                  }
                }
              }
            }
          });
        }
      }).futureError((error) {
        error.toString().debugLog();
        ProgressDialogUtils.dismissProgressDialog();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: false,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        addBottomArrows: true,
        isLoading: isLoading,
        onForwardTap: () {
          _forwardButtonPressed(context);
        },
        padding: EdgeInsets.only(left: spacing20, right: spacing20, bottom: 60),
        child: ListView(
          children: <Widget>[
            _uploadMedicalDocumentsBanner(context),
            // _uploadFileHeader(context),
            _uploadedDocumentsViews(context),
            // if (_isTookDiagnosticTest) SizedBox(height: spacing10),
            // if (_isTookDiagnosticTest)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //     child: DottedBorder(
            //         padding: EdgeInsets.all(spacing20),
            //         borderType: BorderType.RRect,
            //         radius: Radius.circular(12),
            //         color: AppColors.windsor,
            //         child: _uploadDocumentsButton(context),
            //         strokeWidth: 1,
            //         dashPattern: [8, 8]),
            //   ),
            // if (_isTookDiagnosticTest) SizedBox(height: spacing10),
            // if (_isTookDiagnosticTest)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //     child: Text(
            //       Localization.of(context).uploadFileLowerLabel,
            //       style: TextStyle(
            //           fontSize: fontSize12,
            //           fontWeight: fontWeightRegular,
            //           color: colorBlack2),
            //     ),
            //   )
          ],
        ),
      ),
    );
  }

  void showPickerDialog() {
    showCommonUploadDialog(context, Localization.of(context).picker,
        Localization.of(context).uploadDocument, onTop: () {
      Navigator.pop(context);
      showImagePickerDialog();
    }, onBottom: () {
      getDocumentType();
      Navigator.pop(context);
    }, isForDocument: true);
  }

  void showImagePickerDialog() {
    showCommonUploadDialog(
      context,
      Localization.of(context).picker,
      Localization.of(context).uploadPhoto,
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

  Widget _uploadMedicalDocumentsBanner(BuildContext context) => ListTile(
        onTap: showPickerDialog,
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'Upload other medical documents',
            style: TextStyle(
                fontSize: fontSize15,
                fontWeight: fontWeightSemiBold,
                color: Colors.black),
          ),
          subtitle: Text(
            Localization.of(context).uploadFileLowerLabel,
            style: TextStyle(
                fontSize: fontSize12,
                fontWeight: fontWeightRegular,
                color: Color(0xff1b1200)),
          ),
          trailing: Icon(Icons.add, color: AppColors.goldenTainoi, size: 30),
        ),
      );

  Widget _uploadFileHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: spacing10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            Localization.of(context).uploadFilesHeader,
            style: TextStyle(
                fontSize: fontSize14,
                fontWeight: fontWeightMedium,
                color: colorBlack2),
          ),
        ),
      );

  Widget _uploadedDocumentsViews(BuildContext context) => GridView.builder(
        itemCount: docsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String document = docsList[index]['image'];

          if (!document.contains('data/')) {
            document = ApiBaseHelper.imageUrl + docsList[index]['image'];
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
                      child: document.toLowerCase().endsWith("pdf")
                          ? "ic_pdf".imageIcon()
                          : (document.contains('http') ||
                                  document.contains('https')
                              ? Image.network(
                                  document,
                                  height: 125.0,
                                  width: 180.0,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(document),
                                  height: 125.0,
                                  width: 180.0,
                                  fit: BoxFit.cover,
                                ))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: RoundCornerCheckBox(
                          value: _selectedDocsList.contains(docsList[index]),
                          onCheck: (value) {
                            if (value) {
                              if (!_selectedDocsList
                                  .contains(docsList[index])) {
                                setState(() {
                                  _selectedDocsList.add(docsList[index]);
                                });
                              }
                            } else {
                              setState(() {
                                _selectedDocsList.remove(docsList[index]);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // : Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Align(
                  //       alignment: Alignment.topRight,
                  //       child: SizedBox(
                  //         height: 22,
                  //         width: 22,
                  //         child: RawMaterialButton(
                  //           onPressed: () {
                  //             ProgressDialogUtils.showProgressDialog(
                  //                 context);
                  //             _api
                  //                 .deletePatientMedicalDocs(
                  //               token,
                  //               docsList[index]['_id'],
                  //             )
                  //                 .whenComplete(() {
                  //               ProgressDialogUtils
                  //                   .dismissProgressDialog();
                  //               setState(() =>
                  //                   docsList.remove(docsList[index]));
                  //             }).futureError((error) {
                  //               ProgressDialogUtils
                  //                   .dismissProgressDialog();
                  //               error.toString().debugLog();
                  //             });
                  //           },
                  //           child: Icon(
                  //             Icons.close,
                  //             color: Colors.grey,
                  //             size: 16.0,
                  //           ),
                  //           shape: CircleBorder(),
                  //           elevation: 2.0,
                  //           fillColor: Colors.white,
                  //           constraints: const BoxConstraints(
                  //             minWidth: 22.0,
                  //             minHeight: 22.0,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: spacing70,
                      padding: EdgeInsets.symmetric(
                          horizontal: spacing10, vertical: 5),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                docsList[index][ArgumentConstant.nameKey],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: fontSize14,
                                    fontWeight: fontWeightSemiBold,
                                    color: Color(0xff1b1200)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                docsList[index][ArgumentConstant.typeKey],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: fontSize12,
                                    fontWeight: fontWeightRegular,
                                    color: Colors.black),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                docsList[index][ArgumentConstant.dateKey],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: fontSize12,
                                    fontWeight: fontWeightRegular,
                                    color: Colors.black),
                              ),
                            ),
                          ]),
                    ).onClick(onTap: () {
                      _selectedDocsList.toString().debugLog();

                      if (!_selectedDocsList.contains(docsList[index])) {
                        setState(() {
                          _selectedDocsList.add(docsList[index]);
                        });
                      } else {
                        setState(() {
                          _selectedDocsList.remove(docsList[index]);
                        });
                      }
                    }),
                  ),
                ],
              ).onClick(
                onTap: document.toLowerCase().endsWith("pdf")
                    ? () async {
                        var url = document;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }
                    : () {
                        Navigator.of(context).pushNamed(
                          Routes.providerImageScreen,
                          arguments: document,
                        );
                      },
              ),
            ),
          );
        },
      );

  Widget _uploadDocumentsButton(BuildContext context) => Center(
        child: IntrinsicWidth(
          child: TextWithImage(
            imageSpacing: spacing10,
            image: FileConstants.icUploadDocs,
            label: Localization.of(context).uploadDocumentsLabel,
            size: 18,
            textStyle: TextStyle(
                color: AppColors.windsor,
                fontWeight: fontWeightMedium,
                fontSize: fontSize14),
          ),
        ).onClick(onTap: showPickerDialog),
      );

  // void showPickerDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(Localization.of(context).picker),
  //         content: Text(Localization.of(context).selectDocPickerTypeLabel),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text(Localization.of(context).imageLabel),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               showImagePickerDialog();
  //             },
  //           ),
  //           FlatButton(
  //             child: Text(Localization.of(context).pdfLabel),
  //             onPressed: () {
  //               getDocumentType();
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void showImagePickerDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(Localization.of(context).picker),
  //         content: Text(Localization.of(context).selectImagePickerTypeLabel),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text(Localization.of(context).camera),
  //             onPressed: () {
  //               getImage(1);
  //               Navigator.pop(context);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text(Localization.of(context).gallery),
  //             onPressed: () {
  //               getImage(2);
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
        uploadDocsBottomSheet(croppedFile);
      }
    }
  }

  void getDocumentType() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (file != null) {
      uploadDocsBottomSheet(File(file.files.first.path));
    }
  }

  void uploadDocsBottomSheet(File file) {
    documentName = defaultBodyPart;
    Widgets.uploadBottomSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Localization.of(context).documentLabel,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing16),
          file == null
              ? Container()
              : file.path.toLowerCase().endsWith("pdf")
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: "ic_pdf".imageIcon(
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        file,
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
          SizedBox(height: spacing40),
          TextField(
            enabled: false,
            controller: documentTypeController,
            decoration:
                getInputDecoration(Localization.of(context).whatKindOfDocLabel),
          ).onClick(onTap: _documentTypeBottomDialog),
          SizedBox(height: spacing25),
          textField(
            Localization.of(context).whatBodyPartLabel,
            documentName ?? '',
            (value) {
              documentName = value;
            },
          ),
          SizedBox(height: spacing25),
          TextField(
            enabled: false,
            controller: documentDateController,
            decoration: getInputDecoration('Date'),
          ).onClick(onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              onConfirm: (date) {
                if (date != null)
                  documentDateController.text =
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
                  child: OutlineButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(14.0),
                    ),
                    highlightedBorderColor: AppColors.windsor,
                    child: Text(
                      Localization.of(context).cancel,
                      style: TextStyle(
                          color: AppColors.windsor, fontSize: fontSize16),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              SizedBox(width: spacing16),
              Expanded(
                child: FancyButton(
                  title: Localization.of(context).upload,
                  buttonColor: AppColors.windsor,
                  onPressed: () async {
                    if (documentTypeController.text == null ||
                        documentTypeController.text.isEmpty) {
                      Widgets.showToast(Localization.of(context).errDocType);
                      return;
                    } else if (documentName == null || documentName.isEmpty) {
                      Widgets.showToast(Localization.of(context).errDocName);
                      return;
                    } else if (documentDateController.text == null ||
                        documentDateController.text.isEmpty) {
                      Widgets.showToast(Localization.of(context).errDocDate);
                      return;
                    } else {
                      Navigator.pop(context);
                      ProgressDialogUtils.showProgressDialog(context);
                      Map<String, String> fileMap = {};
                      fileMap[ArgumentConstant.nameKey] = documentName;
                      fileMap[ArgumentConstant.typeKey] =
                          documentTypeController.text;
                      fileMap[ArgumentConstant.dateKey] =
                          documentDateController.text;
                      final bytes = file.readAsBytesSync().lengthInBytes;
                      final kb = bytes / 1024;
                      final mb = kb / 1024;
                      fileMap[ArgumentConstant.sizeKey] = mb.toStringAsFixed(2);

                      var stream =
                          ByteStream(DelegatingStream(file.openRead()));
                      var length = await file.length();
                      var multipartFile = MultipartFile(
                          'medicalDiagnostics', stream.cast(), length,
                          filename: file.path);

                      List<MultipartFile> multipartList = [];
                      multipartList.add(multipartFile);

                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url +
                            'api/patient/medical-diagnostics',
                        token,
                        fileMap,
                        multipartList,
                      )
                          .then((value) {
                        ProgressDialogUtils.dismissProgressDialog();
                        documentTypeController.text = '';
                        // documentDateController.text = '';
                        getMedicalDocuments(isAdd: true);
                      }).futureError((error) {
                        ProgressDialogUtils.dismissProgressDialog();
                      });
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

  Widget textField(String label, String initVal, Function onChanged) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initVal,
      decoration: getInputDecoration(label),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: Colors.grey[300],
          width: 0.5,
        ),
      ),
    );
  }

  void _documentTypeBottomDialog() {
    debugPrint("done");
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _finalTestList.length,
            itemBuilder: (context, index) {
              String docType = _finalTestList[index].name;
              return ListTile(
                title: Center(
                  child: Text(
                    docType,
                    style: TextStyle(
                      color: docType == documentTypeController.text
                          ? AppColors.goldenTainoi
                          : Colors.black,
                      fontSize: docType == documentTypeController.text
                          ? fontSize20
                          : fontSize16,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    documentTypeController.text = docType;
                  });
                  Navigator.pop(context);
                },
              );
            },
          );
        });
  }

  void _forwardButtonPressed(BuildContext context) {
    if (widget.args['isEdit']) {
      List<String> selectedTestsId = [];
      if (_selectedDocsList != null && _selectedDocsList.length > 0) {
        _selectedDocsList.forEach((element) {
          selectedTestsId.add(MedicalImages.fromJson(element).sId);
        });
      }
      Map<String, dynamic> model = {};
      model['medicalDiagnosticsTests'] = selectedTestsId;
      model['appointmentId'] = widget.args['appointmentId'];
      setLoading(true);
      ApiManager().updateAppointmentData(model).then((value) {
        setLoading(false);
        Navigator.pop(context);
      });
    } else {
      List<DiagnosticTest> selectedTestsModel = [];
      if (_selectedDocsList != null && _selectedDocsList.length > 0) {
        _selectedDocsList.forEach((element) {
          selectedTestsModel.add(DiagnosticTest.fromJson(element));
        });
      }

      Provider.of<HealthConditionProvider>(context, listen: false)
          .updateDiagnosticsModel(selectedTestsModel);
      Navigator.of(context).pushNamed(Routes.routeMedicineInformation,
          arguments: {'isEdit': false});
    }
  }

  void _getTestDiagnostics(BuildContext context) async {
    await ApiManager().getDiagnosticTestTypeList().then((result) {
      if (result is ResDiagnositcTestModel) {
        setState(() {
          _finalTestList = result.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  setLoading(bool isLoading) {
    setState(() {
      isLoading = isLoading;
    });
  }
}
