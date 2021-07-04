import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/main.dart';
import 'package:hutano/screens/providercicle/provider_search/provider_search.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/progress_dialog.dart';

import '../../../widgets/bottom_sheet.dart' as share_bottom_sheet;
import '../../../widgets/custom_back_button.dart';
import '../../familynetwork/add_family_member/model/res_add_member.dart';
import '../../familynetwork/familycircle/model/req_family_network.dart';
import 'list_speciality.dart';
import 'model/req_remove_provider.dart';
import 'model/req_share_provider.dart';
import 'model/res_my_provider_network.dart';
import 'share_provider.dart';

class MyProviderNetwrok extends StatefulWidget {
  final bool showBack;

  const MyProviderNetwrok({Key key, this.showBack = true}) : super(key: key);
  @override
  _MyProviderNetwrokState createState() => _MyProviderNetwrokState();
}

class _MyProviderNetwrokState extends State<MyProviderNetwrok> {
  List<ProviderGroupList> _providerGroupList = [];
  List<FamilyNetwork> _memberList = [];
  ReqRemoveProvider _removeProvider;
  String _shareMessage;
  // chnage flow when coming from home screen
  bool fromHome = false;
  bool isInitlized = false;
  ApiBaseHelper api = ApiBaseHelper();
  String token, userId;

  @override
  void initState() {
    super.initState();
    //from home screen then change show provider screen
    fromHome = !widget.showBack;
    SharedPref().getToken().then((value) {
      token = value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getMyProviderGroupList();
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => {_getFamilyNetwork()});
    });
  }

  _getFamilyNetwork() async {
    SharedPref().getValue('id').then((value) async {
      userId = value;
      final request = ReqFamilyNetwork(id: value, limit: 20, page: 1);
      try {
        var res = await api.getFamilyNetowrk(context, token, request);
        setState(() {
          _memberList = res.response.familyNetwork;
        });
      } on ErrorModel catch (e) {
        print(e.response);
      }
    });
  }

  _onShareClick() {
    share_bottom_sheet.showBottomSheet(
        context: context,
        color: AppColors.colorBottomSheet,
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
      var res = await api.shareProvider(context, token, request);
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
        userId: userId);

    var name = _providerGroupList[index].doctor[0].fullName;

    Widgets.showConfirmationDialog(
        context: navigatorKey.currentState.overlay.context,
        description: "Are you sure you want to remove \n Dr. ${name} ?",
        title: "",
        leftText: "Remove",
        rightText: "Cancel",
        onLeftPressed: _onRemove);
    // showBottomSheetRemove(
    //     context: context, onRemove: _onRemove, onCancel: _onCancel);
  }

  _onCancel() {
    Navigator.of(context).pop();
  }

  _onRemove() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await api.removeProvider(context, token, _removeProvider);
      if (widget.showBack) Navigator.of(context).pop();
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
      var res = await api.getMyProviderNetwork(context, token);
      ProgressDialogUtils.dismissProgressDialog();
      isInitlized = true;
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
    return Container(child: !fromHome ? _mynetworkScreen() : _getRoute());
  }

  _getRoute() {
    if (!isInitlized) {
      return Container();
    }
    return _providerGroupList.isEmpty
        ? ProviderSearch(showSkip: false, isFromTab: true)
        : _mynetworkScreen();
  }

  _mynetworkScreen() {
    return Scaffold(
      backgroundColor: fromHome ? AppColors.goldenTainoi : Colors.white,
      body: fromHome
          ? LoadingBackgroundNew(
              title: "",
              padding: const EdgeInsets.all(0),
              isAddBack: false,
              addHeader: fromHome,
              isBackRequired: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  if (widget.showBack) CustomBackButton(),
                  if (!fromHome) AppLogo(),
                  _buildHeader(),
                  SizedBox(height: 25),
                  Expanded(
                    child: ListSpeciality(
                      providerGroupList: _providerGroupList,
                      onShare: onShare,
                      onRemove: onRemove,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                if (widget.showBack) CustomBackButton(),
                AppLogo(),
                _buildHeader(),
                SizedBox(height: 25),
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
    SharedPref().getValue('id').then((value) async {
      final request = ReqShareProvider(userId: value);
      try {
        var res = await api.shareAllProvider(context, token, request);
        ProgressDialogUtils.dismissProgressDialog();
        _shareMessage = res.message;
        _onShareClick();
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
      }
    });
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        Strings.myProviderNetwork,
        textAlign: TextAlign.center,
        style: AppTextStyle.boldStyle(
            color: AppColors.colorBlack2,
            fontWeight: FontWeight.w700,
            fontSize: 20.0),
      ),
    );
  }
}
