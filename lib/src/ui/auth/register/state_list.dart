import 'package:flutter/material.dart';

import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/hutano_textfield.dart';
import '../../../widgets/list_picker.dart';
import 'model/res_states_list.dart';

class StateList extends StatefulWidget {
  final TextEditingController controller;
  final List<States> stateList;
  final Function onStateSelected;

  const StateList({
    Key key,
    this.controller,
    this.stateList,
    this.onStateSelected,
  }) : super(key: key);
  @override
  _StateListState createState() => _StateListState();
}

class _StateListState extends State<StateList> {
  void _openStatePicker() {
    showDropDownSheet(
        list: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.stateList.length,
          itemBuilder: (context, pos) {
            return InkWell(
                onTap: () {
                  widget.onStateSelected(pos);
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Center(
                    child: Text(widget.stateList[pos].title),
                  ),
                ));
          },
        ),
        context: context);
  }

  Widget _getEmailTextField() {
    return Container(
        child: GestureDetector(
      onTap: _openStatePicker,
      child: HutanoTextField(
          width: SizeConfig.screenWidth / 2.4,
          focusNode: FocusNode(),
          controller: widget.controller,
          suffixIcon: FileConstants.icDown,
          suffixheight: spacing12,
          suffixwidth: spacing12,
          isFieldEnable: false,
          labelText: Localization.of(context).state,
          textInputAction: TextInputAction.next),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getEmailTextField(),
    );
  }
}
