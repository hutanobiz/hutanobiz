
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/member_permission_model.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/list_picker.dart';

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
  ApiBaseHelper api = ApiBaseHelper();
  String token;
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
                    child: Text(Strings.permissionsLabel,
                        style: AppTextStyle.semiBoldStyle(
                          fontSize: 14,
                        )),
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
                    child: Text(Strings.permissionsLabel,
                        style: AppTextStyle.semiBoldStyle(
                          fontSize: 14,
                        )),
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
                builder: (context, _setState) => CheckboxListTile(
                    activeColor: AppColors.colorYellow,
                    contentPadding: EdgeInsets.all(0),
                    title: Container(
                        child: Row(children: [
                      Image.asset(permissionList[pos].value,
                          width: 20, height: 20),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          permissionList[pos].label ?? "",
                          style: AppTextStyle.regularStyle(
                            color: AppColors.colorBlack85,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ])),
                    value: permissionList[pos].isSelected,
                    onChanged: (val) {
                      _setState(() => permissionList[pos].isSelected = val);
                    }));
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
                builder: (context, _setState) => CheckboxListTile(
                    activeColor: AppColors.colorYellow,
                    contentPadding: EdgeInsets.all(0),
                    title: Container(
                        child: Row(children: [
                      Image.asset(permissionList[pos].value,
                          width: 20, height: 20),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          permissionList[pos].label ?? "",
                          style: AppTextStyle.regularStyle(
                            color: AppColors.colorBlack85,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ])),
                    value: permissionList[pos].isSelected,
                    onChanged: (val) {
                      _setState(() => permissionList[pos].isSelected = val);
                      debugPrint("${permissionList[pos].isSelected}");
                    }));
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
    SharedPref().getValue('id').then((value) async {
      final request = ReqFamilyNetwork(id: value, limit: 20, page: _page);
      try {
        var res = await api.getFamilyCircle(context,token,request);
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
    });
  }

  _getUserPermission() async {
    ProgressDialogUtils.showProgressDialog(context);
    SharedPref().getToken().then((value) {
      token = value;

      SharedPref().getValue('id').then((value) async {
        final request = ReqFamilyNetwork(id: value, limit: 20, page: _page);
        try {
          var res = await api.getUserPermission(context, token);
          ProgressDialogUtils.dismissProgressDialog();
          var i = 0;
          var imagesList = [
            FileConstants.icFullAccess,
            FileConstants.icAppointments,
            FileConstants.icDocuments,
            FileConstants.icNotifications
          ];
          res.response.forEach((e) {
            permissionList.add(MemberPermissionModel(
                e.permission, false, imagesList[i], e.sId));
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
      });
    });
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
        color: AppColors.colorYellow,
        iconSize: 20,
        label: Strings.saveLabel,
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
    SharedPref().getValue('id').then((value) async {
      final request = ReqAddPermission(
          id: value,
          userId: member.sId,
          userPermissions: checkedPermission,
          step: 2);

      try {
        var res = await api.setMemberPermission(context,token,request);
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
    });
  }

  void onAddPermissionDone(List<String> checkedPermission, String memberId,
      BuildContext context) async {
    Navigator.pop(context);
    ProgressDialogUtils.showProgressDialog(context);
    final request =
        ReqAddUserPermissionModel(userPermissions: checkedPermission);

    try {
      var res = await api.setSpecificMemberPermission(context,token,request, memberId ?? "");
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
              height: 20,
            ),
            _buildList(),
            // _buildPermissionButton(),
            SizedBox(
              height: 20,
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
            width: 50,
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
          title: Strings.labelMyFamilyCircle,
          subTitle: Strings.assignPermisstion,
        ),
        SizedBox(height: 15),
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
            color: AppColors.colorBorder,
            height: 35,
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
                textStyle: AppTextStyle.regularStyle(
                    color: AppColors.colorBlack2, fontSize: 12.0),
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
                    Text(Strings.managePermissionsLabel),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Value2',
                textStyle: AppTextStyle.regularStyle(
                    color: AppColors.colorBlack2, fontSize: 12.0),
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
                    Text(Strings.remove)
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
                debugPrint("Value2");
              }
            },
          );
        },
      ),
    );
  }
}
