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
import '../../../widgets/bottom_sheet.dart' as permissionsheet;
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/hutano_button.dart';
import '../add_family_member/model/res_add_member.dart';
import 'family_member_model.dart';
import 'member_profile.dart';
import 'model/req_add_permission.dart';
import 'model/req_family_network.dart';
import 'permission_access.dart';

class FamilyCircle extends StatefulWidget {
  @override
  _FamilyCircleState createState() => _FamilyCircleState();
}

class _FamilyCircleState extends State<FamilyCircle> {
  List<FamilyNetwork> list = [];
  bool _enableButton = false;
  final int _page = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getFamilyNetwork();
      setState(() {
        list = list;
      });
    });
  }

  _getFamilyNetwork() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqFamilyNetwork(
        id: getString(PreferenceKey.id), limit: dataLimit, page: _page);
    try {
      var res = await ApiManager().getFamilyNetowrk(request);
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        list = res.response.familyNetwork;
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void _onEditClick() {
    list.forEach((element) => element.isSelected = false);
    setState(() {
      _enableButton = !_enableButton;
    });
  }

  void _openPermissionSheet() {
    var index = list.indexWhere((element) => element.isSelected);
    if (index == -1) return;
    permissionsheet.showBottomSheet(
        context: context,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter changeState) {
            return PermissionAccess(
              member: list[index],
              index: index,
              userPermissionsList: list[index].userPermissions,
              onPermissionDone: onPermissionDone,
            );
          },
        ));
  }

  void onPermissionDone(List<int> checkedPermission, int index) async {
    Navigator.pop(context);
    ProgressDialogUtils.showProgressDialog(context);
    var member = list[index];
    final request = ReqAddPermission(
        id: getString(PreferenceKey.id, ""),
        userId: member.sId,
        userPermissions: checkedPermission,
        step: 2);

    try {
      var res = await ApiManager().setMemberPermission(request);
      ProgressDialogUtils.dismissProgressDialog();
      if (res.data != null) {
        list[index].userPermissions = checkedPermission;
        setState(() {});
        DialogUtils.showAlertDialog(context, res.response);
      }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(
            height: spacing20,
          ),
          _buildList(),
          _buildPermissionButton(),
          SizedBox(
            height: spacing20,
          ),
          HutanoButton(
            label: Localization.of(context).next,
            labelColor: colorBlack,
            onPressed: () {
              NavigationUtils.push(context, routeAddProvider);
            },
          ),
          SizedBox(
            height: spacing50,
          )
        ],
      ),
    );
  }

  Widget _buildPermissionButton() {
    return Flexible(
      flex: 0,
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
              label: Localization.of(context).permissions,
              labelColor: colorBlack,
              onPressed: _enableButton ? _openPermissionSheet : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: spacing25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Localization.of(context).labelMyFamilyCircle,
            style: const TextStyle(
                color: colorDarkPurple,
                fontWeight: fontWeightSemiBold,
                fontSize: fontSize18),
          ),
          HutanoButton(
            buttonType: HutanoButtonType.withPrefixIcon,
            label: Localization.of(context).edit,
            onPressed: _onEditClick,
            color: colorWhite,
            height: spacing45,
            buttonRadius: 8,
            borderColor: colorBorder28,
            borderWidth: 0.5,
            width: spacing100,
            labelColor: colorDarkPurple,
            icon: FileConstants.icEdit,
            iconSize: spacing18,
          )
        ],
      ),
    );
  }

  _buildList() {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        separatorBuilder: (context, i) {
          return Divider(
            color: colorBorder,
            height: spacing35,
            thickness: 0.5,
          );
        },
        itemCount: list.length,
        itemBuilder: (context, i) {
          return IgnorePointer(
            ignoring: !_enableButton,
            child: CheckboxListTile(
              activeColor: colorYellow,
              contentPadding: EdgeInsets.all(0),
              onChanged: (value) {
                list.forEach((element) {
                  element.isSelected = false;
                });
                list[i].isSelected = value;
                setState(() {});
              },
              value: list[i].isSelected,
              title: MemberProfile(
                member: FamilyMember(
                  image: list[i].avatar,
                  name: list[i].fullName,
                  relation: list[i].relation,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
