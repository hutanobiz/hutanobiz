import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/hutano_textfield.dart';
import '../../../widgets/list_picker.dart';
import '../../provider/search/model/family_member.dart';
import 'model/res_relation_list.dart';

class RelationPicker extends StatefulWidget {
  final TextEditingController controller;
  final List<Relations> relationList;
  final ValueSetter<Relations> onRelationSelected;
  final FamilyMember member;

  const RelationPicker({
    Key key,
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
          itemCount: widget.relationList.length,
          itemBuilder: (context, pos) {
            return InkWell(
                onTap: () {
                  widget
                      .onRelationSelected(widget.relationList[pos]);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Center(
                    child: Text(widget.relationList[pos].relation),
                  ),
                ));
          },
        ),
        context: context);
  }

  Widget _getRelationField() {
    return Column(
      children: [
        Text(
          Localization.of(context)
              .msgRelationToMember
              .format([widget.member.fullName]),
          style: TextStyle(color: colorPurple60, fontSize: fontSize13),
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
              hintText: Localization.of(context).relation,
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
