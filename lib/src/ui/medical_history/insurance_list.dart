import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../apis/api_manager.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/hutano_button.dart';
import '../auth/register/model/res_insurance_list.dart';
import 'model/req_add_my_insurace.dart';

class InsuranceList extends StatefulWidget {
  @override
  _InsuranceListState createState() => _InsuranceListState();
}

class _InsuranceListState extends State<InsuranceList> {
  List<Insurance> _insuranceList = [];
  int _selectedCardIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getInsuranceList());
  }

  _getInsuranceList() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().insuraceList();
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        _insuranceList = res.response;
      });
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  _addInsurance() async {
    Navigator.of(context).pop(
        {ArgumentConstant.member: _insuranceList[_selectedCardIndex]});
    return;
    // ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddMyInsurance(
        insuranceId: _insuranceList[_selectedCardIndex].sId,
        userId: getString(PreferenceKey.id));
    try {
      var res = await ApiManager().addInsurance(request);
      ProgressDialogUtils.dismissProgressDialog();

      Navigator.of(context).pop(
          {ArgumentConstant.member: _insuranceList[_selectedCardIndex]});
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildList(),
          Spacer(),
          _addButton(),
          SizedBox(
            height: spacing20,
          )
        ],
      ),
    );
  }

  Widget _addButton() {
    return HutanoButton(
      onPressed: _addInsurance,
      label: Localization.of(context).add,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _insuranceList.length,
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          padding: EdgeInsets.all(spacing8),
          child: Row(
            children: [
              Image.asset(
                FileConstants.icInsuranceShield,
                height: 64,
                width: 64,
              ),
              SizedBox(width: spacing15),
              Expanded(
                child: Text(
                  _insuranceList[index].title,
                  style: TextStyle(
                    fontSize: fontSize14,
                    fontWeight: fontWeightMedium,
                  ),
                ),
              ),
              Radio(
                  value: index,
                  groupValue: _selectedCardIndex,
                  onChanged: (newvalue) {
                    setState(() {
                      _selectedCardIndex = newvalue;
                      setState(() {});
                    });
                  })
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       _isInsuranceSelected = !_isInsuranceSelected;
              //     });
              //   },
              //   child:
              //   Container(
              //     height: 16,
              //     width: 16,
              //     child: Container(
              //       margin: EdgeInsets.all(2),
              //       decoration: BoxDecoration(
              //         color: _isInsuranceSelected
              //             ? primaryColor
              //             : Colors.transparent,
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: primaryColor, width: 1.5),
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              // ),
              ,
              SizedBox(width: spacing10),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 30,
                color: colorLightGrey.withOpacity(0.2),
              )
            ],
          ),
        );
      },
    );
  }
}
