import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/list_picker.dart';

class InsuranceList extends StatefulWidget {
  final TextEditingController? controller;
  final List<Insurance>? insuranceList;
  final Function? onInsuranceSelected;

  const InsuranceList({
    Key? key,
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
          itemCount: widget.insuranceList!.length,
          itemBuilder: (context, pos) {
            return InkWell(
                onTap: () {
                  widget.onInsuranceSelected!(pos);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Center(
                    child: Text(
                      widget.insuranceList![pos].title!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ));
          },
        ),
        context: context);
  }

  Widget _buildAddressField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          onTap: () {
            // showError(RegisterError.password.index);
          },
          onChanged: (value) {
            // _registerModel.address = value;
            // setState(() {
            //   addressError = value
            //       .toString()
            //       .isBlank(context, Localization.of(context).errorEnterAddress);
            // });
          },
          decoration: InputDecoration(
              // errorText: addressError,
              suffixIconConstraints: BoxConstraints(),
              suffixIcon: GestureDetector(
                onTap: () {
                  widget.controller!.text = "";
                },
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Image.asset(
                    FileConstants.icClose,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              labelText: Localization.of(context)!.insuranceCompany,
              hintText: "",
              isDense: true,
              hintStyle: TextStyle(color: colorBlack60, fontSize: fontSize14),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              labelStyle: TextStyle(fontSize: fontSize14, color: colorGrey60))),
      suggestionsCallback: (pattern) async {
        return pattern.length > 0 ? _getFilteredInsuranceList() : [];
      },
      keepSuggestionsOnLoading: false,
      loadingBuilder: (context) => CustomLoader(),
      errorBuilder: (_, object) {
        return Container();
      },
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          title: Text(suggestion.title),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        widget.onInsuranceSelected!(suggestion.title, suggestion.sId);
        // widget.controller.text = suggestion.title;
      },
      hideOnError: true,
      hideSuggestionsOnKeyboardHide: true,
      hideOnEmpty: true,
    );
  }

  _getFilteredInsuranceList() {
    return widget.insuranceList!.where((element) => element.title!
        .toLowerCase()
        .contains(widget.controller!.text.toLowerCase()));
  }

  Widget _getEmailTextField() {
    return Container(
        child: GestureDetector(
      onTap: _openStatePicker,
      child: HutanoTextField(
          focusNode: FocusNode(),
          controller: widget.controller,
          suffixIcon: FileConstants.icDown,
          labelTextStyle: TextStyle(fontSize: fontSize14, color: colorGrey60),
          suffixheight: spacing12,
          suffixwidth: spacing12,
          isFieldEnable: false,
          labelText: Localization.of(context)!.insuranceCompany,
          textInputAction: TextInputAction.next),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: _getEmailTextField(),
      child: _buildAddressField(),
    );
  }
}
