import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/api_manager.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/navigation.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/reusable_functions.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/hutano_button.dart';
import 'model/req_upload_insurance_document.dart';
import 'provider/appoinment_provider.dart';

class UploadInsuranceImage extends StatefulWidget {
  final String insuranceId;
  const UploadInsuranceImage({this.insuranceId});
  @override
  _UploadInsuranceImageState createState() => _UploadInsuranceImageState();
}

class _UploadInsuranceImageState extends State<UploadInsuranceImage> {
  File _frontImage;
  File _backImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: Container(
        width: double.infinity,
        child: Text(
          "Upload Insurance Image",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize16, fontWeight: fontWeightBold),
        ),
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "upload insurance front and back(optional) images",
                style: TextStyle(
                    fontSize: fontSize16, fontWeight: fontWeightRegular),
              ),
              SizedBox(height: spacing20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        var file = await getImageByGallery(context);
                        if (file != null) {
                          setState(() {
                            _frontImage = file;
                          });
                        }
                      },
                      child: Container(
                        height: screenSize.width / 3,
                        padding: EdgeInsets.all(spacing10),
                        child: _frontImage != null
                            ? Image.file(_frontImage)
                            : Center(
                                child: Text(
                                  "Front",
                                  style: TextStyle(
                                      fontSize: fontSize16,
                                      fontWeight: fontWeightRegular),
                                ),
                              ),
                        decoration: BoxDecoration(
                          border: Border.all(color: accentColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing20),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        var file = await getImageByGallery(context);
                        if (file != null) {
                          setState(() {
                            _backImage = file;
                          });
                        }
                      },
                      child: Container(
                        height: screenSize.width / 3,
                        padding: EdgeInsets.all(spacing10),
                        child: _backImage != null
                            ? Image.file(_backImage)
                            : Center(
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontSize: fontSize16,
                                      fontWeight: fontWeightRegular),
                                ),
                              ),
                        decoration: BoxDecoration(
                          border: Border.all(color: accentColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  HutanoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: FileConstants.icBack,
                    buttonType: HutanoButtonType.onlyIcon,
                  ),
                  SizedBox(
                    width: spacing50,
                  ),
                  Flexible(
                    flex: 1,
                    child: HutanoButton(
                      label: "Upload",
                      onPressed: () {
                        uploadDocument();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void uploadDocument() {
    if (_frontImage == null) {
      DialogUtils.showAlertDialog(context, "Please select front image");
    } else {
      var appoinmentId =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .appoinmentId;
      var req = ReqUploadInsuranceDocuments(
          appointmentId: appoinmentId, insuranceId: widget.insuranceId);
      ProgressDialogUtils.showProgressDialog(context);
      ApiManager()
          .uploadInsuranceDoc(_frontImage, req, backImage: _backImage)
          .then((value) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: "Document uploaded successfully",
          okButtonAction: () {
            Navigator.of(context).pop();
          },
          okButtonTitle: 'Ok',
          isCancelEnable: false,
        );
        // DialogUtils.showAlertDialog(context, "Document uploaded successfully");
      }, onError: (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, "Unable to upload document");
      });
    }
  }
}
