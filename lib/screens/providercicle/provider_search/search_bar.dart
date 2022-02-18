import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 40,
      decoration: BoxDecoration(
          color: colorBlack2.withOpacity(0.06),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(),
          prefixIcon: GestureDetector(
              onTap: () {},
              child: Padding(
                  padding: const EdgeInsets.all(spacing8),
                  child: Image.asset(FileConstants.icSearchBlack,
                      color: colorBlack2, width: 20, height: 20))),
          hintText: Localization.of(context).search,
          isDense: true,
          hintStyle: TextStyle(
              color: colorBlack2,
              fontSize: fontSize13,
              fontWeight: fontWeightRegular),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (val) {
          // if (val.length > 0) {
          onSearch();
          // }
        },
        onFieldSubmitted: (val) {
          FocusManager.instance.primaryFocus.unfocus();
          onSearch();
        },
      ),
    );
  }
}
