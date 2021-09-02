import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/widgets.dart';
import '../../../utils/dialog_utils.dart';
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
      //     okButtonTitle: Localization.of(context).ok,
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
    // SizeConfig().init(context);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CustomBackButton(margin: EdgeInsets.only(top: 20)),
            // SizedBox(height: spacing10),
            Text(
              Localization.of(context).addCreateGroup,
              style: const TextStyle(
                  color: colorDarkPurple,
                  fontSize: fontSize20,
                  fontWeight: fontWeightBold),
            ),
            SizedBox(height: spacing20),
            Form(
              key: _key,
              child: _buildEmailField(context),
            ),
            SizedBox(height: spacing20),
            Align(
              alignment: Alignment.center,
              child: HutanoButton(
                fontSize: 14,
                iconSize: 20,
                width: SizeConfig.screenWidth / 1.5,
                onPressed: _enableButton ? _addGroup : null,
                color: colorPurple,
                icon: FileConstants.icAddGroup,
                buttonType: HutanoButtonType.withPrefixIcon,
                label: Localization.of(context).addCreateGroup,
              ),
            ),
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
