import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/req_add_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_relation_list.dart';
import 'package:hutano/screens/familynetwork/my_contacts/my_contacts.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class AddMoreContacts extends StatefulWidget {
  AddMoreContacts({Key? key}) : super(key: key);

  @override
  State<AddMoreContacts> createState() => _AddMoreContactsState();
}

class _AddMoreContactsState extends State<AddMoreContacts> {
  final _relationCotnroller = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<Relations>? _relationList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => {_getRelation()});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
          addHeader: true,
          title: "Activity",
          isAddBack: true,
          color: AppColors.snow,
          child: MyContacts(
            controller: _relationCotnroller,
            relationList: _relationList,
            onRelationSelected: _onRelationSelected,
            searchFocusNode: searchFocus,
          ),
        ));
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
      DialogUtils.showAlertDialog(context, e.response!);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _onRelationSelected(Relations relation) {
    // _selectedRelation = relation;
    _relationCotnroller.text = relation.relation!;
    _addFamilyMemberApiCall(context);
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
      // Navigator.of(context).pushNamed(Routes.familyCircle);
      Navigator.pop(context, true);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e.hashCode == 422 && e.response == "Family member already exist") {
        // Navigator.of(context).pushNamed(Routes.familyCircle,arguments: widget.isOnboarding);
      } else {
        DialogUtils.showAlertDialog(context, e.response!);
      }
    }
  }
}
