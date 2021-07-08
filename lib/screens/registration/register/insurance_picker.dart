import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';

import '../../../utils/constants/file_constants.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/hutano_textfield.dart';
import '../../../widgets/list_picker.dart';
import 'model/res_insurance_list.dart';

class InsuranceList extends StatefulWidget {
  final TextEditingController controller;
  final List<Insurance> insuranceList;
  final Function onInsuranceSelected;

  const InsuranceList({
    Key key,
    this.controller,
    this.insuranceList,
    this.onInsuranceSelected,
  }) : super(key: key);
  @override
  _InsuranceListState createState() => _InsuranceListState();
}

class _InsuranceListState extends State<InsuranceList> {
  void _openStatePicker() {
    showDropDownSheet(
        list: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.insuranceList.length,
          itemBuilder: (context, pos) {
            return InkWell(
                onTap: () {
                  widget.onInsuranceSelected(pos);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Center(
                    child: Text(widget.insuranceList[pos].title,
                    textAlign: TextAlign.center,),
                  ),
                ));
          },
        ),
        context: context);
  }

  Widget _getEmailTextField() {
    return Container(
        child: GestureDetector(
      onTap: _openStatePicker,
      child: HutanoTextField(
          focusNode: FocusNode(),
          controller: widget.controller,
          suffixIcon: FileConstants.icDown,
          suffixheight: spacing12,
          suffixwidth: spacing12,
          isFieldEnable: false,
          labelText: Localization.of(context).primaryInsurance,
          textInputAction: TextInputAction.next),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getEmailTextField(),
    );
  }
}
