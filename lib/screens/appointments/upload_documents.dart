import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/constants/file_constants.dart';
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

class UploadDocumentsScreen extends StatefulWidget {
  UploadDocumentsScreen({Key key, this.isBottomButtonsShow}) : super(key: key);

  final Map isBottomButtonsShow;

  @override
  _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  List<Map> docsList = List();
  List<String> _documentTypeList = [
    'X-Ray',
    'MRI',
    'CAT Scan',
    'Labs',
    'Ultrasound',
    'EKG',
    'Other',
  ];

  bool _isLoading = false;
  Map<String, String> filesPaths;

  String token;

  ApiBaseHelper _api = ApiBaseHelper();

  final documentTypeController = TextEditingController();
  final documentDateController = TextEditingController();

  String documentName = '';
  bool isBottomButtonsShow = true;
  bool isFromAppointment = false;
  List<Map> _selectedDocsList = [];

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
        if (widget.isBottomButtonsShow['medicalDocuments'] != null &&
            widget.isBottomButtonsShow['medicalDocuments'].length > 0) {
          for (dynamic docs in widget.isBottomButtonsShow['medicalDocuments']) {
            docsList.add(docs);
          }
        }
      }
    }
    if (!isFromAppointment) {
      setLoading(true);
      getMedicalDocuments();
    }

    documentTypeController.addListener(() {
      setState(() {});
    });

    documentDateController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    documentTypeController.dispose();
    documentDateController.dispose();
    super.dispose();
  }

  void getMedicalDocuments({bool isAdd = false}) {
    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
      });

      _api.getPatientDocuments(token).then((value) {
        if (value != null) {
          setLoading(false);

          setState(() {
            if (value['medicalDocuments'] != null &&
                value['medicalDocuments'].isNotEmpty) {
              if (isBottomButtonsShow && isAdd) {
                docsList.add(value['medicalDocuments'].last);
              } else {
                docsList.clear();
                for (dynamic docs in value['medicalDocuments']) {
                  docsList.add(docs);
                }
              }
            }
          });

          if (isBottomButtonsShow && isAdd) {
            setState(() {
              _selectedDocsList.add(docsList.last);
            });
          }
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
        backgroundColor:
            isBottomButtonsShow ? AppColors.goldenTainoi : Colors.white,
        body: LoadingBackgroundNew(
            title: "",
            isAddAppBar: false,
            isLoading: _isLoading,
            isAddBack: false,
            addHeader: false,
            isSkipLater: true,
            addBottomArrows: isBottomButtonsShow,
            onSkipForTap: () {
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateDocuments([]);
              Navigator.of(context).pushNamed(Routes.routeUploadDiagnosticNew);
            },
            onForwardTap: () {
              List<MedicalDocuments> _selectedMedicalDocs = [];
              if (_selectedDocsList != null && _selectedDocsList.length > 0) {
                _selectedDocsList.forEach((element) {
                  _selectedMedicalDocs.add(MedicalDocuments.fromJson(element));
                });
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .updateDocuments(_selectedMedicalDocs);
              }
              Navigator.of(context).pushNamed(Routes.routeUploadDiagnosticNew);
            },
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                0, 0, 0, isBottomButtonsShow ? spacing70 : spacing20),
            child: ListView(
              children: widgetList(context),
            )));
  }

  List<Widget> widgetList(BuildContext context) {
    List<Widget> formWidget = List();
    formWidget.add(SizedBox(height: spacing10));
    formWidget.add(_uploadMedicalDocumentsBanner(context));
    formWidget.add(SizedBox(height: spacing30));
    formWidget.add(_uploadedDocumentsViews(context));
    return formWidget;
  }

  Widget _uploadedDocumentsViews(BuildContext context) => GridView.builder(
        itemCount: docsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          String document = docsList[index]['medicalDocuments'];

          if (!document.contains('data/')) {
            document =
                ApiBaseHelper.imageUrl + docsList[index]['medicalDocuments'];
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
                  isBottomButtonsShow
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: RoundCornerCheckBox(
                                value:
                                    _selectedDocsList.contains(docsList[index]),
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
                                      Widgets.showConfirmationDialog(
                                          context: context,
                                          description:
                                              "Are you sure to delete this document?",
                                          onLeftPressed: () {
                                            setLoading(true);

                                            _api
                                                .deletePatientMedicalDocs(
                                              token,
                                              docsList[index]['_id'],
                                            )
                                                .whenComplete(() {
                                              setLoading(false);
                                              setState(() => docsList
                                                  .remove(docsList[index]));
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
                                      minWidth: 22.0,
                                      minHeight: 22.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: spacing70,
                      padding: EdgeInsets.symmetric(
                          horizontal: spacing10, vertical: 5),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _uploadMedicalDocumentsBanner(BuildContext context) =>
      (!isFromAppointment)
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
                  Localization.of(context).uploadMedicalDocsLabel,
                  style: TextStyle(
                      fontSize: fontSize15,
                      fontWeight: fontWeightSemiBold,
                      color: Colors.black),
                ),
                subtitle: Text(
                  Localization.of(context).uploadMedicalDocsSubLabel,
                  style: TextStyle(
                      fontSize: fontSize12,
                      fontWeight: fontWeightRegular,
                      color: Color(0xff1b1200)),
                ),
                trailing:
                    Icon(Icons.add, color: AppColors.goldenTainoi, size: 30),
              ),
            )
          : SizedBox();

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
    Widgets.uploadBottomSheet(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Document',
            style: TextStyle(
              color: AppColors.midnight_express,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
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
          SizedBox(height: 39),
          TextField(
            enabled: false,
            controller: documentTypeController,
            decoration: getInputDecoration('What kind of document is this?'),
          ).onClick(onTap: _documentTypeBottomDialog),
          SizedBox(height: 25),
          textField(
            'What is the body part',
            (value) {
              documentName = value;
            },
          ),
          SizedBox(height: 25),
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
                      style:
                          TextStyle(color: AppColors.windsor, fontSize: 16.0),
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
                    if (documentTypeController.text == null ||
                        documentTypeController.text.isEmpty) {
                      Widgets.showToast("Document type can't be empty");
                      return;
                    } else if (documentName == null || documentName.isEmpty) {
                      Widgets.showToast("Document name can't be empty");
                      return;
                    } else if (documentDateController.text == null ||
                        documentDateController.text.isEmpty) {
                      Widgets.showToast("Document date can't be empty");
                      return;
                    } else {
                      setLoading(true);
                      Navigator.pop(context);

                      Map<String, String> fileMap = {};
                      fileMap['name'] = documentName;
                      fileMap['type'] = documentTypeController.text;
                      fileMap['date'] = documentDateController.text;
                      var stream =
                          ByteStream(DelegatingStream(file.openRead()));
                      var length = await file.length();
                      var multipartFile = MultipartFile(
                          'medicalDocuments', stream.cast(), length,
                          filename: file.path);

                      List<MultipartFile> multipartList = [];
                      multipartList.add(multipartFile);

                      _api
                          .multipartPost(
                              ApiBaseHelper.base_url +
                                  'api/patient/medical-documents',
                              token,
                              fileMap,
                              multipartList)
                          .then((value) {
                        documentTypeController.text = '';
                        documentDateController.text = '';

                        getMedicalDocuments(isAdd: true);
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

  void _documentTypeBottomDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _documentTypeList.length,
            itemBuilder: (context, index) {
              String docType = _documentTypeList[index];
              return ListTile(
                title: Center(
                  child: Text(
                    docType,
                    style: TextStyle(
                      color: docType == documentTypeController.text
                          ? AppColors.goldenTainoi
                          : Colors.black,
                      fontSize:
                          docType == documentTypeController.text ? 20.0 : 16.0,
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

  Widget textField(String label, Function onChanged) {
    return TextField(
      onChanged: onChanged,
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

  Future getImage(int source) async {
    ImagePicker _picker = ImagePicker();

     XFile image = await _picker.pickImage(
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
        uploadDocsBottomSheet(File(croppedFile.path));
      }
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
