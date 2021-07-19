import 'package:flutter/material.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearch;
  SearchBar({Key key, this.controller, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorGrey60,
        width: 0.5,
      ),
    );
    return Container(
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          isDense: true,
          fillColor: colorBlack2.withOpacity(0.05),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus.unfocus();
              onSearch();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                FileConstants.icSearchBlack,
                height: 20,
                width: 20,
              ),
            ),
          ),
          hoverColor: colorGrey84,
          border: border,
          focusedBorder: border,
          hintText: Localization.of(context).search,
        ),
        onChanged: (val) {
          if (val.length == 0 || val.length > 2) {
            onSearch();
          }
        },
        onFieldSubmitted: (val) {
          FocusManager.instance.primaryFocus.unfocus();
          onSearch();
        },
      ),
    );
  }
}