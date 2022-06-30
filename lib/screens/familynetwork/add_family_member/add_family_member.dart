import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/familynetwork/my_contacts/my_contacts.dart';
import 'package:hutano/screens/providercicle/search/model/family_member.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/size_config.dart';
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
  final FamilyMember? member;
  final bool isOnboarding;
  const AddFamilyMember({Key? key, this.isOnboarding = true, this.member})
      : super(key: key);

  @override
  _AddFamilyMemberState createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final _relationCotnroller = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<Relations>? _relationList = [];
  List<FamilyNetwork> _memberList = [];
  Relations? _selectedRelation;
  FamilyMember? member;

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
    try {
      var res = await ApiManager().getRelations();
      setState(() {
        _relationList = res.response;
      });
      ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response!);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _onRelationSelected(Relations relation) {
    _selectedRelation = relation;
    _relationCotnroller.text = relation.relation!;
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
    Navigator.of(context).pushNamed(Routes.familyCircle,arguments: widget.isOnboarding);
  }

  _onAdd(FamilyMember member) async {
    if (_relationCotnroller.text.isEmpty) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context)!.errorSelectRelation);
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
      DialogUtils.showAlertDialog(context, e.response!);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    getScreenSize(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.isOnboarding ? _buildHeader() : SizedBox(),
              Container(
                height: screenSize.height * 0.4,
                child: MyContacts(
                  controller: _relationCotnroller,
                  relationList: _relationList,
                  onRelationSelected: _onRelationSelected,
                  searchFocusNode: searchFocus,
                ),
              ),
              Divider(
                height: spacing10,
                color: colorGrey,
                thickness: 0.5,
              ),
              // RelationPicker(
              //   controller: _relationCotnroller,
              //   relationList: _relationList,
              //   onRelationSelected: _onRelationSelected,
              //   member: member,
              // ),
              SizedBox(height: spacing20),
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
                      color: colorWhite,
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
                            Localization.of(context)!.myFamilyNetwork,
                            style: TextStyle(
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: colorBlack2),
                          ),
                        ),
                        Container(
                          height: 150,
                          padding:
                              EdgeInsets.only(left: spacing20, top: spacing20),
                          child: (familyProvider.providerMembers.length == 0)
                              ? Center(
                                  child: NoDataFound(
                                  msg: Localization.of(context)!.noMemberFound,
                                ))
                              : ListView.separated(
                                  separatorBuilder: (_, pos) {
                                    return SizedBox(
                                        width: SizeConfig.screenWidth! / 8);
                                  },
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      familyProvider.providerMembers.length + 1,
                                  itemBuilder: (context, pos) {
                                    if (pos ==
                                        familyProvider.providerMembers.length) {
                                      return InkWell(
                                          onTap: () {
                                            Widgets.showToast(
                                                "Search your contacts and invite them");
                                            searchFocus.requestFocus();
                                          },
                                          child: AddMore());
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
                              _addFamilyMemberApiCall(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("View all members".toUpperCase(),
                                      style: TextStyle(
                                        color: colorPurple100,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: colorPurple100,
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
              widget.isOnboarding ? _buildButtons(context) : SizedBox()
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
          title: Localization.of(context)!.inviteFamilyAndFriends,
          subTitle: Localization.of(context)!.searchPhoneContacts,
        ),
        SizedBox(height: spacing15),
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
          color: accentColor,
          iconSize: 20,
          buttonType: HutanoButtonType.onlyIcon,
          icon: FileConstants.icForward,
          onPressed: () async {
            Navigator.of(context).pushNamed(Routes.inviteFamilyComplete);
          },
        ),
      ),
    );
  }

  void _addFamilyMemberApiCall(BuildContext context) async {
    // if (_relationCotnroller.text.isEmpty) {
    //   DialogUtils.showAlertDialog(
    //       context, Localization.of(context).errorSelectRelation);
    //   return;
    // }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddMember(
        familyMembers: Provider.of<FamilyProvider>(context, listen: false)
            .providerMembers);

    try {
      var res = await ApiManager().addMember(request);
      // showToast(res.response);
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.of(context).pushNamed(Routes.familyCircle,arguments: widget.isOnboarding);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e.hashCode == 422 && e.response == "Family member already exist") {
        Navigator.of(context).pushNamed(Routes.familyCircle,arguments: widget.isOnboarding);
      } else {
        DialogUtils.showAlertDialog(context, e.response!);
      }
    }
  }
}
