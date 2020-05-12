import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide context;

class UploadDocumentsScreen extends StatefulWidget {
  @override
  _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  File croppedFile;

  List<File> docsList = List();
  InheritedContainerState _container;

  bool _isLoading = false;
  Map<String, String> filesPaths;
  var document;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Upload Documents",
        isLoading: _isLoading,
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          if (docsList != null && docsList.length > 0) {
            _container.setConsentToTreatData("docsList", docsList);

            Navigator.of(context).pushNamed(Routes.reviewAppointmentScreen);
          } else {
            Widgets.showToast("Please upload documents");
          }
        },
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 65),
              child: ListView(
                children: widgetList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 55.0,
                child: FancyButton(
                  title: "Upload Docs",
                  buttonIcon: "ic_upload",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    showPickerDialog();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = List();

    formWidget.add(Text(
      "Medical documents, including imaging documents like x-ray and MRI reports can be uploaded for your provider to review to understand your condition and provide appropriate care.",
      style: TextStyle(
        fontSize: 14.0,
      ),
    ));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Wrap(
      spacing: 16,
      runSpacing: 20,
      children: images(),
    ));

    return formWidget;
  }

  images() {
    List<Widget> columnContent = [];

    for (File content in docsList) {
      columnContent.add(
        InkWell(
          onTap: () {},
          child: Container(
            height: 125.0,
            width: 160.0,
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
                  child: content.path.toLowerCase().endsWith("pdf")
                      ? "ic_pdf".imageIcon()
                      : Image.file(
                          File(content.path),
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
                          setState(() {
                            docsList.remove(content);
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
                    height: 46,
                    padding: const EdgeInsets.all(10.0),
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
                        content.path.toLowerCase().endsWith("pdf")
                            ? "ic_pdf".imageIcon()
                            : "ic_image".imageIcon(),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            basename(content.path),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return columnContent;
  }

  void getDocumentType() async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    setState(() {
      if (file != null) docsList.add(file);
    });
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
    var image = await ImagePicker.pickImage(
        imageQuality: 25,
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      croppedFile = await ImageCropper.cropImage(
        compressQuality: 25,
        sourcePath: image.path,
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
        ),
      );
      if (croppedFile != null) {
        setState(() => docsList.add(croppedFile));
      }
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
