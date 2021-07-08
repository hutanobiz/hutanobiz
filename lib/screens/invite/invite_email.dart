import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';

import '../../apis/api_constants.dart';
import '../../apis/api_manager.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/localization/localization.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/size_config.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_header_info.dart';
import '../../widgets/hutano_textfield.dart';
import 'add_recipient.dart';
import 'model/email.dart';
import 'model/req_invite.dart';

class InviteByEmailScreen extends StatefulWidget {
  String email;

  InviteByEmailScreen(this.email);

  @override
  _InviteByEmailScreenState createState() => _InviteByEmailScreenState();
}

class _InviteByEmailScreenState extends State<InviteByEmailScreen> {
  List<AddRecipient> list = [];

  TextEditingController textMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    list.add(AddRecipient(
        nameOfRecipient: "",
        emailAddress: widget.email,
        nameFocus: FocusNode(),
        emailFocus: FocusNode()));

    WidgetsBinding.instance.addPostFrameCallback((_) => {_getInviteMessage()});
  }

  _getInviteMessage() async {
    final request = {'isEmail': 1};
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().getInviteMessage(request);
      ProgressDialogUtils.dismissProgressDialog();
      textMessageController.text = res.message;
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: spacing50,
            ),
            HutanoHeaderInfo(
              title: Localization.of(context).inviteByEmail,
              subTitle: Localization.of(context).addMoreRecipients,
              subTitleFontSize: fontSize11,
            ),
            SizedBox(
              height: spacing35,
            ),
            _buildList(),
            SizedBox(
              height: spacing35,
            ),
            _getAddRecipientButton(),
            SizedBox(
              height: spacing35,
            ),
            _buildMessage(),
            SizedBox(
              height: spacing35,
            ),
            _buildSendButton(),
            SizedBox(
              height: 7,
            ),
            _buildNextButton(),
            SizedBox(
              height: spacing30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return HutanoButton(
      label: Localization.of(context).next,
      labelColor: colorWhite,
      color: colorPurple,
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.routeAddProvider);
      },
    );
  }

  _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildItemRecipient(index);
      },
    );
  }

  _buildItemRecipient(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: spacing10),
          child: HutanoTextField(
            hintText: Localization.of(context).nameOfRecipient,
            textSize: fontSize12,
            textInputType: TextInputType.name,
            focusNode: list[index].nameFocus,
            floatingBehaviour: FloatingLabelBehavior.never,
            width: SizeConfig.screenWidth / 2.8,
            focusedBorderColor: colorGrey20,
            onValueChanged: (value) {
              list[index].nameOfRecipient = value.toString();
            },
            contentPadding: EdgeInsets.all(8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: spacing10, top: spacing10),
          child: HutanoTextField(
            hintText: Localization.of(context).emailAddress,
            controller: TextEditingController()
              ..text = list[index].emailAddress,
            textSize: fontSize12,
            focusNode: list[index].emailFocus,
            textInputType: TextInputType.emailAddress,
            floatingBehaviour: FloatingLabelBehavior.never,
            width: SizeConfig.screenWidth / 2,
            focusedBorderColor: colorGrey20,
            contentPadding: EdgeInsets.all(8),
            onValueChanged: (value) {
              list[index].emailAddress = value.toString();
            },
          ),
        )
      ],
    );
  }

  Widget _buildSendButton() {
    return Align(
      alignment: Alignment.bottomCenter,
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
              onPressed: () {
                _sendButtonClick();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendButtonClick() async {
    List listEmail = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].emailAddress.isNotEmpty &&
          list[i].nameOfRecipient.isNotEmpty) {
        listEmail.add(
            Email(email: list[i].emailAddress, name: list[i].nameOfRecipient)
                .toJson());
      }
    }
    ProgressDialogUtils.showProgressDialog(context);

    if (listEmail.length > 0) {
      final req = ReqInvite(
          phoneNumber: getString(PreferenceKey.phone),
          emailList: listEmail,
          message: textMessageController.text);
      try {
        await ApiManager().sendInvite(req).then((value) {
          ProgressDialogUtils.dismissProgressDialog();
          if (value.status == success) {
            DialogUtils.showOkCancelAlertDialog(
              context: context,
              message: value.response,
              okButtonAction: () {
                Navigator.of(context).pop();
              },
              okButtonTitle: 'Ok',
              isCancelEnable: false,
            );
          }
        });
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(
            context, Localization.of(context).commonErrorMsg);
      }
    } else {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, Localization.of(context).errorMsgInviteEmail);
    }
  }

  Widget _getAddRecipientButton() {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ink(
            child: Image.asset(
              FileConstants.icAdd,
              width: 45,
              height: 45,
            ),
          ),
          Text(
            Localization.of(context).addRecipients,
            style: TextStyle(color: colorBlack85, fontSize: fontSize14),
          )
        ],
      ),
      onTap: () => setState(() {
        list.add(AddRecipient(emailFocus: FocusNode(), nameFocus: FocusNode()));
      }),
    );
  }

  _buildMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textMessageController,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize13,
        ),
        maxLines: 15,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            borderSide: BorderSide(color: colorBlack15),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey[300]),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            borderSide: BorderSide(color: colorBlack15),
          ),
        ),
      ),
    );
  }
}
