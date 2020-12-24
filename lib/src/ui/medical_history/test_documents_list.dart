import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/appoinment_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/date_utils.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/reusable_functions.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import 'model/res_documentlist.dart';
import 'provider/appoinment_provider.dart';

class TestDocumentsList extends StatefulWidget {
  final String type;
  const TestDocumentsList({this.type});
  @override
  _TestDocumentsListState createState() => _TestDocumentsListState();
}

class _TestDocumentsListState extends State<TestDocumentsList> {
  int _selectedPage = 1;
  String appointmentID = "";
  List<Document> documents = [];
  int totalPages = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      appointmentID = Provider.of<SymptomsInfoProvider>(context, listen: false)
          .appoinmentId;
      getList(appointmentID);
    });
    super.initState();
  }

  void getList(String id) {
    // documentListing
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService()
        .documentListing(appoitmetid: id, limit: 5, page: _selectedPage)
        .then(
      (value) {
        ProgressDialogUtils.dismissProgressDialog();
        setState(() {
          documents = value.documents;
          totalPages = (value.count / 5).ceil();
        });
      },
      onError: (e) {
        ProgressDialogUtils.dismissProgressDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildContent(),
            SizedBox(height: spacing15),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing10),
                child: HTProgressBar(totalSteps: 5, currentSteps: 5),
              ),
              AppLogo(),
              SizedBox(height: spacing15),
              Text(
                "My Documents",
                style: TextStyle(
                    fontSize: fontSize13, fontWeight: fontWeightSemiBold),
              ),
              SizedBox(height: spacing10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing40),
                child: Text(
                  "Upload diagnostic tests, and imaging results to help "
                  "your provider understand your condition.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: fontSize12,
                    fontWeight: fontWeightMedium,
                  ),
                ),
              ),
              _buildTestList(),
              _buildPageList(),
            ],
          ),
        ),
      );

  Widget _buildTestList() => Padding(
        padding: const EdgeInsets.only(
          top: spacing50,
          bottom: spacing20,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: documents.length,
          itemBuilder: testItemBuilder,
        ),
      );

  Widget testItemBuilder(BuildContext context, int index) => Container(
        // height: 53,
        margin:
            EdgeInsets.symmetric(vertical: spacing12, horizontal: spacing15),
        padding:
            EdgeInsets.symmetric(horizontal: spacing10, vertical: spacing5),
        decoration: BoxDecoration(
          border: Border.all(color: colorGrey3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(width: spacing15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documents[index].medicalDocuments,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: fontSize16, fontWeight: fontWeightMedium),
                  ),
                  Text(
                    documents[index].date != null
                        ? formatDate(
                            documents[index]
                                .date
                                .substring(0, documents[index].date.length - 4),
                            inputFormat: "E, dd MMM yyyy HH:mm:ss",
                            resultFormat: "MMM d, yyyy",
                          )
                        : '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: colorGrey84,
                        fontSize: fontSize12,
                        fontWeight: fontWeightSemiBold),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 55,
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: colorDarkgrey2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    documents[index].type ?? "xray",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize16,
                        fontWeight: fontWeightBold),
                  ),
                  Text(
                    documents[index].type ?? "xray",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize10,
                        fontWeight: fontWeightMedium),
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.file_upload, color: primaryColor),
                onPressed: () {})
          ],
        ),
      );

  Widget _buildPageList() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacing15),
        child: SizedBox(
          height: 20,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: totalPages,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedPage = index + 1;
                    getList(appointmentID);
                  });
                },
                child: Container(
                  height: 20,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: spacing5),
                  child: Text(
                    "${index + 1}",
                    maxLines: 1,
                    style: TextStyle(
                        color: _selectedPage == (index + 1)
                            ? Colors.black
                            : primaryColor,
                        fontSize: fontSize14,
                        fontWeight: fontWeightMedium),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: HutanoButton(
                    buttonType: HutanoButtonType.withPrefixIcon,
                    icon: FileConstants.icupload,
                    width: 100,
                    iconSize: 22,
                    label: "Upload Documents",
                    color: primaryColor,
                    onPressed: () async {
                      //TODO :FIX REPLACE FILEPICKER LIB AND FIX
                      // var result = await FilePicker.platform.pickFiles(
                      //     allowMultiple: false,
                      //     allowCompression: true,
                      //     type: FileType.custom,
                      //     allowedExtensions: ['pdf']);
                      // if (result != null) {
                      //   var file = File(result.files.first.path);
                      //   uploadDocument(file);
                      // }
                    },
                  ),
                ),
                SizedBox(width: spacing20),
                HutanoButton(
                  width: 58,
                  height: 55,
                  color: colorGrey,
                  iconSize: 24,
                  buttonType: HutanoButtonType.onlyIcon,
                  label: Localization.of(context).next,
                  icon: FileConstants.icCamera,
                  onPressed: () async {

                    var file = await getImageByGallery(context);
                    if (file != null) {
                      uploadDocument(file);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: spacing40),
            Row(
              children: [
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context).skip,
                    color: primaryColor,
                    onPressed: () {
                      NavigationUtils.push(context, routePaymentMethods);
                    },
                  ),
                ),
                SizedBox(width: spacing70),
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context).next,
                    onPressed: () {
                    NavigationUtils.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void uploadDocument(File file) {
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService().uploadDocument(file, widget.type, appointmentID).then(
      (value) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: "document uploaded.",
          okButtonAction: () {
            getList(appointmentID);
          },
          okButtonTitle: Localization.of(context).ok,
          isCancelEnable: false,
        );
      },
      onError: (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, "error uploading document");
      },
    );
  }
}
