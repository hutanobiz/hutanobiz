import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/medical_history/model/medicine_time_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class EffectAbilityScreen extends StatefulWidget {
  @override
  _EffectAbilityScreenState createState() => _EffectAbilityScreenState();
}

class _EffectAbilityScreenState extends State<EffectAbilityScreen> {
  List<MedicineTimeModel> _activityList = [];
  int? radioVal = 1;
  String _dailyActivity = "1";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _activityList.add(MedicineTimeModel(
          Localization.of(context)!.dayToDayActivity, false, 1));
      _activityList.add(MedicineTimeModel(
          Localization.of(context)!.difficultActivity, false, 2));
      _activityList.add(MedicineTimeModel(
          Localization.of(context)!.impossibleActivity, false, 3));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: false,
      body: LoadingBackgroundNew(
          title: "",
          addHeader: true,
          addBottomArrows: true,
          onForwardTap: () {
            // Problems model =
            //     Provider.of<HealthConditionProvider>(context, listen: false)
            //         .boneAndMuscleData;
            // model.dailyActivity = radioVal.toString();
            // Provider.of<HealthConditionProvider>(context, listen: false)
            //     .updateBoneAndMuscleData(model);
            // Navigator.pushNamed(context, routeConditionTimeScreen, arguments: {
            //   ArgumentConstant.isForProblemKey: true,
            // });
          },
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_headerView(context), _activityEffectList(context)],
          ))),
    );
  }

  Widget _headerView(BuildContext context) => Padding(
        padding:
            EdgeInsets.symmetric(vertical: spacing20, horizontal: spacing20),
        child: Text(
          Localization.of(context)!.conditionAffectedHeader,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _activityEffectList(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacing20),
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: spacing15);
            },
            itemCount: _activityList.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _activityList[index].timeLabel,
                      style: TextStyle(
                          fontWeight: fontWeightRegular,
                          fontSize: fontSize14,
                          color: colorBlack2),
                    ),
                  ),
                  Radio(
                      activeColor: AppColors.windsor,
                      groupValue: radioVal,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _activityList[index].index,
                      onChanged: (dynamic val) {
                        setState(() {
                          radioVal = val;
                        });
                        _activityList.forEach((element) {
                          if (element.index == radioVal) {
                            _activityList[index].isSelected = true;
                          } else {
                            _activityList[index].isSelected = false;
                          }
                        });
                      }),
                ],
              );
            }),
      );
}
