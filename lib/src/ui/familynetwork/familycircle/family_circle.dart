import 'package:flutter/material.dart';
import 'package:hutano/src/widgets/app_header.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';

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
    //TODO :TEMP CODE
    list.add(FamilyNetwork(
        avatar: "",
        fullName: "Hi",
        userRelation: 1,
        sId: "12",
        phoneNumber: "12312312312",
        relation: "Brother"));
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

  _backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 15, left: 15),
          width: 32,
          height: 32,
          child: Icon(Icons.chevron_left_rounded),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: const Color(0x12372786), width: 0.5),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x4f8b8b8b),
                    offset: Offset(0, 2),
                    blurRadius: 30,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backButton(),
            _buildHeader(),
            SizedBox(
              height: spacing20,
            ),
            _buildList(),
            // _buildPermissionButton(),
            SizedBox(
              height: spacing20,
            ),
          ],
        ),
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
              Navigator.of(context).pop();
            },
            icon: FileConstants.icBack,
            buttonType: HutanoButtonType.onlyIcon,
          ),
          SizedBox(
            width: spacing50,
          ),
          // Flexible(
          //   flex: 1,
          //   child: HutanoButton(
          //     label: Localization.of(context).permissions,
          //     labelColor: colorBlack,
          //     onPressed: _enableButton ? _openPermissionSheet : null,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppHeader(
          margin: 20,
          title: Localization.of(context).labelMyFamilyCircle,
          subTitle: Localization.of(context).assignPermisstion,
        ),
        SizedBox(height: spacing15),
      ],
    );
  }

  _buildList() {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        separatorBuilder: (context, i) {
          return Divider(
            color: colorBorder,
            height: spacing35,
            thickness: 0.5,
          );
        },
        itemCount: list.length,
        itemBuilder: (context, i) {
          return PopupMenuButton(
            offset: Offset(300, 0),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Value2',
                textStyle: const TextStyle(
                    color: colorBlack2,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      FileConstants.icSettingBlack,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Manage Premissions")
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Value2',
                textStyle: const TextStyle(
                    color: colorBlack2,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      FileConstants.icRemoveBlack,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Remove")
                  ],
                ),
              ),
            ],
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              // activeColor: colorYellow,
              // onChanged: (value) {
              //   list.forEach((element) {
              //     element.isSelected = false;
              //   });
              //   list[i].isSelected = value;
              //   setState(() {});
              // },
              // value: list[i].isSelected,
              title: MemberProfile(
                member: FamilyMember(
                  image: list[i].avatar,
                  name: list[i].fullName,
                  relation: list[i].relation,
                ),
              ),
              trailing: Icon(Icons.more_vert),
            ),
          );
        },
      ),
    );
  }
}
