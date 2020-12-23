import 'package:flutter/material.dart';

import '../../apis/api_constants.dart';
import '../../apis/api_manager.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/extensions.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/hutano_button.dart';
import 'model/req_invite.dart';

class InviteByTextScreen extends StatefulWidget {
  String phone;
  String shareMessage;

  InviteByTextScreen(this.phone, {this.shareMessage});

  @override
  _InviteByTextScreenState createState() => _InviteByTextScreenState();
}

class _InviteByTextScreenState extends State<InviteByTextScreen> {
  TextEditingController textMessageController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.shareMessage != null) {
      textMessageController.text = widget.shareMessage.toString();
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => {_getInviteMessage()});
    }
  }

  _getInviteMessage() async {
    final request = {'isEmail': 0};
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
    return CustomScaffold(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: spacing50,
              ),
              Text(
                Localization.of(context).text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: colorBlack85,
                    fontWeight: fontWeightBold,
                    fontSize: fontSize20),
              ),
              SizedBox(
                height: spacing35,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Localization.of(context).typeMessage,
                  style: TextStyle(
                      color: colorBlack,
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14),
                ),
              ),
              SizedBox(
                height: spacing15,
              ),
              Expanded(child: Form(key: _key, child: _buildMessage())),
              SizedBox(
                height: spacing35,
              ),
              _buildSendButton(),
              SizedBox(
                height: 5,
              ),
              if (widget.shareMessage == null) _buildNextButton(),
              SizedBox(
                height: spacing20,
              ),
            ],
          ),
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
        NavigationUtils.push(context, routeAddProvider);
      },
    );
  }

  Widget _buildSendButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          HutanoButton(
            onPressed: () {
              NavigationUtils.pop(context);
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
    if (!_key.currentState.validate()) {
      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final req = ReqInvite(
        phoneNumber: widget.phone, message: textMessageController.text);
    try {
      await ApiManager().sendInvite(req).then((value) {
        ProgressDialogUtils.dismissProgressDialog();
        if (value.status == success) {
          DialogUtils.showOkCancelAlertDialog(
            context: context,
            message: value.response,
            okButtonAction: () {
              NavigationUtils.pop(context);
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
  }

  _buildMessage() {
    return TextFormField(
      controller: textMessageController,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize12,
      ),
      onChanged: (s) {
        _key.currentState.validate();
      },
      validator: (email) =>
          email.toString().isBlank(context, 'Please Enter message'),
      maxLines: 10,
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
    );
  }
}
