import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/show_common_upload_dialog.dart';
import 'package:hutano/widgets/text_with_image.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/localization/localization.dart';

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
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadTestDocuments extends StatefulWidget {
  @override
  _UploadTestDocumentsState createState() => _UploadTestDocumentsState();
}

class _UploadTestDocumentsState extends State<UploadTestDocuments> {
  List<MedicalDocuments> _allDocuments = List();
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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
      });
      _getUploadedImages(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
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
          Navigator.of(context).pushNamed(Routes.routeMedicineInformation);
        },
        padding: EdgeInsets.only(bottom: spacing70),
        child: Column(
          children: <Widget>[
            _myDocumentHeader(context),
            _myDocumentSubHeader(context),
            _uploadFileHeader(context),
            _buildDocumentList(context),
          ],
        ),
      ),
    );
  }

  Widget _myDocumentHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: spacing20, left: spacing20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            Localization.of(context).myDocumentsHeader,
            style: TextStyle(
                fontSize: fontSize16,
                fontWeight: fontWeightBold,
                color: colorDarkBlack),
          ),
        ),
      );

  Widget _myDocumentSubHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: spacing10, left: spacing20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            Localization.of(context).myDocumentsSubHeader,
            style: TextStyle(
                fontSize: fontSize12,
                fontWeight: fontWeightRegular,
                color: colorBlack2),
          ),
        ),
      );

  Widget _uploadFileHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: spacing20, left: spacing20),
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

  Widget _buildDocumentList(BuildContext context) => _indicatorLoading
      ? Expanded(
          child: Center(
            child: CustomLoader(),
          ),
        )
      : !_getData && !_indicatorLoading
          ? Expanded(
              child: Center(
                child: Text(
                  Localization.of(context).noMedicalDocumentsFound,
                  style: TextStyle(
                      fontSize: fontSize16,
                      color: colorBlack2,
                      fontWeight: fontWeightSemiBold),
                ),
              ),
            )
          : Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        spacing20, spacing8, spacing20, spacing8),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: _allDocuments.length,
                        itemBuilder: (context, index) {
                          return PopupMenuButton(
                            offset: Offset(300, 50),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              _popMenuCommonItem(
                                  context,
                                  Localization.of(context).view,
                                  FileConstants.icView),
                              _popMenuCommonItem(
                                  context,
                                  Localization.of(context).remove,
                                  FileConstants.icRemoveBlack)
                            ],
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: Image.network(
                                  ApiBaseHelper.imageUrl +
                                      _allDocuments[index].medicalDocuments,
                                  width: 40,
                                  height: 35),
                              title: Text(_allDocuments[index].name,
                                  style: TextStyle(
                                      fontWeight: fontWeightSemiBold,
                                      fontSize: fontSize14,
                                      color: colorBlack2)),
                              //TODO SIZE DATA NEED TO SHOW AFTER API CHANGES AVAILABLE FOR BACKEND
                              subtitle: Text("---+---",
                                  style: TextStyle(
                                      fontWeight: fontWeightRegular,
                                      fontSize: fontSize12,
                                      color: colorBlack2)),
                              trailing: Icon(Icons.more_vert),
                            ),
                            onSelected: (value) {
                              debugPrint("${value.runtimeType}");
                              _popUpMenuSelected(context, value, index);
                            },
                          );
                        }),
                  ),
                  SizedBox(height: spacing10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DottedBorder(
                        padding: EdgeInsets.all(spacing20),
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        color: AppColors.windsor,
                        child: _uploadDocumentsButton(context),
                        strokeWidth: 1,
                        dashPattern: [8, 8]),
                  ),
                  SizedBox(height: spacing10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      Localization.of(context).uploadFileLowerLabel,
                      style: TextStyle(
                          fontSize: fontSize12,
                          fontWeight: fontWeightRegular,
                          color: colorBlack2),
                    ),
                  )
                ],
              ),
            );

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
        value: value,
        textStyle: const TextStyle(
            color: colorBlack2,
            fontWeight: fontWeightRegular,
            fontSize: spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: spacing5,
            ),
            Text(value)
          ],
        ),
      );

  void _popUpMenuSelected(BuildContext context, dynamic value, int index) {
    if (value == Localization.of(context).view) {
      Navigator.of(context).pushNamed(
        Routes.providerImageScreen,
        arguments:
            ApiBaseHelper.imageUrl + _allDocuments[index].medicalDocuments,
      );
    } else {
      setLoading(true);
      _api
          .deletePatientMedicalDocs(
        token,
        _allDocuments[index].sId,
      )
          .whenComplete(() {
        setLoading(false);
        setState(() => _allDocuments.remove(_allDocuments[index]));
      }).futureError((error) {
        setLoading(false);
        error.toString().debugLog();
      });
    }
  }

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
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(14.0),
                    ),),
                    // highlightedBorderColor: AppColors.windsor,
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
                      setLoading(true);
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
                      var multipartFile = MultipartFile(
                          'medicalDocuments', stream.cast(), length,
                          filename: file.path);

                      List<MultipartFile> multipartList = [];
                      multipartList.add(multipartFile);
                      fileMap[ArgumentConstant.sizeKey] = mb.toStringAsFixed(2);
                      _api
                          .multipartPost(
                        ApiBaseHelper.base_url +
                            'api/patient/medical-documents',
                        token,
                        fileMap,
                        multipartList,
                      )
                          .then((value) {
                        documentTypeController.text = '';
                        documentDateController.text = '';

                        _getUploadedImages(context);
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

  void setLoading(bool value) {
    setState(() => _indicatorLoading = value);
  }

  void _getUploadedImages(BuildContext context) async {
    setLoading(true);
    await ApiManager().getPatientUploadedDocumentImages().then((result) {
      if (result is ResUploadedDocumentImagesModel) {
        setState(() {
          _allDocuments = result.response.medicalDocuments;
        });
        _getData = _allDocuments.isNotEmpty;
      }
      setLoading(false);
    }).catchError((dynamic e) {
      setLoading(false);
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
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
}
