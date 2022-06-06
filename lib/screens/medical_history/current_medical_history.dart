import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/common_res.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/medical_history/model/req_add_current_medical_history.dart';
import 'package:hutano/screens/medical_history/model/res_body_part_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

import 'model/medical_time_model.dart';

class CurrentMedicalHistory extends StatefulWidget {
  @override
  _CurrentMedicalHistoryState createState() => _CurrentMedicalHistoryState();
}

class _CurrentMedicalHistoryState extends State<CurrentMedicalHistory> {
  FocusNode _reviewFocus = FocusNode();
  TextEditingController _reviewController = TextEditingController();
  GlobalKey silderKey = GlobalKey();
  double _painIntensity = 0;
  List<MedicalTimeModel> _medicalTimeList = [];
  TextEditingController _searchBodyPartController = TextEditingController();
  FocusNode _searchBodyPartFocusNode = FocusNode();
  List<BodyPart> _bodyPartList = [];
  List<String> _selectedBodyPartList = [];
  String _selectedProblemTime = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _medicalTimeList.add(MedicalTimeModel("Hours", false));
      _medicalTimeList.add(MedicalTimeModel("Days", false));
      _medicalTimeList.add(MedicalTimeModel("Weeks", false));
      _medicalTimeList.add(MedicalTimeModel("Months", false));
      _medicalTimeList.add(MedicalTimeModel("Years", false));
      _getBodyPartData(context);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: false,
      body: LoadingBackgroundNew(
          title: "",
          addHeader: true,
          padding: EdgeInsets.only(
              left: spacing20, right: spacing20, bottom: spacing70),
          addBottomArrows: true,
          onForwardTap: () {
            if (_reviewController.text.isNotEmpty &&
                _selectedBodyPartList.isNotEmpty &&
                _selectedProblemTime.isNotEmpty) {
              final reqCurrentMedicalHistory = ReqAddCurrentMedicalHistory(
                  description: _reviewController.value.text.trim(),
                  chiefComplaint: _selectedBodyPartList,
                  problem: _selectedProblemTime,
                  rateDiscomfort: _painIntensity.toString());
              debugPrint("HELLO ${reqCurrentMedicalHistory.toJson()}");
              _addCurrentMedicalHistory(context, reqCurrentMedicalHistory);
            } else {
              Widgets.showToast(Localization.of(context).fillEmptyFields);
            }
          },
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reusableHeader(context,
                  Localization.of(context).currentMedicalHistoryHeader),
              _tellUsAboutSeekingCareWidget(context),
              _reusableHeader(
                  context, Localization.of(context).chiefComplaintHeader),
              _searchBodyPart(context),
              _selectedBodyPartListView(context),
              _reusableHeader(context, Localization.of(context).howLongHeader),
              _horizontalTimeListView(context),
              _reusableHeader(
                  context, Localization.of(context).rateYourDiscomfort),
              _rateDiscomfort(context)
            ],
          ))),
    );
  }

  Widget _reusableHeader(BuildContext context, String label) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing15),
        child: Text(
          label,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _tellUsAboutSeekingCareWidget(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: spacing5),
        child: HutanoTextField(
          labelTextStyle: TextStyle(fontSize: fontSize14, color: colorGrey60),
          focusNode: _reviewFocus,
          controller: _reviewController,
          focusedBorderColor: colorBlack20,
          labelText: Localization.of(context).tellUsAboutCare,
          textInputType: TextInputType.text,
          maxLines: 3,
          onFieldSubmitted: (s) {},
          onFieldTap: () {},
          textInputAction: TextInputAction.done,
          onValueChanged: (value) {},
        ),
      );

  Widget _searchBodyPart(BuildContext context) => TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _searchBodyPartController,
            focusNode: _searchBodyPartFocusNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            onTap: () {},
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: Localization.of(context).bodyPartHint,
              isDense: true,
              hintStyle: TextStyle(
                  color: colorBlack2,
                  fontSize: fontSize13,
                  fontWeight: fontWeightRegular),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
            )),
        suggestionsCallback: (pattern) async {
          return pattern.length > 0 ? await _getFilteredBodyPartList() : [];
        },
        keepSuggestionsOnLoading: false,
        loadingBuilder: (context) => CustomLoader(),
        errorBuilder: (_, object) {
          return Container();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              suggestion.name,
              style:
                  TextStyle(fontSize: fontSize14, fontWeight: fontWeightMedium),
            ),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _searchBodyPartController.text = "";
          setState(() {
            _selectedBodyPartList.add(suggestion.name);
          });
        },
        hideOnError: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
      );

  _getFilteredBodyPartList() {
    return _bodyPartList.where((element) => element.name
        .toLowerCase()
        .contains(_searchBodyPartController.text.toLowerCase()));
  }

  Widget _selectedBodyPartListView(BuildContext context) =>
      _selectedBodyPartList.isNotEmpty
          ? Container(
              height: _selectedBodyPartList.length > 1 ? 100 : 50,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _selectedBodyPartList.length,
                  itemBuilder: (context, index) {
                    return PopupMenuButton(
                      offset: Offset(300, 50),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        _popMenuCommonItem(
                            context,
                            Localization.of(context).edit,
                            FileConstants.icEdit),
                        _popMenuCommonItem(
                            context,
                            Localization.of(context).remove,
                            FileConstants.icRemoveBlack)
                      ],
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          _selectedBodyPartList[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.more_vert),
                      ),
                      onSelected: (value) {
                        if (value == Localization.of(context).remove) {
                          setState(() {
                            _selectedBodyPartList
                                .remove(_selectedBodyPartList[index]);
                          });
                        }
                      },
                    );
                  }),
            )
          : SizedBox();

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
        value: value,
        textStyle: const TextStyle(
            color: colorBlack2,
            fontWeight: fontWeightRegular,
            fontSize: spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: spacing5,
            ),
            Text(value)
          ],
        ),
      );

  Widget _horizontalTimeListView(BuildContext context) => Container(
        height: 40,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(width: spacing30);
          },
          itemCount: _medicalTimeList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 0.5, color: Colors.grey)),
                alignment: Alignment.center,
                child: Text(
                  _medicalTimeList[index].medicalTime,
                  style: TextStyle(
                      fontSize: fontSize12,
                      fontWeight: fontWeightRegular,
                      color: _medicalTimeList[index].isSelected
                          ? AppColors.goldenTainoi
                          : Colors.black),
                )).onClick(onTap: () {
              _selectedProblemTime = _medicalTimeList[index].medicalTime;
              setState(() {
                _medicalTimeList[index].isSelected =
                    !_medicalTimeList[index].isSelected;
              });
            });
          },
        ),
      );

  Widget _rateDiscomfort(BuildContext context) => Slider(
        value: _painIntensity,
        max: 10,
        min: 0,
        divisions: 10,
        onChanged: (lowerValue) {
          setState(() {
            _painIntensity = lowerValue;
          });
        },
        activeColor: AppColors.goldenTainoi,
        // trackBar: FlutterSliderTrackBar(
        //   activeTrackBarHeight: 18,
        //   inactiveTrackBarHeight: 18,
        //   activeTrackBar: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //       color: AppColors.sunglow,
        //       gradient: LinearGradient(
        //           colors: [Color(0xffFFE18D), Color(0xffFFC700)])),
        //   inactiveTrackBar: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     color: colorGreyBackground,
        //   ),
        // ),
        // handler: FlutterSliderHandler(
        //   decoration: BoxDecoration(),
        //   child: Container(
        //     child: Container(
        //       key: silderKey,
        //       height: 18,
        //       width: 18,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         border: Border.all(color: accentColor),
        //         borderRadius: BorderRadius.circular(10),
        //         boxShadow: [
        //           BoxShadow(
        //             color: accentColor.withOpacity(0.4),
        //             blurRadius: 5,
        //             offset: Offset(0, 2),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // tooltip: FlutterSliderTooltip(
        //   custom: (value) {
        //     return _buildButton(value);
        //   },
        //   boxStyle: FlutterSliderTooltipBox(),
        //   direction: FlutterSliderTooltipDirection.top,
        //   alwaysShowTooltip: true,
        // ),
        // rangeSlider: false,
      );

  Widget _buildButton(double value) => InkWell(
        child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(
            _getTextValue(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xffFFC259),
                fontWeight: fontWeightMedium,
                fontSize: fontSize10),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: colorBlack2),
        ),
      );

  String _getTextValue(double value) {
    if (value >= 0.0 && value < 4) {
      return "Low";
    } else if (value >= 4 && value < 8) {
      return "Medium";
    } else {
      return "High";
    }
  }

  void _addCurrentMedicalHistory(
      BuildContext context, ReqAddCurrentMedicalHistory reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addCurrentMedicalHistory(reqModel).then(((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        Widgets.showToast(result.response);
        Navigator.of(context).pushNamed(Routes.routeTestDiagnosis);
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  void _getBodyPartData(BuildContext context) async {
    await ApiManager().getBodyPart().then((result) {
      if (result is ResBodyPartModel) {
        setState(() {
          _bodyPartList = result.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
