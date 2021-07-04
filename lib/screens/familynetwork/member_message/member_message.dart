import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
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
  ApiBaseHelper api = ApiBaseHelper();
  String token;
  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((value) {
      token = value;
    });
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
      var res = await api.shareMessage(context, token, request);
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
      key: _key,
      autovalidate: true,
      child: CustomScaffold(
        padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 0),
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
              height: 50,
            ),
            Text(
              Strings.typeMessage,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            _buildInputField(),
            _buildBottomButtons(),
            SizedBox(
              height: 30,
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
        color: AppColors.colorBlack20,
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
          hintText: Strings.typeHere,
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
            width: 50,
          ),
          Flexible(
            flex: 1,
            child: HutanoButton(
              label: Strings.send,
              labelColor: AppColors.colorBlack,
              onPressed: _enableButton ? _onSend : null,
            ),
          ),
        ],
      ),
    );
  }
}
