import 'package:flutter/material.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/add_insurance/add_insruance.dart';
import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/placeholder_image.dart';
import 'package:hutano/widgets/round_success.dart';
import 'package:hutano/widgets/text_with_image.dart';

class AddInsuranceComplete extends StatefulWidget {
  @override
  _AddInsuranceCompleteState createState() => _AddInsuranceCompleteState();
}

class _AddInsuranceCompleteState extends State<AddInsuranceComplete> {
  List<Insurance> insuranceList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMyInsurance();
    });
  }

  _getMyInsurance() {
    ProgressDialogUtils.showProgressDialog(context);
    ApiManager().getPatientInsurance().then((value) {
      if (value.status == success) {
        ProgressDialogUtils.dismissProgressDialog();
        setState(() {
          insuranceList = value.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        if (e.response != null) {
          ProgressDialogUtils.dismissProgressDialog();
          DialogUtils.showAlertDialog(context, e.response);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(children: [
                  AppHeader(
                    title: Localization.of(context).labelInsuranceOptions,
                    subTitle: Localization.of(context).labelInsuranceAdded,
                  ),
                  SizedBox(
                    height: spacing40,
                  ),
                  RoundSuccess(),
                  SizedBox(
                    height: spacing50,
                  ),
                  TextWithImage(
                      size: spacing30,
                      imageSpacing: 13,
                      textStyle: TextStyle(
                          color: colorBlack2,
                          fontWeight: FontWeight.w700,
                          fontFamily: gilroyBold,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      label: Localization.of(context).insurance,
                      image: FileConstants.icInsuranceBlue),
                  SizedBox(
                    height: spacing10,
                  ),
                  _buildInsuanrceList(),
                  SizedBox(
                    height: spacing20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.addInsurance,
                          arguments: {
                            ArgumentConstant.argsinsuranceType:
                                InsuranceType.secondary
                          });
                    },
                    child: Text(
                        Localization.of(context)
                            .addSecondaryInsurance
                            .toUpperCase(),
                        style: const TextStyle(
                            color: colorPurple100,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: HutanoButton(
                      width: 55,
                      height: 55,
                      color: accentColor,
                      iconSize: 20,
                      buttonType: HutanoButtonType.onlyIcon,
                      icon: FileConstants.icForward,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.welcome);
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

  Widget _buildInsuanrceList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: insuranceList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PlaceHolderImage(
                        width: 60,
                        height: 60,
                        image: insuranceList[index].image ?? ' ',
                        placeholder: FileConstants.icDoctorSpecialist,
                      ),
                    ),
                    SizedBox(width: spacing25),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            insuranceList[index].title,
                            style: TextStyle(
                              fontSize: fontSize14,
                              color: colorBlack,
                              fontWeight: FontWeight.w600,
                              fontFamily: gilroySemiBold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: spacing5),
                padding: EdgeInsets.all(spacing15),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 30,
                      color: colorLightGrey.withOpacity(0.2),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
}
