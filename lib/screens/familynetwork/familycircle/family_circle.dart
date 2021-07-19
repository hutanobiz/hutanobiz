import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/common_res.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/member_permission_model.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_remove_family_member.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/list_picker.dart';
import 'package:hutano/utils/extensions.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/bottom_sheet.dart' as permissionsheet;
import '../../../widgets/hutano_button.dart';
import 'family_member_model.dart';
import 'member_profile.dart';
import 'model/req_add_permission.dart';
import 'model/req_add_permission_model.dart';
import 'model/req_family_network.dart';
import 'permission_access.dart';

class FamilyCircle extends StatefulWidget {
  @override
  _FamilyCircleState createState() => _FamilyCircleState();
}

class _FamilyCircleState extends State<FamilyCircle> {
  List<CircleMember> list = [];
  List<MemberPermissionModel> permissionList = [];
  bool _enableButton = false;
  final int _page = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getUserPermission();
    });
  }

  _openStatePicker(BuildContext context, int index) {
    showDropDownSheet(
        isFromFamilyCircle: true,
        list: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                MemberProfile(
                  member: FamilyMember(
                    image: list[index].name,
                    name: list[index].name,
                    relation: list[index].relationName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(Localization.of(context).permissionsLabel,
                        style: TextStyle(
                            fontSize: 14, fontWeight: fontWeightSemiBold)),
                  ),
                ),
                _feedbackSuggestListWidget(
                    context, list[index].userPermissions),
                _buildNextButton(context, index),
              ],
            ),
          ),
        ),
        context: context);
  }

  _openEditPermissionPicker(BuildContext context, int index) {
    showDropDownSheet(
        isFromFamilyCircle: true,
        list: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                MemberProfile(
                  member: FamilyMember(
                    image: list[index].name,
                    name: list[index].name,
                    relation: list[index].relationName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(Localization.of(context).permissionsLabel,
                        style: TextStyle(
                            fontSize: 14, fontWeight: fontWeightSemiBold)),
                  ),
                ),
                _updateFeedbackSuggestListWidget(
                    context, list[index].userPermissions),
                _buildNextButton(context, index),
              ],
            ),
          ),
        ),
        context: context);
  }

  Widget _feedbackSuggestListWidget(
      BuildContext context, List<UserPermissions> userPermission) {
    permissionList.forEach((element) {
      element.isSelected = false;
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, pos) {
            return StatefulBuilder(
                builder: (context, _setState) => ListTile(
                      leading: Image.asset(permissionList[pos].value,
                          width: 20, height: 20),
                      title: Text(
                        permissionList[pos].label ?? "",
                        style: const TextStyle(
                            color: colorBlack85,
                            fontSize: 14,
                            fontWeight: fontWeightRegular),
                      ),
                      trailing: permissionList[pos].isSelected
                          ? Image.asset("images/checkedCheck.png",
                              height: 24, width: 24)
                          : Image.asset("images/uncheckedCheck.png",
                              height: 24, width: 24),
                      onTap: () {
                        _setState(() => permissionList[pos].isSelected =
                            !permissionList[pos].isSelected);
                      },
                    ));
          },
          separatorBuilder: (_, pos) {
            return SizedBox();
          },
          itemCount: permissionList.length),
    );
  }

  Widget _updateFeedbackSuggestListWidget(
      BuildContext context, List<UserPermissions> userPermission) {
    setState(() {
      permissionList.forEach((element) {
        element.isSelected = false;
      });
    });
    setState(() {
      for (var i = 0; i < userPermission.length; i++) {
        for (var j = 0; j < permissionList.length; j++) {
          if (permissionList[j].reasonId == userPermission[i].sId) {
            permissionList[j].isSelected = true;
          }
        }
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, pos) {
            return StatefulBuilder(
                builder: (context, _setState) => ListTile(
                      leading: Image.asset(permissionList[pos].value,
                          width: 20, height: 20),
                      title: Text(
                        permissionList[pos].label ?? "",
                        style: const TextStyle(
                            color: colorBlack85,
                            fontSize: 14,
                            fontWeight: fontWeightRegular),
                      ),
                      trailing: permissionList[pos].isSelected
                          ? Image.asset("images/checkedCheck.png",
                              height: 24, width: 24)
                          : Image.asset("images/uncheckedCheck.png",
                              height: 24, width: 24),
                      onTap: () {
                        _setState(() => permissionList[pos].isSelected =
                            !permissionList[pos].isSelected);
                        debugPrint("${permissionList[pos].isSelected}");
                      },
                    ));
          },
          separatorBuilder: (_, pos) {
            return SizedBox();
          },
          itemCount: permissionList.length),
    );
  }

  _getFamilyNetwork({bool isFromAlert = false}) async {
    if (!isFromAlert) {
      ProgressDialogUtils.showProgressDialog(context);
    }
    final request = ReqFamilyNetwork(
        id: getString(PreferenceKey.id), limit: dataLimit, page: _page);
    try {
      var res = await ApiManager().getFamilyCircle(request);
      if (!isFromAlert) {
        ProgressDialogUtils.dismissProgressDialog();
      }
      setState(() {
        list = res.response;
      });
    } on ErrorModel catch (e) {
      if (!isFromAlert) {
        ProgressDialogUtils.dismissProgressDialog();
      }
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _getUserPermission() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqFamilyNetwork(
        id: getString(PreferenceKey.id), limit: dataLimit, page: _page);
    try {
      var res = await ApiManager().getUserPermission();
      ProgressDialogUtils.dismissProgressDialog();
      var i = 0;
      var imagesList = [
        FileConstants.icFullAccess,
        FileConstants.icAppointments,
        FileConstants.icDocuments,
        FileConstants.icNotifications
      ];
      res.response.forEach((e) {
        permissionList.add(
            MemberPermissionModel(e.permission, false, imagesList[i], e.sId));
        i++;
      });
      setState(() {});
      _getFamilyNetwork();
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
              // userPermissionsList: list[index].userPermissions,
              onPermissionDone: onPermissionDone,
            );
          },
        ));
  }

  _buildNextButton(BuildContext context, int index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorYellow,
        iconSize: 20,
        label: Localization.of(context).saveLabel,
        onPressed: () {
          List<String> checkPermissions = [];
          permissionList.forEach((element) {
            if (element.isSelected) {
              debugPrint("${element.reasonId}");
              checkPermissions.add(element.reasonId);
            }
          });
          onAddPermissionDone(checkPermissions, list[index].sId, context);
        },
      ));

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
        // list[index].userPermissions = checkedPermission;
        setState(() {});
        DialogUtils.showAlertDialog(context, res.response);
      }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  void onAddPermissionDone(List<String> checkedPermission, String memberId,
      BuildContext context) async {
    Navigator.pop(context);
    ProgressDialogUtils.showProgressDialog(context);
    final request =
        ReqAddUserPermissionModel(userPermissions: checkedPermission);

    try {
      var res = await ApiManager()
          .setSpecificMemberPermission(request, memberId ?? "");
      ProgressDialogUtils.dismissProgressDialog();
      if (res.response != null) {
        DialogUtils.showAlertDialog(context, res.response);
        _getFamilyNetwork(isFromAlert: true);
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
            _buildHeader(context),
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
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                value: 'Value1',
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
                    Text(Localization.of(context).managePermissionsLabel),
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
                    Text(Localization.of(context).remove)
                  ],
                ),
              ),
            ],
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: MemberProfile(
                member: FamilyMember(
                  image: list[i].name,
                  name: list[i].name,
                  relation: list[i].relationName,
                ),
              ),
              trailing: Icon(Icons.more_vert),
            ),
            onSelected: (value) {
              if (value == "Value1") {
                if (list[i].userPermissions.length > 0) {
                  _openEditPermissionPicker(context, i);
                } else {
                  setState(() {
                    permissionList.map((e) => e.isSelected = false);
                  });
                  _openStatePicker(context, i);
                }
              } else {
                SharedPref().getValue(PreferenceKey.id).then((value) {
                  ReqRemoveFamilyMember removeFamilyMember =
                      ReqRemoveFamilyMember(
                          sId: value.toString(),
                          userId: list[i].sId.toString());
                  setState(() {
                    list.remove(list[i]);
                  });
                  _removeFamilyNetworkMember(context, removeFamilyMember);
                });
              }
            },
          );
        },
      ),
    );
  }

  void _removeFamilyNetworkMember(
      BuildContext context, ReqRemoveFamilyMember model) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().removeFamilyNetwork(model).then((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        Widgets.showToast(result.response);
        _getFamilyNetwork();
      }
    }).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
