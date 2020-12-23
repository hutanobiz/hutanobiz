import 'package:flutter/material.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/hutano_textfield.dart';

class DateOfBirth extends StatelessWidget {
  final Function onDateSelected;
  final TextEditingController controller;

  DateOfBirth({Key key, this.onDateSelected, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var selectedDate = await showCustomDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month,
                DateTime.now().day));
        if (selectedDate != null) {
          var date = formattedDate(selectedDate, ddMMMMyyyy);
          onDateSelected(date);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top:spacing15),
        child: HutanoTextField(
            focusNode: FocusNode(),
            labelText: Localization.of(context).dob,
            controller: controller,
            suffixIcon: FileConstants.icDob,
            isFieldEnable: false,
            suffixheight: spacing18,
            suffixwidth: spacing18,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next),
      ),
    );
  }
}
