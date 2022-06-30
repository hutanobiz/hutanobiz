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

class AddMoreProviderScreen extends StatefulWidget {
  final String? groupName;
  String? doctorId;
  String? doctorName;
  String? doctorAvatar;
  bool? isOnBoarding;
  final onCompleteRoute;
  AddMoreProviderScreen(
      {Key? key,
      this.isOnBoarding,
      this.doctorAvatar,
      this.doctorName,
      this.doctorId,
      this.groupName,
      this.onCompleteRoute})
      : super(key: key);
  @override
  _AddMoreProviderScreenState createState() => _AddMoreProviderScreenState();
}

class _AddMoreProviderScreenState extends State<AddMoreProviderScreen> {
  final FocusNode _groupFocus = FocusNode();
  final _groupNameController = TextEditingController();
  bool _enableButton = false;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _addMoreProviderTapped() {
    if (widget.isOnBoarding!) {
      Navigator.popUntil(
          context, ModalRoute.withName(Routes.myProviderNetwork));
    } else {
      Navigator.popUntil(context, ModalRoute.withName(Routes.homeMain));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          widget.isOnBoarding! ? AppColors.snow : AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        isAddBack: widget.isOnBoarding,
        addHeader: !widget.isOnBoarding!,
        isBackRequired: !widget.isOnBoarding!,
        title: "",
        isAddAppBar: !widget.isOnBoarding!,
        addBottomArrows: widget.isOnBoarding,
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        onForwardTap: () {
          Navigator.of(context).pushNamed(
            Routes.addProviderSuccess,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isOnBoarding! ? CustomBackButton() : SizedBox(),
            widget.isOnBoarding!
                ? AppHeader(
                    progressSteps: HutanoProgressSteps.four,
                  )
                : SizedBox(
                    height: 20,
                  ),
            _buildHeader(),
            SizedBox(height: spacing20),
            Align(
              alignment: Alignment.center,
              child: HutanoButton(
                width: SizeConfig.screenWidth! / 1.5,
                onPressed: _addMoreProviderTapped,
                color: colorPurple,
                icon: FileConstants.icAddGroup,
                buttonType: HutanoButtonType.withPrefixIcon,
                label: 'Add more provider',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctorName!,
                softWrap: true,
                maxLines: 2,
                style: const TextStyle(fontSize: fontSize16),
              ),
              Text(
                widget.groupName!,
                softWrap: true,
                maxLines: 1,
                style: const TextStyle(fontSize: fontSize16),
              ),
            ],
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
