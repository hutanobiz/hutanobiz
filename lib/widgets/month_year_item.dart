import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_textfield.dart';

class MonthYearItem extends StatefulWidget {
  final String selectedSid;
  final String selectedDisease;
  final YYDialog yyDialog;
  final Function onSavePressed;
  final bool isForUpdate;
  final String month;
  final String year;
  MonthYearItem(
      {this.selectedSid,
      this.selectedDisease,
      this.yyDialog,
      this.onSavePressed,
      this.isForUpdate = false,
      this.month,
      this.year});
  @override
  _MonthYearItemState createState() => _MonthYearItemState();
}

class _MonthYearItemState extends State<MonthYearItem> {
  final List<int> _years = [];
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    if (widget.isForUpdate) {
      _monthController.text = widget.month;
      _yearController.text = widget.year;
    }
    for (var i = DateTime.now().year - 21; i < DateTime.now().year; i++) {
      _years.add(i);
    }
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogHeaderViewWidget(context, widget.selectedDisease),
              _dialogWhenViewWidget(context),
              _buildMonthAndYearDropDownRow(context, _years),
              _addDiseaseButton(context)
            ],
          )),
    );
  }

  Widget _dialogHeaderViewWidget(BuildContext context, String value) => Padding(
        padding: EdgeInsets.only(top: spacing15, left: spacing20),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
                color: colorDarkBlack,
                fontWeight: fontWeightBold,
                fontSize: fontSize20),
          ),
        ),
      );

  Widget _dialogWhenViewWidget(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: spacing10, left: spacing20),
        child: Text(
          Localization.of(context).whenLabel,
          style: TextStyle(
              color: colorBlack2,
              fontWeight: fontWeightBold,
              fontSize: fontSize18),
        ),
      );

  Widget _buildMonthAndYearDropDownRow(BuildContext context, List<int> years) =>
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: spacing10, vertical: spacing20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildDropDownBottomSheet(context, AppConstants.months, []),
            _buildDropDownBottomSheet(context, [], years)
          ],
        ),
      );

  _buildDropDownBottomSheet(
          BuildContext context, List<String> months, List<int> years) =>
      InkWell(
        onTap: () {
          Platform.isIOS
              ? _openCupertinoMonthAndYearPickerSheet(context, months, years)
              : _openMaterialMonthAndYearPickerSheet(context, months, years);
        },
        child: HutanoTextField(
          width: (MediaQuery.of(context).size.width - 35) * 0.4,
          hintText: months.isEmpty
              ? Localization.of(context).selectYearHint
              : Localization.of(context).selectMonthHint,
          textInputAction: TextInputAction.next,
          controller: months.isEmpty ? _yearController : _monthController,
          focusNode: months.isEmpty ? _yearFocus : _monthFocus,
          textInputType: TextInputType.text,
          suffixIcon: FileConstants.icDownArrow,
          suffixheight: 20,
          suffixwidth: 20,
          isFieldEnable: false,
          onFieldSubmitted: (value) {
            months.isEmpty ? _yearFocus.unfocus() : _monthFocus.unfocus();
            FocusScope.of(context).requestFocus(FocusNode());
          },
          validationMethod: (value) {
            if (months.isEmpty) {
              if (value.isEmpty) {
                return Localization.of(context).selectYearError;
              }
            } else {
              if (value.isEmpty) {
                return Localization.of(context).selectMonthError;
              }
            }
          },
        ),
      );

  _openCupertinoMonthAndYearPickerSheet(
          BuildContext context, List<String> months, List<int> years) =>
      showModalBottomSheet(
          context: context,
          builder: (context) => Container(
                height: MediaQuery.of(context).size.height / 4,
                child: CupertinoPicker(
                  magnification: 1.0,
                  children: months.isEmpty
                      ? years
                          .map((year) => ListTile(
                                title: Center(
                                    child: Text(
                                  "$year",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                )),
                              ))
                          .toList()
                      : months
                          .map((month) => ListTile(
                                title: Center(child: Text(month)),
                              ))
                          .toList(),
                  itemExtent: spacing50,
                  onSelectedItemChanged: (value) {
                    months.isEmpty
                        ? _yearController.text = "${years[value]}"
                        : _monthController.text = "${months[value]}";
                    Navigator.pop(context);
                  },
                ),
              ));

  _openMaterialMonthAndYearPickerSheet(
          BuildContext context, List<String> months, List<int> years) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
          context: context,
          builder: (context) => Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Wrap(
                  children: <Widget>[
                    _buildChooseMonthAndYearPicker(context, months, years)
                  ],
                ),
              ));

  _buildChooseMonthAndYearPicker(
          BuildContext context, List<String> months, List<int> years) =>
      Column(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                  itemCount: months.isEmpty ? years.length : months.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Center(
                          child: months.isEmpty
                              ? Text(
                                  "${years[index]}",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                )
                              : Text(
                                  "${months[index]}",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                )),
                      onTap: () {
                        months.isEmpty
                            ? _yearController.text = "${_years[index]}"
                            : _monthController.text = "${months[index]}";
                        Navigator.pop(context);
                      },
                    );
                  })),
        ],
      );

  Widget _addDiseaseButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(spacing8),
        child: HutanoButton(
          buttonType: HutanoButtonType.onlyLabel,
          color: colorYellow,
          iconSize: 20,
          label: Localization.of(context).saveLabel,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.yyDialog.dismiss();
              widget.onSavePressed(
                  widget.selectedSid,
                  widget.selectedDisease,
                  _monthController.text,
                  int.parse(_yearController.text.toString()),
                  widget.isForUpdate);
            } else {
              setState(() {
                _autoValidate = true;
              });
            }
          },
        ),
      );
}
