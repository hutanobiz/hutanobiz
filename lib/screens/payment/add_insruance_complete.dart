import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/payment/res_insurance_list.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
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
  ApiBaseHelper api = ApiBaseHelper();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMyInsurance();
    });
  }

  _getMyInsurance() {
    SharedPref().getToken().then((token) {
      setState(() {
        ProgressDialogUtils.showProgressDialog(context);
        api.getPatientInsurance(context, token).then((value) {
          if (value.status == 'success') {
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
      });
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
                    progressSteps: HutanoProgressSteps.two,
                    title: Strings.labelInsuranceOptions,
                    subTitle: Strings.labelInsuranceAdded,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundSuccess(),
                  SizedBox(
                    height: 50,
                  ),
                  TextWithImage(
                      size: 30,
                      imageSpacing: 13,
                      textStyle: TextStyle(
                          color: AppColors.colorBlack2,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      label: Strings.insurance,
                      image: FileConstants.icInsuranceBlue),
                  SizedBox(
                    height: 10,
                  ),
                  _buildInsuanrceList(),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: HutanoButton(
                      width: 55,
                      height: 55,
                      color: AppColors.accentColor,
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
                    SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            insuranceList[index].title,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorBlack,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 30,
                      color: AppColors.colorLightGrey.withOpacity(0.2),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
}
