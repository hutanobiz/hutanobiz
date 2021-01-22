import 'package:flutter/material.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/bottom_sheet.dart' as share_bottom_sheet;
import '../../../widgets/bottom_sheet_remove.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/hutano_button.dart';
import '../../familynetwork/add_family_member/model/res_add_member.dart';
import '../../familynetwork/familycircle/model/req_family_network.dart';
import 'list_speciality.dart';
import 'model/req_remove_provider.dart';
import 'model/req_share_provider.dart';
import 'model/res_my_provider_network.dart';
import 'share_provider.dart';

class MyProviderNetwrok extends StatefulWidget {
  @override
  _MyProviderNetwrokState createState() => _MyProviderNetwrokState();
}

class _MyProviderNetwrokState extends State<MyProviderNetwrok> {
  List<ProviderGroupList> _providerGroupList = [];
  List<FamilyNetwork> _memberList = [];
  ReqRemoveProvider _removeProvider;
  String _shareMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyProviderGroupList();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => {_getFamilyNetwork()});
  }

  _getFamilyNetwork() async {
    final request = ReqFamilyNetwork(
        id: getString(PreferenceKey.id, ""), limit: dataLimit, page: 1);
    try {
      var res = await ApiManager().getFamilyNetowrk(request);
      setState(() {
        _memberList = res.response.familyNetwork;
      });
    } on ErrorModel catch (e) {
      print(e.response);
    }
  }

  _onShareClick() {
    share_bottom_sheet.showBottomSheet(
        context: context,
        color: colorBottomSheet,
        child: ShareProvider(
          memberList: _memberList,
          shareMessage: _shareMessage,
        ));
  }

  onShare(int index, int subIndex) async {
    ProgressDialogUtils.showProgressDialog(context);
    final id = _providerGroupList[index].providerNetwork.doctorId[subIndex];
    final request = ReqShareProvider(doctorId: id);
    try {
      var res = await ApiManager().shareProvider(request);
      ProgressDialogUtils.dismissProgressDialog();
      _shareMessage = res.message;
      _onShareClick();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  onRemove(int index, int subIndex) async {
    _removeProvider = ReqRemoveProvider(
        doctorId: _providerGroupList[index].providerNetwork.doctorId[subIndex],
        groupId: _providerGroupList[index].providerNetwork.sId,
        userId: getString(PreferenceKey.id));

    showBottomSheetRemove(
        context: context, onRemove: _onRemove, onCancel: _onCancel);
  }

  _onCancel() {
    Navigator.of(context).pop();
  }

  _onRemove() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().removeProvider(_removeProvider);
      Navigator.of(context).pop();
      _getMyProviderGroupList(showProgress: false);
      ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _getMyProviderGroupList({showProgress = true}) async {
    if (showProgress) {
      ProgressDialogUtils.showProgressDialog(context);
    }
    try {
      var res = await ApiManager().getMyProviderNetwork();
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        _providerGroupList = res.response.data;
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
      padding: EdgeInsets.symmetric(vertical: spacing10, horizontal: spacing22),
      child: Column(
        children: [
          SizedBox(height: spacing10),
          _buildHeader(),
          SizedBox(height: spacing25),
          Expanded(
            child: ListSpeciality(
              providerGroupList: _providerGroupList,
              onShare: onShare,
              onRemove: onRemove,
            ),
          ),
        ],
      ),
    );
  }

  _onShareAll() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqShareProvider(userId: getString(PreferenceKey.id));
    try {
      var res = await ApiManager().shareAllProvider(request);
      ProgressDialogUtils.dismissProgressDialog();
      _shareMessage = res.message;
      _onShareClick();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Localization.of(context).myProviderNetwork,
          style: const TextStyle(
              color: colorDarkPurple,
              fontWeight: fontWeightSemiBold,
              fontSize: fontSize18),
        ),
        HutanoButton(
          buttonType: HutanoButtonType.withPrefixIcon,
          label: Localization.of(context).share,
          onPressed: _onShareAll,
          color: colorWhite,
          height: spacing45,
          buttonRadius: 8,
          borderColor: colorBorder28,
          borderWidth: 0.5,
          width: spacing100,
          labelColor: colorDarkPurple,
          icon: FileConstants.icShare,
          iconSize: spacing18,
        )
      ],
    );
  }
}