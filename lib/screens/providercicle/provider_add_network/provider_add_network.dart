import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:hutano/utils/extensions.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/placeholder_image.dart';
import 'list_item.dart';
import 'model/provider_network.dart';
import 'model/req_add_provider.dart';

class ProivderAddNetwork extends StatefulWidget {
  final String doctorName;
  final String doctorId;
  final String doctorAvatar;

  const ProivderAddNetwork({
    Key key,
    this.doctorName,
    this.doctorId,
    this.doctorAvatar,
  }) : super(key: key);
  @override
  _ProivderAddNetworkState createState() => _ProivderAddNetworkState();
}

class _ProivderAddNetworkState extends State<ProivderAddNetwork> {
  bool _enableButton = false;
  int _index = -1; //selected group index
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
      if (specialityList.length > 0) {
        _index = specialityList.length - 1;
        setState(() {
          specialityList[specialityList.length - 1].isSelected = true;
          _enableButton = true;
        });
      }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void _addGroup() async {
    if (_index == -1) return;
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
        doctorId: widget.doctorId,
        userId: getString(PreferenceKey.id),
        groupId: specialityList[_index].sId);
    try {
      var res = await ApiManager().addProviderNetwork(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showErrorDialog(
          context: context,
          description: res.response.toString(),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(
              Routes.addProviderSuccess,
            );
          });
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
    final res =
        await Navigator.of(context).pushNamed(Routes.createProviderGroup);
    if (res != null) {
      _getProvidersGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppHeader(
                progressSteps: HutanoProgressSteps.four,
              ),
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
              _buildBottomButtons(),
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
                    specialityList
                        .forEach((element) => element.isSelected = false);
                    _index = index;
                    setState(() {
                      specialityList[index].isSelected = true;
                      _enableButton = true;
                    });
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
              onPressed: _enableButton ? _addGroup : null,
            ),
          ),
        ],
      ),
    );
  }
}
