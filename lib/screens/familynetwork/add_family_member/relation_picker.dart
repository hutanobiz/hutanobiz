import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/providercicle/search/model/family_member.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import '../../../widgets/hutano_textfield.dart';
import '../../../widgets/list_picker.dart';
import 'model/res_relation_list.dart';

class RelationPicker extends StatefulWidget {
  final TextEditingController? controller;
  final List<Relations>? relationList;
  final ValueSetter<Relations>? onRelationSelected;
  final FamilyMember? member;

  const RelationPicker({
    Key? key,
    this.controller,
    this.relationList,
    this.onRelationSelected,
    this.member,
  }) : super(key: key);
  @override
  _RelationPickerState createState() => _RelationPickerState();
}

class _RelationPickerState extends State<RelationPicker> {
  void _openStatePicker() {
    showDropDownSheet(
        list: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.relationList!.length,
          itemBuilder: (context, pos) {
            return InkWell(
                onTap: () {
                  widget.onRelationSelected!(widget.relationList![pos]);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Center(
                    child: Text(widget.relationList![pos].relation!),
                  ),
                ));
          },
        ),
        context: context);
  }

  Widget _getRelationField() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.member != null
                  ? Localization.of(context)!
                      .msgRelationToMember
                      .format([widget.member!.fullName])
                  : "",
              style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize13,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
        SizedBox(height: spacing10),
        Container(
            child: GestureDetector(
          onTap: _openStatePicker,
          child: HutanoTextField(
              focusNode: FocusNode(),
              controller: widget.controller,
              suffixIcon: FileConstants.icDown,
              disableBorderColor: colorDarkPurple,
              suffixheight: spacing12,
              suffixwidth: spacing12,
              isFieldEnable: false,
              hintText: Localization.of(context)!.relation,
              textInputAction: TextInputAction.next),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getRelationField(),
    );
  }
}
