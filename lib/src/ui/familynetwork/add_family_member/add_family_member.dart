import 'package:flutter/material.dart';
import 'package:hutano/src/ui/familynetwork/my_contacts/my_contacts.dart';
import 'package:hutano/src/widgets/app_header.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/hutano_button.dart';
import '../../provider/search/model/family_member.dart';
import '../familycircle/model/req_family_network.dart';
import 'family_member_list.dart';
import 'member_detail.dart';
import 'model/req_add_member.dart';
import 'model/res_add_member.dart';
import 'model/res_relation_list.dart';
import 'relation_picker.dart';

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

  _getFamilyNetwork() async {
    final request = ReqFamilyNetwork(
        id: getString(PreferenceKey.id, ""), limit: dataLimit, page: 1);
    try {
      var res = await ApiManager().getFamilyNetowrk(request);
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        _memberList = res.response.familyNetwork;
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      // DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

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
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _onRelationSelected(Relations relation) {
    _selectedRelation = relation;
    _relationCotnroller.text = relation.relation;
  }

  _onAddMore() async {
    dynamic response = await Navigator.of(context).pushNamed(routeSearch,
        arguments: {ArgumentConstant.searchScreen: SearchScreenFrom.addMore});
    print(member);
    if (response != null) {
      setState(() {
        member = response[ArgumentConstant.member];
      });
    }
  }

  _onContinue() {
    Navigator.of(context).pushNamed(routeFamilyCircle);
  }

  _onAdd(FamilyMember member) async {
    if (_relationCotnroller.text.isEmpty) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).errorSelectRelation);
      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddMember(
        id: getString(PreferenceKey.id, ""),
        userId: member.sId,
        userRelation: _selectedRelation.relationId,
        step: 1);

    try {
      var res = await ApiManager().addMember(request);
      if (res.data != null) {
        setState(() {
          _memberList = res.data.familyNetwork;
        });
      }
      ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Container(
                height: 270,
                child: MyContacts(),
              ),
              Divider(
                height: spacing25,
                color: colorGrey,
                thickness: 0.5,
              ),
              RelationPicker(
                controller: _relationCotnroller,
                relationList: _relationList,
                onRelationSelected: _onRelationSelected,
                member: member,
              ),
              SizedBox(height: spacing20),
              if (member != null)
                MemberRow(
                  member: member,
                  onAdd: _onAdd,
                ),
              SizedBox(height: spacing20),
              FamilyMemberList(memberList: _memberList),
              _buildButtons()
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
          title: Localization.of(context).inviteFamilyAndFriends,
          subTitle: Localization.of(context).searchPhoneContacts,
        ),
        SizedBox(height: spacing15),
      ],
    );
  }

  Widget _buildButtons() {
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
          onPressed: () {
            Navigator.of(context).pushNamed(routeProviderSearch);
          },
        ),
      ),
    );
  }
}
