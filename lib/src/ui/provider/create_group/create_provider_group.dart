import 'package:flutter/material.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/custom_scaffold.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void _addGroup() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
      groupName: _groupNameController.text.toString(),
      userId: getString(PreferenceKey.id),
    );
    try {
      var res = await ApiManager().addProviderNetwork(request);
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: res.response.toString(),
          isCancelEnable: false,
          okButtonTitle: Localization.of(context).ok,
          okButtonAction: () {
            Navigator.of(context).pop({ArgumentConstant.number: ""});
          });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      padding: EdgeInsets.only(
          top: spacing25, left: spacing15, right: spacing15, bottom: spacing20),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing25),
            Text(
              Localization.of(context).addCreateGroup,
              style: const TextStyle(
                  color: colorDarkPurple,
                  fontSize: fontSize20,
                  fontWeight: fontWeightSemiBold),
            ),
            SizedBox(height: spacing50),
            Form(
              key: _key,
              child: _buildEmailField(context),
            ),
            SizedBox(height: spacing20),
            HutanoButton(
              width: SizeConfig.screenWidth / 1.5,
              onPressed: _enableButton ? _addGroup : null,
              color: colorPurple,
              icon: FileConstants.icAddGroup,
              buttonType: HutanoButtonType.withPrefixIcon,
              label: Localization.of(context).addCreateGroup,
            ),
            Spacer(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return HutanoTextField(
        width: SizeConfig.screenWidth,
        labelText: Localization.of(context).groupName,
        focusNode: _groupFocus,
        controller: _groupNameController,
        onValueChanged: (value) {
          final _validate = _key.currentState.validate();
          setState(() {
            _enableButton = _validate;
          });
        },
        validationMethod: (text) => text
            .toString()
            .isBlank(context, Localization.of(context).errorEnterGroup));
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
