import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/familynetwork/my_contacts/my_contacts.dart';
import 'package:hutano/screens/providercicle/search/model/family_member.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../utils/dialog_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import 'family_member_list.dart';
import 'model/req_add_member.dart';
import 'model/res_add_member.dart';
import 'model/res_relation_list.dart';

class AddFamilyMember extends StatefulWidget {
  final FamilyMember member;

  const AddFamilyMember({Key key, this.member}) : super(key: key);

  @override
  _AddFamilyMemberState createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final _relationCotnroller = TextEditingController();
  List<Relations> _relationList = [];
  List<FamilyNetwork> _memberList = [];
  Relations _selectedRelation;
  FamilyMember member;
  ApiBaseHelper api = ApiBaseHelper();
  String token;

  @override
  void initState() {
    super.initState();
    // member = widget.member;
    //TODO :TEMP CODE
    // _memberList.add(FamilyNetwork(
    //     avatar: "",
    //     fullName: "Hi",
    //     userRelation: 1,
    //     sId: "12",
    //     phoneNumber: "12312312312",
    //     relation: "Brother"));
    WidgetsBinding.instance.addPostFrameCallback((_) => {_getRelation()});
    // WidgetsBinding.instance.addPostFrameCallback((_) => {_getFamilyNetwork()});
  }

  // _getFamilyNetwork() async {
  //   final request = ReqFamilyNetwork(
  //       id: getString(PreferenceKey.id, ""), limit: dataLimit, page: 1);
  //   try {
  //     var res = await ApiManager().getFamilyNetowrk(request);
  //     ProgressDialogUtils.dismissProgressDialog();
  //     setState(() {
  //       _memberList = res.response.familyNetwork;
  //     });
  //   } on ErrorModel catch (e) {
  //     ProgressDialogUtils.dismissProgressDialog();
  //     // DialogUtils.showAlertDialog(context, e.response);
  //   } catch (e) {
  //     ProgressDialogUtils.dismissProgressDialog();
  //     print(e);
  //   }
  // }

  _getRelation() async {
    ProgressDialogUtils.showProgressDialog(context);
    SharedPref().getToken().then((value) async {
      token = value;
      try {
        var res = await api.getRelations(context, token);
        setState(() {
          _relationList = res.response;
        });
        ProgressDialogUtils.dismissProgressDialog();
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
      }
    });
  }

  _onRelationSelected(Relations relation) {
    _selectedRelation = relation;
    _relationCotnroller.text = relation.relation;
  }

  _onAddMore() async {
    dynamic response = await Navigator.of(context).pushNamed(Routes.routeSearch,
        arguments: {ArgumentConstant.searchScreen: SearchScreenFrom.addMore});
    print(member);
    if (response != null) {
      setState(() {
        member = response[ArgumentConstant.member];
      });
    }
  }

  _onContinue() {
    Navigator.of(context).pushNamed(Routes.familyCircle);
  }

  _onAdd(FamilyMember member) async {
    if (_relationCotnroller.text.isEmpty) {
      DialogUtils.showAlertDialog(context, Strings.errorSelectRelation);
      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    // final request = ReqAddMember(
    //     id: getString(PreferenceKey.id, ""),
    //     userId: member.sId,
    //     userRelation: _selectedRelation.relationId,
    //     step: 1);

    try {
      // var res = await ApiManager().addMember(request);
      // if (res.data != null) {
      //   setState(() {
      //     _memberList = res.data.familyNetwork;
      //   });
      // }
      // ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: MyContacts(
                  controller: _relationCotnroller,
                  relationList: _relationList,
                  onRelationSelected: _onRelationSelected,
                ),
              ),
              Divider(
                height: 10,
                color: AppColors.colorGrey,
                thickness: 0.5,
              ),
              // RelationPicker(
              //   controller: _relationCotnroller,
              //   relationList: _relationList,
              //   onRelationSelected: _onRelationSelected,
              //   member: member,
              // ),
              SizedBox(height: 20),
              // if (member != null)
              //   MemberRow(
              //     member: member,
              //     onAdd: _onAdd,
              //   ),
              // SizedBox(height: spacing20),
              Consumer<FamilyProvider>(
                builder: (context, familyProvider, __) {
                  return Container(
                    decoration: new BoxDecoration(
                      color: AppColors.colorWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x148b8b8b),
                            offset: Offset(0, 2),
                            blurRadius: 30,
                            spreadRadius: 0)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            Strings.myFamilyNetwork,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: AppColors.colorBlack2),
                          ),
                        ),
                        Container(
                          height: 150,
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: (familyProvider.providerMembers.length == 0)
                              ? Center(
                                  child: NoDataFound(
                                  msg: Strings.noMemberFound,
                                ))
                              : ListView.separated(
                                  separatorBuilder: (_, pos) {
                                    return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8);
                                  },
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      familyProvider.providerMembers.length + 1,
                                  itemBuilder: (context, pos) {
                                    if (pos ==
                                        familyProvider.providerMembers.length) {
                                      return AddMore();
                                    }
                                    return ItemFamilyMember(
                                        contact: familyProvider
                                            .providerContacts[pos],
                                        memberIndex: pos,
                                        member: FamilyMember(
                                          avatar: familyProvider
                                              .providerMembers[pos].name,
                                          fullName: familyProvider
                                              .providerMembers[pos].name,
                                          relation: familyProvider
                                                  .providerMembers[pos]
                                                  .relation ??
                                              "",
                                          phoneNumber: familyProvider
                                              .providerMembers[pos].phone,
                                        ));
                                  },
                                ),
                        ),
                        Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        if ((familyProvider.providerMembers.length != 0))
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.familyCircle);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("View all members".toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.colorPurple100,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppColors.colorPurple100,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
              // FamilyMemberList(memberList: _memberList),
              _buildButtons(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AppHeader(
          progressSteps: HutanoProgressSteps.three,
          title: Strings.inviteFamilyAndFriends,
          subTitle: Strings.searchPhoneContacts,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerRight,
        child: HutanoButton(
          width: 55,
          height: 55,
          color: AppColors.accentColor,
          iconSize: 20,
          buttonType: HutanoButtonType.onlyIcon,
          icon: FileConstants.icForward,
          onPressed: () async {
            if (Provider.of<FamilyProvider>(context, listen: false)
                .providerMembers
                .isNotEmpty) {
              _addFamilyMemberApiCall(context);
            } else {
              Navigator.of(context).pushNamed(Routes.inviteFamilyComplete);
            }
          },
        ),
      ),
    );
  }

  void _addFamilyMemberApiCall(BuildContext context) async {
    // if (_relationCotnroller.text.isEmpty) {
    //   DialogUtils.showAlertDialog(
    //       context, Strings.errorSelectRelation);
    //   return;
    // }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddMember(
        familyMembers: Provider.of<FamilyProvider>(context, listen: false)
            .providerMembers);

    try {
      var res = await api.addMember(context, token, request);
      Widgets.showToast(res.response);
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.of(context).pushNamed(Routes.inviteFamilyComplete);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }
}
