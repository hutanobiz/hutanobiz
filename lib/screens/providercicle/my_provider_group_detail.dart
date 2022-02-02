import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_add_member.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/req_family_network.dart';
import 'package:hutano/screens/providercicle/my_provider_network/item_provider_detail.dart'
    as Provider;
import 'package:hutano/screens/providercicle/my_provider_network/model/req_remove_provider.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/req_share_provider.dart';
import 'package:hutano/screens/providercicle/my_provider_network/model/res_my_provider_network.dart';
import 'package:hutano/screens/providercicle/my_provider_network/share_provider.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/provider_network.dart';

import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/main.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/req_add_provider.dart';
import 'package:hutano/screens/providercicle/provider_search/item_provider_detail.dart';
import 'package:hutano/screens/providercicle/provider_search/model/doctor_data_model.dart';
import 'package:hutano/screens/providercicle/provider_search/model/provider_detail_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

import '../../widgets/bottom_sheet.dart' as share_bottom_sheet;
import 'provider_search/location_service.dart';
import '../../utils/extensions.dart';

class MyProviderGroupDetail extends StatefulWidget {
  MyProviderGroupDetail({Key key, this.providerGroup}) : super(key: key);
  ProviderNetwork providerGroup;
  @override
  _MyProviderGroupDetailState createState() => _MyProviderGroupDetailState();
}

class _MyProviderGroupDetailState extends State<MyProviderGroupDetail> {
  ProviderGroupList _providerGroup;
  List<FamilyNetwork> _memberList = [];
  ReqRemoveProvider _removeProvider;
  String _shareMessage;
  bool fromHome = true;
  bool isInitlized = false;
  var locationData;
  final seachProviderController = TextEditingController();
  final searchProviderFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fromHome = widget.providerGroup.isSelected;
    locationData = LocationService().getLocationData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyProviderGroupList();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => {_getFamilyNetwork()});
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
    final id = _providerGroup.doctor[subIndex].sId;
    // _providerGroup.providerNetwork.doctorId[subIndex];
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
    _removeProvider = ReqRemoveProvider(
        doctorId: _providerGroup
            .doctor[subIndex].sId, // .providerNetwork.doctorId[subIndex],
        groupId: _providerGroup.providerNetwork.sId,
        userId: getString(PreferenceKey.id));

    var name = _providerGroup.doctor[0].fullName;

    Widgets.showConfirmationDialog(
        context: navigatorKey.currentState.overlay.context,
        description: "Are you sure you want to remove \n Dr. ${name} ?",
        title: "",
        leftText: "Remove",
        rightText: "Cancel",
        onLeftPressed: _onRemove(subIndex));
  }

  onMakeAppointment(int index, int subIndex) {
    Navigator.of(context).pushNamed(Routes.providerProfileScreen,
        arguments: _providerGroup.doctor[subIndex]
            .sId); // _providerGroup.providerNetwork.doctorId[subIndex]);
  }

  _onRemove(int subIndex) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().removeProvider(_removeProvider);
      _providerGroup.docInfo.removeAt(subIndex);
      _providerGroup.doctor.removeAt(subIndex);
      setState(() {});
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
        for (var ii in res.response.data) {
          if (ii.providerNetwork.sId == widget.providerGroup.sId) {
            _providerGroup = ii;
            break;
          }
        }
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
    return Container(child: _getRoute());
  }

  _getRoute() {
    if (!isInitlized) {
      return Container(
        color: Colors.white,
      );
    }
    return _mynetworkScreen();
  }

  _mynetworkScreen() {
    return Scaffold(
        backgroundColor: fromHome ? AppColors.goldenTainoi : Colors.white,
        body: LoadingBackgroundNew(
          title: widget.providerGroup.groupName,
          padding: EdgeInsets.all(0),
          isAddBack: fromHome,
          addHeader: fromHome, // !fromHome,
          isAddAppBar: fromHome, // !fromHome,
          isBackRequired: fromHome,
          centerTitle: fromHome,
          addTitle: fromHome,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // fromHome
              //     ? Padding(
              //         padding: const EdgeInsets.only(left: 15, bottom: 20),
              //         child: Text(
              //           "Add new providers",
              //           style:
              //               TextStyle(fontSize: 17, fontWeight: fontWeightBold),
              //         ),
              //       )
              //     : SizedBox.shrink(),
              fromHome
                  ? SizedBox(height: 16)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomBackButton(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              "Add new providers",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: colorBlack2,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: gilroyBold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),

              // fromHome
              //     ? SizedBox()
              //     : AppHeader(
              //         progressSteps: HutanoProgressSteps.four,
              //       ),
              // fromHome ? SizedBox() : _buildHeader(),
              fromHome ? SizedBox() : SizedBox(height: 20),
              searchProvider(context),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (_, pos) {
                      return SizedBox(height: spacing15);
                    },
                    shrinkWrap: true,
                    itemCount: _providerGroup.docInfo.length,
                    itemBuilder: (_, position) {
                      return Provider.ItemProviderDetail(
                          providerDetail: _getProviderDetail(0, position),
                          index: 0,
                          subIndex: position,
                          onShare: onShare,
                          onRemove: onRemove,
                          onMakeAppointment:
                              fromHome ? onMakeAppointment : null);
                    }),
              ),
            ],
          ),
        ));
  }

  _getProviderDetail(index, subIndex) {
    final doctorData = _providerGroup.doctor[subIndex];
    final doctorProfessionInfo = _providerGroup.docInfo[subIndex];

    final avatar = doctorData.avatar ?? "";
    final rating = doctorProfessionInfo.averageRating;
    // final occupation = doctorProfessionInfo?.professionalTitle[0]?.title ?? "";
    // final occupation = "MD A";
    var name = doctorData.fullName ?? "";
    // name = '$name , ${occupation.getInitials()}';

    final experience = doctorProfessionInfo.practicingSince.getYearCount();

    return ProviderDetail(
        image: avatar,
        rating: rating,
        name: name,
        occupation: '',
        experience: experience);
  }

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

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Add new providers",
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

  Widget searchProvider(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TypeAheadFormField(
          suggestionsBoxDecoration:
              SuggestionsBoxDecoration(borderRadius: BorderRadius.circular(5)),
          textFieldConfiguration: TextFieldConfiguration(
              controller: seachProviderController,
              focusNode: searchProviderFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onTap: () {},
              onChanged: (value) {},
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.mineShaft.withOpacity(0.06),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "images/search.png",
                    height: 16,
                    width: 16,
                  ),
                ),
                hintText: 'Search provider',
                isDense: true,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black12, width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black12, width: 0),
                ),
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
              
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            seachProviderController.text = "";
            _addGroup(suggestion.userId);
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  Future<List<DoctorData>> _searchProvider(String pattern) async {
    final param = <String, dynamic>{'search': pattern, 'page': 1, 'limit': 10};
    if (locationData != null) {
      param['lattitude'] = locationData.latitude;
      param['longitude'] = locationData.longitude;
    }

    var res = await ApiManager().searchProvider(param);
    return res.response.doctorData;
  }

  void _addGroup(doctorId) async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
        doctorId: doctorId,
        userId: getString(PreferenceKey.id),
        groupId: widget.providerGroup.sId);
    try {
      var res = await ApiManager().addProviderNetwork(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showErrorDialog(
          context: context,
          description: res.response.toString(),
          onPressed: () {
            Navigator.of(context).pop();
            _getMyProviderGroupList(showProgress: true);
          });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }
}
