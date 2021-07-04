import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/widgets.dart';

import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_textfield.dart';
import '../provider_add_network/model/req_add_provider.dart';

class CreateProviderGroup extends StatefulWidget {
  const CreateProviderGroup({Key key}) : super(key: key);
  @override
  _CreateProviderGroupState createState() => _CreateProviderGroupState();
}

class _CreateProviderGroupState extends State<CreateProviderGroup> {
  final FocusNode _groupFocus = FocusNode();
  final _groupNameController = TextEditingController();
  bool _enableButton = false;
  final GlobalKey<FormState> _key = GlobalKey();
  ApiBaseHelper api = ApiBaseHelper();
  String token, userId;
  @override
  void initState() {
    SharedPref().getToken().then((value) {
      token = value;
    });
    SharedPref().getValue('id').then((value) {
      userId = value;
    });

    super.initState();
  }

  void _addGroup() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
      groupName: _groupNameController.text.toString(),
      userId: userId,
    );
    try {
      var res = await api.addProviderNetwork(context, token, request);
      ProgressDialogUtils.dismissProgressDialog();

      Widgets.showErrorDialog(
          context: context,
          description: res.response.toString(),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop({ArgumentConstant.number: ""});
          });
      // DialogUtils.showOkCancelAlertDialog(
      //     context: context,
      //     message: res.response.toString(),
      //     isCancelEnable: false,
      //     okButtonTitle: Strings.ok,
      //     okButtonAction: () {
      //       Navigator.of(context).pop({ArgumentConstant.number: ""});
      //     });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(margin: EdgeInsets.only(top: 20)),
              SizedBox(height: 25),
              Text(
                Strings.addCreateGroup,
                style: AppTextStyle.semiBoldStyle(
                  color: AppColors.colorDarkPurple,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 60),
              Form(
                key: _key,
                child: _buildEmailField(context),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: HutanoButton(
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: _enableButton ? _addGroup : null,
                  color: AppColors.colorPurple,
                  icon: FileConstants.icAddGroup,
                  buttonType: HutanoButtonType.withPrefixIcon,
                  label: Strings.addCreateGroup,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return HutanoTextField(
        width: MediaQuery.of(context).size.width,
        labelText: Strings.groupName,
        focusNode: _groupFocus,
        controller: _groupNameController,
        onValueChanged: (value) {
          final _validate = _key.currentState.validate();
          setState(() {
            _enableButton = _validate;
          });
        },
        validationMethod: (text) =>
            text.toString().isBlank(context, Strings.errorEnterGroup));
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
          Spacer()
        ],
      ),
    );
  }
}
