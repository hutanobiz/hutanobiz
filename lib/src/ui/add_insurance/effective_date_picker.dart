
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/date_picker.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/utils/size_config.dart';
import 'package:hutano/src/widgets/hutano_textfield.dart';


class EffectiveDatePicker extends StatelessWidget {
  final Function onDateSelected;
  final TextEditingController controller;
  final FocusNode focusNode;

  EffectiveDatePicker({Key key, this.onDateSelected, this.controller, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var selectedDate = await showCustomDatePicker(
            context: context,
            firstDate: DateTime.now(),
                );
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
