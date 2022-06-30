import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:provider/provider.dart';

import '../../apis/appoinment_service.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_checkbox.dart';
import 'human_body/human_body.dart';
import 'provider/appoinment_provider.dart';

class GeneralizedPainSymptoms extends StatefulWidget {
  @override
  _GeneralizedPainSymptomsState createState() =>
      _GeneralizedPainSymptomsState();
}

class _GeneralizedPainSymptomsState extends State<GeneralizedPainSymptoms> {
  int _currentStepIndex = 1;
  String? _selectedBodyPart;
  String? _selectedPainDesc;

  @override
  void initState() {
    Future.delayed(Duration.zero, _getSymptoms);
    super.initState();
  }

  void _getSymptoms() {
    final bodySide =
        Provider.of<SymptomsInfoProvider>(context, listen: false).getBodySide();
    final bodyType =
        Provider.of<SymptomsInfoProvider>(context, listen: false).bodyType;

    final request = {'bodySide': bodySide, 'bodyType': bodyType};
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService().getSymtoms(request).then((value) {
      ProgressDialogUtils.dismissProgressDialog();
      Provider.of<SymptomsInfoProvider>(context, listen: false)
          .setSymptomsList(value.symptoms);
    }, onError: (e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        DialogUtils.showAlertDialog(context, e.response!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing10),
              child: HTProgressBar(totalSteps: 5, currentSteps: 2),
            ),
            SizedBox(height: spacing10),
            _buildHeader(),
            Expanded(
              child: _buildSymptomsSteps(),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSteps() => SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: spacing15, vertical: spacing15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  if (_currentStepIndex > 0) _buildStepOne(),
                  SizedBox(height: spacing15),
                  if (_currentStepIndex > 1) _buildStepTwo(),
                ],
              ),
            ),
            Expanded(
              child: HumanBody(
                bodyImage:
                    Provider.of<SymptomsInfoProvider>(context, listen: false)
                        .bodySide,
                isClickable: false,
                highlightPart: _selectedBodyPart,
                selectedPartWithHighlight: true,
              ),
            ),
          ],
        ),
      );

  Widget _buildStepOne() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: _selectedBodyPart != null, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Where are your symptoms ?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                if (_currentStepIndex > 1)
                  _buildBodyPartButton(_selectedBodyPart ?? ''),
                if (_currentStepIndex == 1) ...[
                  _buildBodyPartButton("all Over"),
                  _buildBodyPartButton("left side"),
                  _buildBodyPartButton("right side"),
                  _buildBodyPartButton("leg"),
                  _buildBodyPartButton("stomach"),
                  _buildBodyPartButton("genitals"),
                  _buildBodyPartButton("chest"),
                  _buildBodyPartButton("arm"),
                ],
              ],
            ),
          ),
        ],
      );

  Widget _buildBodyPartButton(String title) =>
      _buildButton(title, _selectedBodyPart, () {
        setState(() {
          _selectedBodyPart = title;
        });
        if(_currentStepIndex <= 1){
          setState(() {
            _currentStepIndex++;
          });
        }
      });

  Widget _buildStepTwo() {
    var list = Provider.of<SymptomsInfoProvider>(context, listen: false)
        .getSymptomsByBodyPart(_selectedBodyPart);
    var symptomslist = <Widget>[];
    for (var symptom in list) {
      symptomslist.add(_buildDescPainButton(symptom));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HutanoCheckBox(
            isChecked: _selectedPainDesc != null, onValueChange: null),
        SizedBox(width: spacing15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing5),
                child: Text(
                  "Describe symptoms",
                  style: TextStyle(
                      fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                ),
              ),
              ...symptomslist,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescPainButton(String title) =>
      _buildButton(title, _selectedPainDesc, () {
        setState(() {
          _selectedPainDesc = title;
        });
      });

  Widget _buildButton(String title, String? selectedTitle, Function onTap) =>
      InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeightMedium,
                fontSize: fontSize10),
          ),
          alignment: Alignment.center,
          height: 18,
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: colorDarkgrey2, width: 1),
              color: selectedTitle == title
                  ? colorDarkgrey2
                  : colorGreyBackground),
        ),
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing20),
        child: Row(
          children: [
            Expanded(
              child: HutanoButton(
                label: Localization.of(context)!.skip,
                color: primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed( routeMedicineInformation);
                },
              ),
            ),
            SizedBox(width: spacing70),
            Expanded(
              child: HutanoButton(
                label: Localization.of(context)!.next,
                onPressed: () {
                  switch (_currentStepIndex) {
                    case 1:
                      if (_selectedBodyPart != null) {
                        setState(() {
                          _currentStepIndex++;
                        });
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please select body part");
                      }
                      break;
                    case 2:
                      if (_selectedPainDesc != null) {
                        Provider.of<SymptomsInfoProvider>(context,
                                listen: false)
                            .setGeneralSysptomDetails(
                                bodypart: _selectedBodyPart,
                                bodyPartPain: _selectedPainDesc);
                        Navigator.of(context).pushNamed( routeSymptomsInformation,
                            arguments: {
                              ArgumentConstant.argSeletedSymptomsType: 1
                            });
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please describe the pain");
                      }
                      break;
                    default:
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildHeader() => Container(
        height: 74,
        decoration: BoxDecoration(
            color: colorGreyBackground,
            borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            _buildHeaderButton(0, FileConstants.icCreateFolder,
                Localization.of(context)!.painSymptoms),
            Container(
              width: 0.5,
              margin: EdgeInsets.symmetric(vertical: 20),
              height: double.maxFinite,
              color: Colors.black,
            ),
            _buildHeaderButton(1, FileConstants.icSadFace,
                Localization.of(context)!.generalizedSymptoms)
          ],
        ),
      );

  Widget _buildHeaderButton(int index, String iconName, String title) =>
      Expanded(
        child: Row(
          children: [
            SizedBox(width: spacing15),
            Image.asset(
              iconName,
              height: 20,
              width: 20,
            ),
            SizedBox(width: spacing5),
            Text(
              title,
              style: TextStyle(
                  color: index == 0 ? accentColor : colorGreen,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                  decoration: 1 == index
                      ? TextDecoration.underline
                      : TextDecoration.none),
            )
          ],
        ),
      );
}
