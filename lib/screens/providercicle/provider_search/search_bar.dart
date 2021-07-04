import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/file_constants.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearch;
  SearchBar({Key key, this.controller, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color:  AppColors.colorGrey60,
        width: 0.5,
      ),
    );
    return Container(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          fillColor:  AppColors.colorBlack2.withOpacity(0.05),
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
          hoverColor:  AppColors.colorGrey84,
          border: border,
          focusedBorder: border,
          hintText: Strings.search,
        ),
      ),
    );
  }
}