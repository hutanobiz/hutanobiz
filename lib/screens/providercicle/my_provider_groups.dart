import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
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
    final res =
        await Navigator.of(context).pushNamed(Routes.createProviderGroup);
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.showBack ? CustomBackButton() : SizedBox(),
              widget.showBack
                  ? AppHeader(
                      progressSteps: HutanoProgressSteps.four,
                    )
                  : SizedBox(),
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
              widget.showBack ? _buildBottomButtons() : SizedBox(),
              SizedBox(height: spacing10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: Column(
        children: [
          ListView.separated(
              separatorBuilder: (_, pos) => Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing10),
                  ),
              shrinkWrap: true,
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
          SizedBox(height: spacing10),
          HutanoButton(
            onPressed: _createGroup,
            color: colorPurple,
            icon: FileConstants.icAddGroup,
            buttonType: HutanoButtonType.withPrefixIcon,
            label: Localization.of(context).addCreateGroup,
          ),
          SizedBox(height: spacing5),
        ],
      ),
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
                label: 'Proceed',
                labelColor: colorBlack,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Routes.addProviderSuccess,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
