import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_utils.dart';
import '../utils/constants/file_constants.dart';
import '../utils/dimens.dart';
import '../utils/localization/localization.dart';
import '../utils/size_config.dart';
import '../utils/utils.dart';
import 'hutano_textfield.dart';

class HutanoPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function validationMethod;
  final Function onValueChanged;
  final ValueSetter<CountryCode> onCountryChanged;
  final Function onFieldSubmitied;
  final String intialSelection;

  const HutanoPhoneInput(
      {Key key,
      this.controller,
      this.focusNode,
      this.validationMethod,
      this.onValueChanged,
      this.onCountryChanged,
      this.intialSelection,
      this.onFieldSubmitied})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mobileFormatter = NumberTextInputFormatter();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: spacing60,
          height: spacing50,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: colorBlack20,
              ),
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: spacing10, horizontal: spacing4),
                child: CountryCodePicker(
                  builder: (code) => SizedBox.fromSize(
                    size: Size(24, 24),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(code.flagUri,
                              package: FileConstants.libCountryPicker),
                        )),
                  ),
                  onChanged: onCountryChanged,
                  hideMainText: true,
                  showFlagMain: true,
                  showFlag: true,
                  initialSelection: 'US',
                  hideSearch: false,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: true,
                  showFlagDialog: true,
                  alignLeft: false,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 14,
              )
            ],
          ),
        ),
        HutanoTextField(
          textInputFormatter: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(14),
            WhitelistingTextInputFormatter.digitsOnly,
            _mobileFormatter,
          ],
          width: SizeConfig.screenWidth - 120,
          labelText: Localization.of(context).labelPhone,
          controller: controller,
          focusNode: focusNode,
          textInputType: TextInputType.phone,
          prefixheight: 20,
          prefixwidth: 20,
          textInputAction: TextInputAction.done,
          isNumberField: true,
          validationMethod: validationMethod,
          prefixIcon: FileConstants.icCall,
          onFieldSubmitted: onFieldSubmitied,
          onValueChanged: onValueChanged,
        )
      ],
    );
  }
}
