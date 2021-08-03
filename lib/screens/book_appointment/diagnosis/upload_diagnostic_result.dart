import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import '../../../strings.dart';
import 'model/res_diagnostic_test_result.dart';

class UploadDiagnosticResult extends StatefulWidget {
  @override
  _UploadDiagnosticResultState createState() => _UploadDiagnosticResultState();
}

class _UploadDiagnosticResultState extends State<UploadDiagnosticResult> {
  bool _indicatorLoading = true;
  List<MedicalDocuments> medicalDocuments;
  final documentTypeController = TextEditingController();
  final documentDateController = TextEditingController();
  String documentName = '';
  ApiBaseHelper _api = ApiBaseHelper();
  String token;
  List<String> _documentTypeList = [
    'X-Ray',
    'MRI',
    'CAT Scan',
    'Labs',
    'Ultrasound',
    'EKG',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
      });
      _getUploadedDiagnosticTest(context);
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
            onForwardTap: () {
              Navigator.of(context).pushNamed(Routes.routeUploadTestDocuments);
            },
            isSkipLater: true,
            onSkipForTap: () {
              Navigator.of(context).pushNamed(
                Routes.routeMedicineInformation,
              );
            },
            padding: EdgeInsets.only(bottom: spacing60),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _anyDiagnosticTest(context),
                medicalDocuments != null
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20);
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: medicalDocuments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: showPickerDialog,
                            leading: Image.network(
                                ApiBaseHelper.imageUrl +
                                    medicalDocuments[index]?.medicalDocuments,
                                width: 50,
                                height: 50),
                            title: Text(
                              "Upload ${medicalDocuments[index]?.type} result",
                              style: TextStyle(
                                  fontSize: fontSize14,
                                  fontWeight: fontWeightSemiBold,
                                  color: colorBlack2),
                            ),
                            trailing: Image.asset(
                              FileConstants.icCamera,
                              width: spacing20,
                              height: spacing20,
                              color: AppColors.goldenTainoi,
                            ),
                          );
                        })
                    : Center(child: CustomLoader())
              ],
            ))));
  }

  Widget _anyDiagnosticTest(BuildContext context) => Padding(
        padding:
            EdgeInsets.symmetric(vertical: spacing20, horizontal: spacing20),
        child: Text(
          "Upload the results of the diagnostic test results",
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  void showPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Localization.of(context).picker),
          content: Text(Localization.of(context).selectDocPickerTypeLabel),
          actions: <Widget>[
            FlatButton(
              child: Text(Localization.of(context).imageLabel),
              onPressed: () {
                Navigator.pop(context);
                showImagePickerDialog();
              },
            ),
            FlatButton(
              child: Text(Localization.of(context).pdfLabel),
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
          title: Text(Localization.of(context).picker),
          content: Text(Localization.of(context).selectImagePickerTypeLabel),
          actions: <Widget>[
            FlatButton(
              child: Text(Localization.of(context).camera),
              onPressed: () {
                getImage(1);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(Localization.of(context).gallery),
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
                      Map<String, String> fileMap = {};
                      fileMap[ArgumentConstant.nameKey] = documentName;
                      fileMap[ArgumentConstant.typeKey] =
                          documentTypeController.text;
                      fileMap[ArgumentConstant.dateKey] =
                          documentDateController.text;
                      final bytes = file.readAsBytesSync().lengthInBytes;
                      final kb = bytes / 1024;
                      final mb = kb / 1024;
                      var stream =
                          ByteStream(DelegatingStream(file.openRead()));
                      var length = await file.length();
                      fileMap[ArgumentConstant.sizeKey] = mb.toStringAsFixed(2);
                      var multipartFile = MultipartFile(
                          'medicalDocuments', stream.cast(), length,
                          filename: file.path);

                      List<MultipartFile> multipartList = [];
                      multipartList.add(multipartFile);
                      setLoading(true);
                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url +
                            'api/patient/medical-documents',
                        token,
                        fileMap,
                        multipartList,
                      )
                          .then((value) {
                        setLoading(false);
                        documentTypeController.text = '';
                        documentDateController.text = '';
                        _getUploadedDiagnosticTest(context);
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

  void setLoading(bool value) {
    setState(() => _indicatorLoading = value);
  }

  void _getUploadedDiagnosticTest(BuildContext context) async {
    setLoading(true);
    await ApiManager().getUploadedDiagnosticTestResults().then((result) {
      if (result is ResDiagnosticTestResult) {
        setState(() {
          medicalDocuments = result.response[0].medicalDocuments;
        });
      }
      setLoading(false);
    }).catchError((dynamic e) {
      setLoading(false);
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
