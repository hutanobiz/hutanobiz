import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/localization/localization.dart';

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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          fillColor: colorBlack2.withOpacity(0.05),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: InkWell(
            onTap: onSearch,
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
      ),
    );
  }
}