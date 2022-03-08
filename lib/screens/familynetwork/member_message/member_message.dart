import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_scaffold.dart';

import '../../../utils/dialog_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../add_family_member/model/res_add_member.dart';
import '../familycircle/family_member_model.dart';
import '../familycircle/member_profile.dart';
import 'model/req_message_share.dart';

class MemberMessage extends StatefulWidget {
  final String message;
  final FamilyNetwork member;

  const MemberMessage({
    Key key,
    this.message,
    this.member,
  }) : super(key: key);
  @override
  _MemberMessageState createState() => _MemberMessageState();
}

class _MemberMessageState extends State<MemberMessage> {
  FamilyMember _familyMember;
  FocusNode _focusNode = FocusNode();
  bool _enableButton = false;
  final controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.text = widget.message;
      setState(() {
        _enableButton = true;
      });
    });
  }

  void _onSend() async {
    final request = ReqMessageShare(
        message: controller.text, phoneNumber: widget.member.phoneNumber);
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().shareMessage(request);
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, res.response);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always, key: _key,
      child: CustomScaffold(
        padding:
            EdgeInsets.only(top: spacing30, left: 15, right: 15, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberProfile(
              member: FamilyMember(
                  image: widget.member.avatar,
                  name: widget.member.fullName,
                  relation: widget.member.relation),
            ),
            SizedBox(
              height: spacing50,
            ),
            Text(
              Localization.of(context).typeMessage,
              style: TextStyle(fontSize: fontSize15),
            ),
            SizedBox(
              height: spacing15,
            ),
            _buildInputField(),
            _buildBottomButtons(),
            SizedBox(
              height: spacing30,
            )
          ],
        ),
      ),
    );
  }

  _buildInputField() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: colorBlack20,
        width: 0.5,
      ),
    );
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: 6,
        decoration: InputDecoration(
          isDense: true,
          border: border,
          focusedBorder: border,
          hintText: Localization.of(context).typeHere,
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Flexible(
      flex: 0,
      child: Row(
        children: [
          HutanoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FileConstants.icBack,
            buttonType: HutanoButtonType.onlyIcon,
          ),
          SizedBox(
            width: spacing50,
          ),
          Flexible(
            flex: 1,
            child: HutanoButton(
              label: Localization.of(context).send,
              labelColor: colorBlack,
              onPressed: _enableButton ? _onSend : null,
            ),
          ),
        ],
      ),
    );
  }
}