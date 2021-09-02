import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/providercicle/create_group/create_provider_group.dart';
import 'package:hutano/screens/providercicle/provider_add_network/list_item.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/provider_network.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class MyProviderGroups extends StatefulWidget {
  MyProviderGroups({Key key, this.showBack = false}) : super(key: key);
  bool showBack;
  @override
  _MyProviderGroupsState createState() => _MyProviderGroupsState();
}

class _MyProviderGroupsState extends State<MyProviderGroups> {
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
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void _createGroup() async {
    // final res =
    //     await Navigator.of(context).pushNamed(Routes.createProviderGroup);
    final res = await showDialog(
        context: context,
        builder: (context) {
          return CreateProviderGroup();
        });
    if (res != null) {
      _getProvidersGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.showBack ? Colors.white : AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "Provider Network",
        padding: const EdgeInsets.all(0),
        isAddBack: false,
        addHeader: !widget.showBack, // !fromHome,
        isAddAppBar: !widget.showBack, // !fromHome,
        isBackRequired: false,
        centerTitle: !widget.showBack,
        addTitle: !widget.showBack,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              widget.showBack
                  ? Row(
                      children: [
                        CustomBackButton(),
                      ],
                    )
                  : SizedBox.shrink(),
              Expanded(
                child: ListView(children: [
                  widget.showBack
                      ? AppHeader(
                          progressSteps: HutanoProgressSteps.four,
                        )
                      : SizedBox(),
                  widget.showBack
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Provider Network",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: fontWeightBold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Add providers to your network",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black.withOpacity(0.85)),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: spacing25),
                  widget.showBack
                      ? SizedBox.shrink()
                      : Text(
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
                ]),
              ),
              widget.showBack ? _buildBottomButtons() : SizedBox(),
              SizedBox(height: spacing10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, pos) => Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing10),
                ),
            itemCount: specialityList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  specialityList[index].isSelected = !widget.showBack;
                  Navigator.pushNamed(context, Routes.myProviderGroupDetail,
                      arguments: specialityList[index]);
                },
                child: ListItem(specialityList[index]),
              );
            }),
        SizedBox(height: spacing20),
        GestureDetector(
          onTap: _createGroup,
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.windsor.withOpacity(0.01),
                      offset: Offset(0, 2),
                      spreadRadius: 5,
                      blurRadius: 5)
                ]),
            child: Row(
              children: [
                Image.asset(
                  "images/blue_add.png",
                  height: 43,
                  width: 43,
                ),
                SizedBox(width: 12),
                Text(
                  "Create New Group",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        // HutanoButton(
        //   onPressed: _createGroup,
        //   color: colorPurple,
        //   icon: FileConstants.icAddGroup,
        //   buttonType: HutanoButtonType.withPrefixIcon,
        //   label: Localization.of(context).addCreateGroup,
        // ),
        SizedBox(height: spacing5),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return HutanoButton(
        label: 'Proceed',
        labelColor: colorBlack,
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.addProviderSuccess,
          );
        });
  }
}
