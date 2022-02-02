import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/providercicle/provider_search/model/doctor_data_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:hutano/utils/extensions.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/placeholder_image.dart';
import 'list_item.dart';
import 'model/provider_network.dart';
import 'model/req_add_provider.dart';

class ProivderAddToNetwork extends StatefulWidget {
  final String doctorName;
  final String doctorId;
  final String doctorAvatar;
  final bool isOnBoarding;
  final onCompleteRoute;

  const ProivderAddToNetwork(
      {Key key,
      this.doctorName,
      this.doctorId,
      this.doctorAvatar,
      this.isOnBoarding,
      this.onCompleteRoute})
      : super(key: key);
  @override
  _ProivderAddToNetworkState createState() => _ProivderAddToNetworkState();
}

class _ProivderAddToNetworkState extends State<ProivderAddToNetwork> {
  bool _enableButton = false;
  ProviderNetwork selectedGroup; //selected group index
  List<ProviderNetwork> specialityList = <ProviderNetwork>[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProvidersGroup();
    });
  }

  _getProvidersGroup() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().getProviderGroups();
      ProgressDialogUtils.dismissProgressDialog();
      if (res.response.data.providerNetwork != null) {
        setState(() {
          specialityList = res.response.data.providerNetwork;
        });
      }
      // if (specialityList.length > 0) {
      //   _index = specialityList.length - 1;
      //   setState(() {
      //     specialityList[specialityList.length - 1].isSelected = true;
      //     _enableButton = true;
      //   });
      // }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void _addToSelectedGroup() async {
    if (selectedGroup == null) return;
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
        doctorId: widget.doctorId,
        userId: getString(PreferenceKey.id),
        groupId: selectedGroup.sId);
    try {
      var res = await ApiManager().addProviderNetwork(request);
      ProgressDialogUtils.dismissProgressDialog();
      // if (widget.isOnBoarding) {
      //   Navigator.pushNamed(context, Routes.addMoreProviderScreen, arguments: {
      //     'groupName': selectedGroup.groupName,
      //     ArgumentConstant.doctorId: widget.doctorId,
      //     ArgumentConstant.doctorName: widget.doctorName,
      //     ArgumentConstant.doctorAvatar: widget.doctorAvatar,
      //     'isOnBoarding': widget.isOnBoarding,
      //     "onCompleteRoute": widget.onCompleteRoute
      //   });
      // } else {
      Widgets.showAppDialog(
          context: context,
          description:
              '${widget.doctorName} added to group ${selectedGroup.groupName}',
          buttonText: 'Done',
          onPressed: () {
            if (widget.isOnBoarding) {
              Navigator.pop(context);
              Navigator.pop(context,true);
              // Navigator.pop(context);

              // Navigator.popUntil(
              //     context, ModalRoute.withName(Routes.myProviderNetwork));
            } else {
              if (widget.onCompleteRoute != null) {
                Navigator.popUntil(
                    context, ModalRoute.withName(widget.onCompleteRoute));
              } else {
                Navigator.popUntil(
                    context, ModalRoute.withName(Routes.homeMain));
              }
            }
          },
          isCongrats: true);
      // }
      // Widgets.showAlertDialog(
      //   context,
      //   Localization.of(context).appName,
      //   res.response.toString(),
      //   () {
      //     Navigator.of(context).pop();
      //     Navigator.of(context).pop(true);
      //   },
      // ); //isConfirmationDialog: false, buttonText: "OK");
      // DialogUtils.showOkCancelAlertDialog(
      //     context: context,
      //     message: res.response.toString(),
      //     isCancelEnable: false,
      //     okButtonTitle: Localization.of(context).ok,
      //     okButtonAction: () {
      //       Navigator.of(context).pushNamed(
      //         routeAddProviderSuccess,
      //       );
      //     });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void _createGroup() async {
    Navigator.of(context).pushNamed(Routes.createProviderGroup, arguments: {
      ArgumentConstant.doctorId: widget.doctorId,
      ArgumentConstant.doctorName: widget.doctorName,
      ArgumentConstant.doctorAvatar: widget.doctorAvatar,
      'isOnBoarding': widget.isOnBoarding,
      "onCompleteRoute": widget.onCompleteRoute
    });
    // if (res != null) {
    //   _getProvidersGroup();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          widget.isOnBoarding ? AppColors.snow : AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        isAddBack: widget.isOnBoarding,
        addHeader: !widget.isOnBoarding,
        isBackRequired: !widget.isOnBoarding,
        title: "",
        isAddAppBar: !widget.isOnBoarding,
        addBottomArrows: false,
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isOnBoarding ? CustomBackButton() : SizedBox(),
            widget.isOnBoarding
                ? AppHeader(
                    progressSteps: HutanoProgressSteps.four,
                  )
                : SizedBox(height: 20),
            _buildHeader(),
            SizedBox(height: spacing25),
            Text(
              Localization.of(context).addToExistinGroup,
              style: const TextStyle(
                color: colorBlack2,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600,
                fontFamily: gilroySemiBold,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: spacing15),
            _buildList(),
            SizedBox(height: spacing10),
            HutanoButton(
              onPressed: _createGroup,
              color: colorPurple,
              icon: FileConstants.icAddGroup,
              buttonType: HutanoButtonType.withPrefixIcon,
              label: Localization.of(context).addCreateGroup,
            ),
            SizedBox(height: spacing5),
            _buildBottomButtons(),
            SizedBox(height: spacing10),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (_, pos) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
          shrinkWrap: true,
          itemCount: specialityList.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.grey[300],
                  width: 1.0,
                ),
              ),
              // padding: EdgeInsets.all(spacing10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: PlaceHolderImage(
                  //     width: 34,
                  //     height: 34,
                  //     image: ' ',
                  //     placeholder: FileConstants.icDoctorSpecialist,
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        specialityList[index].groupName,
                        style: const TextStyle(
                            color: colorBlack85, fontSize: fontSize14),
                      ),
                    ),
                  ),
                  Radio(
                      value: specialityList[index],
                      groupValue: selectedGroup,
                      activeColor: AppColors.windsor,
                      onChanged: (val) {
                        setState(() {
                          selectedGroup = val;
                          _enableButton = true;
                        });
                      })
                  // Image.asset(
                  //   _item.isSelected
                  //       ? FileConstants.icCheck
                  //       : FileConstants.icUncheckSquare,
                  //   height: 22,
                  //   fit: BoxFit.cover,
                  //   width: 22,
                  // )
                ],
              ),
            );
            // InkWell(
            //   onTap: () {
            //     specialityList.forEach((element) => element.isSelected = false);
            //     _index = index;
            //     setState(() {
            //       specialityList[index].isSelected = true;
            //       _enableButton = true;
            //     });
            //   },
            //   child: ListItem(specialityList[index]),
            // );
          }),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        ClipOval(
          // backgroundImage: NetworkImage(widget.doctorAvatar),
          child: PlaceHolderImage(
            height: 60,
            width: 60,
            image: widget.doctorAvatar,
            placeholder: FileConstants.icDoctorSpecialist,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Flexible(
          child: Text(
            Localization.of(context)
                .addDoctorNetwork
                .format([widget.doctorName]),
            softWrap: true,
            maxLines: 2,
            style: const TextStyle(fontSize: fontSize16),
          ),
        )
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Flexible(
      flex: 0,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: HutanoButton(
              label: Localization.of(context).add,
              labelColor: colorBlack,
              onPressed: _enableButton ? _addToSelectedGroup : null,
            ),
          ),
        ],
      ),
    );
  }
}
