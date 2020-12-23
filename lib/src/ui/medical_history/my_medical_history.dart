import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/appoinment_service.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_checkbox.dart';
import 'model/medical_history_disease.dart';
import 'provider/appoinment_provider.dart';

class MyMedicalHistory extends StatefulWidget {
  @override
  _MyMedicalHistoryState createState() => _MyMedicalHistoryState();
}

class _MyMedicalHistoryState extends State<MyMedicalHistory> {
  List<Disease> diseaselist = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, _getDiseaseList);
    super.initState();
  }

  void _getDiseaseList() {
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService().getMedicalHistory().then((value) {
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        diseaselist = value.disease;
      });
    }, onError: (e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        DialogUtils.showAlertDialog(context, e.response);
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
            _buildContent(),
            Padding(
              padding: EdgeInsets.all(spacing20),
              child: HutanoButton(
                  label: Localization.of(context).next,
                  onPressed: () {
                    var list = diseaselist
                        .where((element) => element.isChecked == true)
                        .toList();
                    Provider.of<SymptomsInfoProvider>(context, listen: false)
                        .setDiasesList(list);
                    final _gender = getInt(PreferenceKey.gender);
                    Provider.of<SymptomsInfoProvider>(context, listen: false)
                        .setBodyType(_gender);

                    NavigationUtils.push(context, routeBodySymptoms);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing10),
                child: HTProgressBar(totalSteps: 5, currentSteps: 1),
              ),
              AppLogo(),
              Padding(
                padding: const EdgeInsets.only(top: spacing20),
                child: Text(
                  Localization.of(context).myMedicalHistory,
                  style: TextStyle(
                      fontSize: fontSize18,
                      fontWeight: fontWeightMedium,
                      color: colorPurple),
                ),
              ),
              SizedBox(height: spacing50),
              ListView.separated(
                padding: EdgeInsets.only(left: spacing20, right: spacing15),
                separatorBuilder: (_, __) => Container(height: 38),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: diseaselist.length,
                itemBuilder: diseaseItemBuilder,
              )
            ],
          ),
        ),
      );

  Widget diseaseItemBuilder(BuildContext context, int index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            diseaselist[index].disease,
            style: TextStyle(
              fontSize: fontSize14,
              fontWeight: fontWeightMedium,
            ),
          ),
          HutanoCheckBox(
              isChecked: diseaselist[index].isChecked,
              onValueChange: (newValue) {
                setState(() {
                  diseaselist[index].isChecked = newValue;
                });
              })
        ],
      );
}
