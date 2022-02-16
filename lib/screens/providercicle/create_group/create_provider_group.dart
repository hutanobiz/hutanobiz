import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/providercicle/provider_search/model/doctor_data_model.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/placeholder_image.dart';
import 'package:hutano/widgets/widgets.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_textfield.dart';
import '../provider_add_network/model/req_add_provider.dart';

class CreateProviderGroup extends StatefulWidget {
  String doctorId;
  String doctorName;
  String doctorAvatar;
  bool isOnBoarding;
  final onCompleteRoute;
  CreateProviderGroup(
      {Key key,
      this.isOnBoarding,
      this.doctorAvatar,
      this.doctorName,
      this.doctorId,
      this.onCompleteRoute})
      : super(key: key);
  @override
  _CreateProviderGroupState createState() => _CreateProviderGroupState();
}

class _CreateProviderGroupState extends State<CreateProviderGroup> {
  final FocusNode _groupFocus = FocusNode();
  final _groupNameController = TextEditingController();
  bool _enableButton = false;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _addGroup() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqAddProvider(
        groupName: _groupNameController.text.toString(),
        userId: getString(PreferenceKey.id),
        doctorId: widget.doctorId);
    try {
      var res = await ApiManager().addProviderNetwork(request);
      ProgressDialogUtils.dismissProgressDialog();
      // if (widget.isOnBoarding) {
      //   Navigator.pushNamed(context, Routes.addMoreProviderScreen, arguments: {
      //     'groupName': _groupNameController.text,
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
              '${widget.doctorName} added to group ${_groupNameController.text}',
          buttonText: 'Done',
          onPressed: () {
            if (widget.isOnBoarding) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context, true);
              // Navigator.popUntil(
              //     context, ModalRoute.withName(Routes.myProviderNetwork));
            } else {
              if (widget.onCompleteRoute != null) {
                Navigator.popUntil(
                    context, ModalRoute.withName(widget.onCompleteRoute));
              } else {
                 Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context, true);
                // Navigator.popUntil(
                //     context, ModalRoute.withName(Routes.homeMain));
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
      //     Navigator.of(context).pop({ArgumentConstant.number: ""});
      //   },
      // ); // isConfirmationDialog: false, buttonText: "OK");
      // DialogUtils.showOkCancelAlertDialog(
      //     context: context,
      //     message: res.response.toString(),
      //     isCancelEnable: false,
      //     okButtonTitle: Localization.of(context).ok,
      //     okButtonAction: () {
      //       Navigator.of(context).pop({ArgumentConstant.number: ""});
      //     });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              Localization.of(context).addCreateGroup,
              style: const TextStyle(
                  color: colorDarkPurple,
                  fontSize: fontSize20,
                  fontWeight: fontWeightSemiBold),
            ),
            SizedBox(height: 20),
            Form(
              key: _key,
              child: _buildEmailField(context),
            ),
            SizedBox(height: spacing20),
            Align(
              alignment: Alignment.center,
              child: HutanoButton(
                width: SizeConfig.screenWidth / 1.5,
                onPressed: _enableButton ? _addGroup : null,
                color: colorPurple,
                icon: FileConstants.icAddGroup,
                buttonType: HutanoButtonType.withPrefixIcon,
                label: Localization.of(context).addCreateGroup,
              ),
            ),
          ],
        ),
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

  Widget _buildEmailField(BuildContext context) {
    return HutanoTextField(
        width: SizeConfig.screenWidth,
        labelText: Localization.of(context).groupName,
        focusNode: _groupFocus,
        controller: _groupNameController,
        onValueChanged: (value) {
          final _validate = _key.currentState.validate();
          setState(() {
            _enableButton = _validate;
          });
        },
        validationMethod: (text) => text
            .toString()
            .isBlank(context, Localization.of(context).errorEnterGroup));
  }

  Widget _buildBottomButtons() {
    return Flexible(
      flex: 0,
      child: Row(
        children: [
          HutanoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FileConstants.icBack,
            buttonType: HutanoButtonType.onlyIcon,
          ),
          Spacer()
        ],
      ),
    );
  }
}
