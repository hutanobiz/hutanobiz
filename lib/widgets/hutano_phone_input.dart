import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/hutano_textfield.dart';

class HutanoPhoneInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function? validationMethod;
  final Function? onValueChanged;
  final ValueSetter<CountryCode>? onCountryChanged;
  final Function? onFieldSubmitied;
  final String? intialSelection;

  const HutanoPhoneInput(
      {Key? key,
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
          width: 60,
          height: 50,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: SizedBox.fromSize(
                      size: Size(24, 24),
                      child: ClipRRect(
                          child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/usFlag.png',
                        ),
                      )))
                  // child: CountryCodePicker(

                  //   builder: (code) => SizedBox.fromSize(
                  //     size: Size(24, 24),
                  //     child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(5),
                  //         child: Image(
                  //           fit: BoxFit.cover,
                  //           image: AssetImage(code.flagUri,
                  //               package: FileConstants.libCountryPicker),
                  //         )),
                  //   ),
                  //   onChanged: onCountryChanged,
                  //   hideMainText: true,
                  //   showFlagMain: true,
                  //   showFlag: true,
                  //   enabled: false,
                  //   initialSelection: 'US',
                  //   hideSearch: false,
                  //   showCountryOnly: false,
                  //   showOnlyCountryWhenClosed: true,
                  //   showFlagDialog: true,
                  //   alignLeft: false,
                  // ),
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
            FilteringTextInputFormatter.digitsOnly,
            _mobileFormatter,
          ],
          width: MediaQuery.of(context).size.width - 120,
          labelText: "Phone Number",
          isDense: true,
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
