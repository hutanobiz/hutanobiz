import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  InheritedContainerState _container;

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

    _container = InheritedContainer.of(context);
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
      body: LoadingBackground(
        title: "Upload Documents",
        isAddAppBar: isBottomButtonsShow,
        isLoading: _isLoading,
        isAddBack: false,
        addBackButton: isBottomButtonsShow,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 20, 20, isBottomButtonsShow ? 20 : 20),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 65),
                    child: ListView(
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
                              title: "upload document(s)",
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
                          if (_selectedDocsList != null &&
                              _selectedDocsList.length > 0) {
                            _container.setConsentToTreatData(
                                "docsList", _selectedDocsList);
                          }

                          Navigator.of(context).pushNamed(
                            _container.projectsResponse['serviceType']
                                        .toString() ==
                                    '3'
                                ? Routes.onsiteAddresses
                                : Routes.paymentMethodScreen,
                            arguments: true,
                          );
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
      '\u2022 Do you have a copy of imaging results like an MRI, Xray or CAT Scan report?\n\u2022 Please upload the documents for your provider to review before your appointment.\n\u2022 Once uploaded, your documents will be available anytime you need to refer to them.',
      style: TextStyle(
        fontSize: 14.0,
      ),
    ));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Wrap(
      spacing: 10,
      runSpacing: 20,
      children: images(),
    ));

    return formWidget;
  }

  images() {
    List<Widget> columnContent = [];

    for (Map content in docsList) {
      if (content['medicalDocuments'] != null) {
        String document = content['medicalDocuments'];
        if (!document.contains('data/')) {
          document = ApiBaseHelper.imageUrl + content['medicalDocuments'];
        }

        columnContent.add(
          Container(
            height: 150.0,
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
                  child: document.toLowerCase().endsWith("pdf")
                      ? "ic_pdf".imageIcon()
                      : (document.contains('http') || document.contains('https')
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
                            )),
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
                              value: _selectedDocsList.contains(content),
                              onCheck: (value) {
                                if (value) {
                                  if (!_selectedDocsList.contains(content)) {
                                    setState(() {
                                      _selectedDocsList.add(content);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _selectedDocsList
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
                                        .deletePatientMedicalDocs(
                                      token,
                                      content['_id'],
                                    )
                                        .whenComplete(() {
                                      setLoading(false);
                                      setState(() => docsList.remove(content));
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
                    height: 74,
                    width: 180,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: Colors.grey[100],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          content['name'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Type - ' + content['type'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.60),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Date - ' + content['date'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.60),
                          ),
                        ),
                        SizedBox(width: 5.0),
                      ],
                    ),
                  ).onClick(
                    onTap: () {
                      _selectedDocsList.toString().debugLog();

                      if (!_selectedDocsList.contains(content)) {
                        setState(() {
                          _selectedDocsList.add(content);
                        });
                      } else {
                        setState(() {
                          _selectedDocsList.remove(content);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
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
                    }),
        );
      }
    }

    return columnContent;
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
            'Name of the document',
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
                  onPressed: () {
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

                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url +
                            'api/patient/medical-documents',
                        token,
                        'medicalDocuments',
                        fileMap,
                        file,
                      )
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Picker"),
          content: Text("Select document picker type."),
          actions: <Widget>[
            FlatButton(
              child: Text("Image"),
              onPressed: () {
                Navigator.pop(context);
                showImagePickerDialog();
              },
            ),
            FlatButton(
              child: Text("PDF"),
              onPressed: () {
                getDocumentType();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Picker"),
          content: Text("Select image picker type."),
          actions: <Widget>[
            FlatButton(
              child: Text("Camera"),
              onPressed: () {
                getImage(1);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Gallery"),
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

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
