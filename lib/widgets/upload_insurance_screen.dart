import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/dashed_border.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';



class UploadInsuranceScreen extends StatefulWidget {
  final Function onUpload;

  const UploadInsuranceScreen({Key key, this.onUpload}) : super(key: key);
  @override
  _UploadInsuranceScreenState createState() => _UploadInsuranceScreenState();
}

class _UploadInsuranceScreenState extends State<UploadInsuranceScreen> {
  File croppedFile;
  String frontImagePath, backImagePath;
  File _frontImageFile, _backImageFile;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          child: DashedBorder(
              onTap: () {
                showPickerDialog(true);
              },
              child: frontImagePath == null
                  ? uploadWidget(
                      "Front", AssetImage("images/ic_front_image.png"))
                  : imageWidget(
                      frontImagePath,
                      true,
                    )),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: DashedBorder(
              onTap: () {
                showPickerDialog(false);
              },
              child: backImagePath == null
                  ? uploadWidget("Back", AssetImage("images/ic_back_image.png"))
                  : imageWidget(
                      backImagePath,
                      false,
                    )),
        ),
      ],
    ));
  }

  Widget imageWidget(String path, bool isFront) {
    return Container(
      height: 100.0,
      width: 180.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: (path.contains('http') || path.contains('https'))
                ? Image.network(
                    path,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(path),
                    width: double.maxFinite,
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
                    var frontPath = isFront ? null : _frontImageFile;
                    var backPath = !isFront ? null : _backImageFile;

                    widget.onUpload(frontPath, backPath);
                    setState(
                      () => isFront
                          ? frontImagePath = null
                          : backImagePath = null,
                    );
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
        ],
      ),
    );
  }

  Widget uploadWidget(title, image) {
    return SizedBox(
      height: 70.0,
      width: MediaQuery.of(context).size.width / 2.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Image(
              image: image,
              height: 48.0,
              width: 48.0,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.midnight_express,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  void showPickerDialog(bool isFront) {
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
                getImage(isFront, 2);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () {
                getImage(isFront, 3);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage(bool isFront, int source) async {
    ImagePicker _picker = ImagePicker();

    PickedFile image = await _picker.getImage(
        imageQuality: 25,
        source: (source == 2) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);

      croppedFile = await ImageCropper.cropImage(
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
        var frontPath = isFront ? croppedFile : _frontImageFile;
        var backPath = !isFront ? croppedFile : _backImageFile;
        widget.onUpload(frontPath, backPath);
        if (isFront) {
          _frontImageFile = frontPath;
        } else {
          _backImageFile = backPath;
        }
        setState(
          () => isFront
              ? frontImagePath = croppedFile.path
              : backImagePath = croppedFile.path,
        );
      }
    }
  }
}
