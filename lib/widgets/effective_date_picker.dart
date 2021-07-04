import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/date_picker.dart';
import 'package:hutano/widgets/hutano_textfield.dart';

class EffectiveDatePicker extends StatelessWidget {
  final Function onDateSelected;
  final TextEditingController controller;
  final FocusNode focusNode;

  EffectiveDatePicker(
      {Key key, this.onDateSelected, this.controller, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var selectedDate = await showCustomDatePicker(
          context: context,
          firstDate: DateTime(DateTime.now().year-20, DateTime.now().month, DateTime.now().day)
        );

        if (selectedDate != null) {
          var date = formattedDate(selectedDate, Strings.ddMMMMyyyy);
          onDateSelected(date);
        }
      },
      child: Container(
        child: HutanoTextField(
            width: MediaQuery.of(context).size.width / 2.4,
            focusNode: focusNode,
            labelText:Strings.effectiveDate,
            controller: controller,
            labelTextStyle: TextStyle(fontSize: 14, color: AppColors.colorGrey60),
            isFieldEnable: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next),
      ),
    );
  }
}
