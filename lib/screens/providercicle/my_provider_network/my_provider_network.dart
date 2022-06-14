import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/main.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/providercicle/provider_search/item_provider_detail.dart';
import 'package:hutano/screens/providercicle/provider_search/location_service.dart';
import 'package:hutano/screens/providercicle/provider_search/model/doctor_data_model.dart';
import 'package:hutano/screens/providercicle/provider_search/model/res_search_provider.dart';
import 'package:hutano/screens/providercicle/provider_search/provider_search.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

import '../../../utils/dialog_utils.dart';
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
  final bool isOnBoarding;

  const MyProviderNetwrok({Key key, this.isOnBoarding = false})
      : super(key: key);
  @override
  _MyProviderNetwrokState createState() => _MyProviderNetwrokState();
}

class _MyProviderNetwrokState extends State<MyProviderNetwrok> {
  List<ProviderGroupList> _providerGroupList = [];
  List<FamilyNetwork> _memberList = [];
  String _shareMessage;
  TextEditingController searchController = TextEditingController();
  // chnage flow when coming from home screen

  bool isInitlized = false;

  @override
  void initState() {
    super.initState();
    //from home screen then change show provider screen
    if (!widget.isOnBoarding)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getMyProviderGroupList();
      });
    // WidgetsBinding.instance.addPostFrameCallback((_) => {_getFamilyNetwork()});
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
    final id = _providerGroupList[index].doctor[subIndex].sId;
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
    var name = _providerGroupList[index].doctor[subIndex].fullName;

    Widgets.showConfirmationDialog(
        context: navigatorKey.currentState.overlay.context,
        description: "Are you sure you want to remove \n Dr. ${name} ?",
        title: "",
        leftText: "Remove",
        rightText: "Cancel",
        onLeftPressed: () {
          _onRemove(index, subIndex);
        });
    // showBottomSheetRemove(
    //     context: context, onRemove: _onRemove, onCancel: _onCancel);
  }

  _onCancel() {
    Navigator.of(context).pop();
  }

  _onRemove(int index, int subIndex) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().removeProvider(ReqRemoveProvider(
          doctorId: _providerGroupList[index].doctor[subIndex].sId,
          groupId: _providerGroupList[index].providerNetwork.sId,
          userId: getString(PreferenceKey.id)));
      _providerGroupList[index].doctor.removeAt(subIndex);
      setState(() {});
      // if (widget.showBack) Navigator.of(context).pop();
      // _getMyProviderGroupList(showProgress: false);
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
    return Container(
        color: Colors.white,
        child: widget.isOnBoarding
            ? ProviderSearch(isOnBoarding: widget.isOnBoarding)
            : _getRoute());
  }

  _getRoute() {
    if (!isInitlized) {
      return Container();
    }
    return _providerGroupList.isEmpty
        ? ProviderSearch(
            isOnBoarding: widget.isOnBoarding,
          )
        : _mynetworkScreen();
  }

  _mynetworkScreen() {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: spacing30),
        isAddBack: false,
        addHeader: false,
        isAddAppBar: false,
        isBackRequired: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: spacing10),
            // // if (widget.showBack) CustomBackButton(),
            // // if (!fromHome) AppLogo(),
            // _buildHeader(),
            // SizedBox(height: 16),
            serachAppointmentWidget(context),

            SizedBox(height: 16),
            Expanded(
              child: ListSpeciality(
                providerGroupList: _providerGroupList,
                onShare: onShare,
                onRemove: onRemove,
                onMakeAppointment: onMakeAppointment,
                onGroupDelete: (val) {
                  Widgets.showConfirmationDialog(
                    context: context,
                    description: "Are you sure to delete this group?",
                    onLeftPressed: () {
                      _deleteAddress(val);
                    },
                  );
                },
              ),
            ),
            // SizedBox(height: 10),
            // Container(
            //   height: 55.0,
            //   padding: const EdgeInsets.only(right: 14, left: 20.0),
            //   child: FancyButton(
            //     title: Localization.of(context).addNewProviderLabel,
            //     onPressed: () {
            //       Navigator.of(context)
            //           .pushNamed(routeProviderSearch, arguments: {
            //         ArgumentConstant.isFromTabKey: true,
            //         ArgumentConstant.showSkipKey: false,
            //         ArgumentConstant.isForAddKey: true,
            //       }).then((value) => _getMyProviderGroupList());
            //     },
            //   ),
            // ),
          ],
        ),
      ),

      // : Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       SizedBox(height: spacing10),
      //       if (widget.showBack) CustomBackButton(),
      //       AppLogo(),
      //       _buildHeader(),
      //       SizedBox(height: spacing25),
      //       Expanded(
      //         child: ListSpeciality(
      //           providerGroupList: _providerGroupList,
      //           onShare: onShare,
      //           onRemove: onRemove,
      //         ),
      //       ),
      //     ],
      //   ),
    );
  }

  _deleteAddress(int index) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var map = {'groupId': _providerGroupList[index].providerNetwork.sId};
      var res = await ApiManager().deleteProviderGroup(map);
      ProgressDialogUtils.dismissProgressDialog();
      _providerGroupList.removeAt(index);
      setState(() {});
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  onMakeAppointment(int index, int subIndex) {
    Navigator.of(context).pushNamed(Routes.providerProfileScreen,
        arguments: _providerGroupList[index]
            .doctor[subIndex]
            .sId); // _providerGroup.providerNetwork.doctorId[subIndex]);
  }

  Widget serachAppointmentWidget(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: searchController,
              // focusNode: _searchDiseaseFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onTap: () {},
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(spacing8),
                        child: Image.asset(FileConstants.icSearchBlack,
                            color: colorBlack2, width: 20, height: 20))),
                hintText: "Search provider to add in network",
                isDense: true,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              )),
          suggestionsCallback: (pattern) async {
            return pattern.length > 0 ? await _searchProvider(pattern) : [];
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, suggestion) {
            return ItemProviderDetail(
              providerDetail: suggestion,
              isOnBoarding: widget.isOnBoarding,
              onAddPressed: () {
                searchController.text = '';
                final user = suggestion.user[0];
                var occupation = "";
                if (suggestion?.professionalTitle != null &&
                    suggestion.professionalTitle.length > 0) {
                  occupation = suggestion?.professionalTitle[0]?.title ?? "";
                }
                var name = user?.fullName ?? "";
                if (occupation.isNotEmpty) {
                  name = 'Dr. $name , ${occupation.getInitials()}';
                }

                Navigator.of(context)
                    .pushNamed(Routes.providerAddToNetwork, arguments: {
                  ArgumentConstant.doctorId: suggestion.userId,
                  ArgumentConstant.doctorName: name,
                  ArgumentConstant.doctorAvatar: suggestion.user[0].avatar,
                  'isOnBoarding': widget.isOnBoarding
                }).then((value) {
                  if (value) {
                    _getMyProviderGroupList();
                  }
                });
              },
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            searchController.text = '';
            // Navigator.pushNamed(context, Routes.chat, arguments: suggestion);
            final user = suggestion.user[0];
            var occupation = "";
            if (suggestion?.professionalTitle != null &&
                suggestion.professionalTitle.length > 0) {
              occupation = suggestion?.professionalTitle[0]?.title ?? "";
            }
            var name = user?.fullName ?? "";
            if (occupation.isNotEmpty) {
              name = 'Dr. $name , ${occupation.getInitials()}';
            }

            Navigator.of(context)
                .pushNamed(Routes.providerAddToNetwork, arguments: {
              ArgumentConstant.doctorId: suggestion.userId,
              ArgumentConstant.doctorName: name,
              ArgumentConstant.doctorAvatar: suggestion.user[0].avatar,
              'isOnBoarding': widget.isOnBoarding
            }).then((value) {
              if (value) {
                _getMyProviderGroupList();
              }
            });
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

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

  Future<List<DoctorData>> _searchProvider(String pattern) async {
    // FocusManager.instance.primaryFocus.unfocus();

    final locationData = LocationService().getLocationData();
    final param = <String, dynamic>{'search': pattern, 'page': 1, 'limit': 10};
    if (locationData != null) {
      param['lattitude'] = locationData.latitude;
      param['longitude'] = locationData.longitude;
    }
    try {
      ResProviderSearch res = await ApiManager().searchProvider(param);
      return res.response.doctorData;
    } on ErrorModel catch (e) {
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      debugPrint(e);
    }
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        Localization.of(context).myProviderNetwork,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: colorBlack2,
            fontWeight: FontWeight.w700,
            fontFamily: gilroyBold,
            fontStyle: FontStyle.normal,
            fontSize: 20.0),
      ),
    );
  }
}
