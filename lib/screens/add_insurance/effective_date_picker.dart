import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/date_picker.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/size_config.dart';
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
            firstDate: DateTime(DateTime.now().year - 20, DateTime.now().month,
                DateTime.now().day));

        if (selectedDate != null) {
          var date = formattedDate(selectedDate, ddMMMMyyyy);
          onDateSelected(date);
        }
      },
      child: Container(
        child: HutanoTextField(
            width: SizeConfig.screenWidth / 2.4,
            focusNode: focusNode,
            labelText: Localization.of(context).effectiveDate,
            controller: controller,
            labelTextStyle: TextStyle(fontSize: fontSize14, color: colorGrey60),
            isFieldEnable: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next),
      ),
    );
  }
}
