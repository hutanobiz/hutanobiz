import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import 'provider/appoinment_provider.dart';

class UploadTestDocuments extends StatefulWidget {
  @override
  _UploadTestDocumentsState createState() => _UploadTestDocumentsState();
}

class _UploadTestDocumentsState extends State<UploadTestDocuments> {
  String _selectedType;
  List<String> testlist = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        testlist = Provider.of<SymptomsInfoProvider>(context, listen: false)
            .diagnosticTests;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing10),
            _buildContent(),
            SizedBox(height: spacing15),
            _buildUploadButton(),
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
                child: HTProgressBar(totalSteps: 5, currentSteps: 4),
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
              _buildTestList()
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
          padding: EdgeInsets.only(left: spacing50, right: spacing20),
          itemCount: testlist.length,
          itemBuilder: testItemBuilder,
        ),
      );

  Widget testItemBuilder(BuildContext context, int index) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedType = testlist[index];
            });
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: _selectedType == testlist[index]
                      ? primaryColor
                      : Colors.transparent),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 55,
                  decoration: BoxDecoration(
                    color: accentColor,
                    border: Border.all(color: primaryColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        testlist[index].substring(0, 2),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize16,
                            fontWeight: fontWeightBold),
                      ),
                      Text(
                        testlist[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSize10, fontWeight: fontWeightMedium),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing15),
                Expanded(
                  child: Text(
                    testlist[index],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize16,
                        fontWeight: fontWeightBold),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _buildUploadButton() => HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        icon: FileConstants.icupload,
        width: screenSize.width * 0.6,
        iconSize: 22,
        label: "Upload Documents",
        color: primaryColor,
        onPressed: () async {
          if (_selectedType != null) {
            Navigator.of(context).pushNamed(
              routeTestDocumentsList,
              arguments: {
                ArgumentConstant.documentType: _selectedType,
              },
            );
          } else {
            DialogUtils.showAlertDialog(
                context, "Please select any one option from above");
          }
        },
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing20),
        child: Row(
          children: [
            Expanded(
              child: HutanoButton(
                label: Localization.of(context).skip,
                color: primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed( routePaymentMethods);
                },
              ),
            ),
            SizedBox(width: spacing70),
            Expanded(
              child: HutanoButton(
                label: Localization.of(context).next,
                onPressed: () {
                  Navigator.of(context).pushNamed( routePaymentMethods);
                },
              ),
            ),
          ],
        ),
      );
}
