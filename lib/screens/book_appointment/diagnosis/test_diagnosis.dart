import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:dotted_border/dotted_border.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/common_res.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';

import '../../../colors.dart';
import '../../../strings.dart';
import 'model/req_add_diagnostic_test_model.dart';
import 'model/res_diagnostic_model.dart';

class TestDiagnosisScreen extends StatefulWidget {
  @override
  _TestDiagnosisScreenState createState() => _TestDiagnosisScreenState();
}

class _TestDiagnosisScreenState extends State<TestDiagnosisScreen> {
  bool _isTookDiagnosticTest = false;
  List<ResDiagnosticModel> _diagnosisList = [];
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _diagnosisList.add(ResDiagnosticModel("MRI", false));
    _diagnosisList.add(ResDiagnosticModel("X-Ray", false));
    _diagnosisList.add(ResDiagnosticModel("CAT Scan", false));
    _diagnosisList.add(ResDiagnosticModel("Labs", false));
    _diagnosisList.add(ResDiagnosticModel("Bone Scan", false));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
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
            onForwardTap: () {
              if (_isTookDiagnosticTest) {
                _forwardButtonPressed(context);
              } else {
                Navigator.of(context).pushNamed(
                  Routes.routeMedicineInformation,
                );
              }
            },
            isSkipLater: true,
            color: Colors.white,
            isLoading: _isLoading,
            padding:
                EdgeInsets.only(left: spacing20, right: spacing20, bottom: 60),
            onSkipForTap: () {
              Navigator.of(context).pushNamed(
                Routes.routeMedicineInformation,
              );
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _anyDiagnosticTest(context),
                  Row(children: [
                    _yesButtonWidget(context),
                    SizedBox(width: spacing15),
                    _noButtonWidget(context),
                  ]),
                  if (_isTookDiagnosticTest) _howLongAgoWidget(context),
                  _listOfDiagnosticsWidget(context),
                  SizedBox(height: 10),
                  if (_isTookDiagnosticTest)
                    DottedBorder(
                        padding: EdgeInsets.all(spacing15),
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        color: AppColors.windsor,
                        child: _uploadDocumentsButton(context),
                        strokeWidth: 1,
                        dashPattern: [8, 8]),
                ],
              ),
            )));
  }

  Widget _anyDiagnosticTest(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).diagnosticTestHeader,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _yesButtonWidget(BuildContext context) => HutanoButton(
        label: Localization.of(context).yes,
        onPressed: () {
          setState(() {
            _isTookDiagnosticTest = true;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: _isTookDiagnosticTest ? colorWhite : colorPurple100,
        color: _isTookDiagnosticTest ? colorPurple100 : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(BuildContext context) => HutanoButton(
        borderColor: colorGrey,
        label: Localization.of(context).no,
        onPressed: () {
          setState(() {
            _isTookDiagnosticTest = false;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: !_isTookDiagnosticTest ? colorWhite : colorPurple100,
        color: !_isTookDiagnosticTest ? colorPurple100 : colorWhite,
        borderWidth: 1,
        height: 34,
      );

  Widget _howLongAgoWidget(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).typeOfTests,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _listOfDiagnosticsWidget(BuildContext context) =>
      (_isTookDiagnosticTest)
          ? ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, pos) {
                return ListTile(
                  dense: true,
                  title: Row(children: [
                    Text(_diagnosisList[pos].diagnosticTest,
                        style: TextStyle(
                            color: colorBlack2,
                            fontWeight: fontWeightSemiBold,
                            fontSize: fontSize14))
                  ]),
                  trailing: _diagnosisList[pos].isSelected
                      ? Image.asset("images/checkedCheck.png",
                          height: 24, width: 24)
                      : Image.asset("images/uncheckedCheck.png",
                          height: 24, width: 24),
                  onTap: () {
                    setState(() => _diagnosisList[pos].isSelected =
                        !_diagnosisList[pos].isSelected);
                  },
                );
              },
              separatorBuilder: (_, pos) {
                return SizedBox();
              },
              itemCount: _diagnosisList.length)
          : SizedBox();

  Widget _uploadDocumentsButton(BuildContext context) => Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                FileConstants.icUploadDocs,
                height: 18,
                width: 18,
              ),
              SizedBox(width: spacing10),
              Text(Localization.of(context).uploadDocumentsLabel,
                  style: TextStyle(
                      color: AppColors.windsor,
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14)),
            ],
          ),
          SizedBox(height: spacing5),
          Text(Localization.of(context).uploadTypeOfDocLabel,
              style: TextStyle(
                  color: colorBlack2,
                  fontWeight: fontWeightRegular,
                  fontSize: fontSize12)),
          SizedBox(height: spacing5),
          Text(
            Localization.of(context).myHutanoLibLabel,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xff1a5ee1),
                fontWeight: fontWeightRegular,
                fontSize: fontSize12),
          )
        ],
      )).onClick(onTap: () {
        Navigator.of(context).pushNamed(Routes.routeUploadTestDocuments);
      });

  setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
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
                      fileMap[ArgumentConstant.sizeKey] = mb.toStringAsFixed(2);
                      var stream =
                          ByteStream(DelegatingStream(file.openRead()));
                      var length = await file.length();
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

  void _forwardButtonPressed(BuildContext context) {
    List<LongAgo> selectedTests = [];

    _diagnosisList.forEach((element) {
      if (element.isSelected) {
        selectedTests.add(LongAgo(name: element.diagnosticTest));
      }
    });
    if (selectedTests.isNotEmpty) {
      final reqModel = ReqAddDiagnosticTestModel(
          diagnosticTests: Localization.of(context).yes,
          longAgo: selectedTests);
      _addDiagnosticsData(context, reqModel);
    } else {
      Widgets.showToast("Please select any diagnostic tests");
    }
  }

  void _addDiagnosticsData(
      BuildContext context, ReqAddDiagnosticTestModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addDiagnosticsData(reqModel).then(((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        Navigator.of(context).pushNamed(Routes.
          routeUploadTestDocuments,
        );
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
