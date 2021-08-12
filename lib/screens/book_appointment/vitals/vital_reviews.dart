import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/common_res.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/book_appointment/vitals/model/req_add_vital_model.dart';
import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/date_picker.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class VitalReviews extends StatefulWidget {
  @override
  _VitalReviewsState createState() => _VitalReviewsState();
}

class _VitalReviewsState extends State<VitalReviews> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _sbpController = TextEditingController();
  TextEditingController _dbpController = TextEditingController();
  TextEditingController _heartRateController = TextEditingController();
  TextEditingController _oxygenController = TextEditingController();
  TextEditingController _tempController = TextEditingController();
  FocusNode _dateFocusNode = FocusNode();
  FocusNode _timeFocusNode = FocusNode();
  FocusNode _sbpFocusNode = FocusNode();
  FocusNode _dbpFocusNode = FocusNode();
  FocusNode _heartRateFocusNode = FocusNode();
  FocusNode _oxygenFocusNode = FocusNode();
  FocusNode _tempFocusNode = FocusNode();
  bool isSwitchSelected = false;
  OutlineInputBorder _borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: BorderRadius.circular(15),
  );
  GlobalKey<FormState> _vitalFormKey = GlobalKey();
  InheritedContainerState _container;
  String _selectedDate = "";
  String _selectedTime = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _sbpController.dispose();
    _dbpController.dispose();
    _heartRateController.dispose();
    _oxygenController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
          title: "",
          addHeader: true,
          addBottomArrows: MediaQuery.of(context).viewInsets.bottom == 0,
          onForwardTap: () {
            _onForwardTapButton(context);
          },
          isSkipLater: true,
          padding: EdgeInsets.only(
              left: spacing20,
              bottom: MediaQuery.of(context).viewInsets.bottom == 0
                  ? spacing70
                  : 0),
          onSkipForTap: () {
            Provider.of<HealthConditionProvider>(context, listen: false)
                .updateVitals(Vitals());
            Navigator.of(context).pushNamed(
              _container.projectsResponse[ArgumentConstant.serviceTypeKey]
                          .toString() ==
                      '3'
                  ? Routes.onsiteAddresses
                  : Routes.paymentMethodScreen,
              arguments: true,
            );
          },
          child: SingleChildScrollView(
            child: Form(
              key: _vitalFormKey,
              autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _takeAnyMedicines(context),
                  _commonTextFormField(
                      context,
                      Localization.of(context).dateFieldHeader,
                      _dateController,
                      _dateFocusNode,
                      AppConstants.vitalReviewsDateFormat.toLowerCase(),
                      "",
                      TextInputType.text,
                      isFieldEnable: false,
                      isForTime: false),
                  _commonTextFormField(
                      context,
                      Localization.of(context).timeFieldHeader,
                      _timeController,
                      _timeFocusNode,
                      "",
                      "",
                      TextInputType.text,
                      isFieldEnable: false,
                      isForTime: true,
                      isAmPMVisible: true),
                  _commonTextFormField(
                      context,
                      Localization.of(context).bloodPressureFieldHeader,
                      _sbpController,
                      _sbpFocusNode,
                      Localization.of(context).sbpHint,
                      "/",
                      TextInputType.number,
                      isForBloodPressure: true,
                      dbpController: _dbpController,
                      dbpFocusNode: _dbpFocusNode,
                      hint: Localization.of(context).dbpHint),
                  _commonTextFormField(
                      context,
                      Localization.of(context).heartRateFieldHeader,
                      _heartRateController,
                      _heartRateFocusNode,
                      "",
                      Localization.of(context).beatsPerMinuteLabel,
                      TextInputType.number),
                  _commonTextFormField(
                      context,
                      Localization.of(context).oxygenFieldHeader,
                      _oxygenController,
                      _oxygenFocusNode,
                      "",
                      "%",
                      TextInputType.number),
                  _commonTextFormField(
                      context,
                      Localization.of(context).temperatureFieldHeader,
                      _tempController,
                      _tempFocusNode,
                      "",
                      "",
                      TextInputType.number,
                      isForTemp: true),
                ],
              ),
            ),
          )),
    );
  }

  Widget _takeAnyMedicines(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).takeVitalsHeader,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _commonTextFormField(
          BuildContext context,
          String label,
          TextEditingController controller,
          FocusNode focusNode,
          String hintLabel,
          String rightLabel,
          TextInputType inputType,
          {bool isForBloodPressure = false,
          TextEditingController dbpController,
          FocusNode dbpFocusNode,
          String hint,
          bool isAmPMVisible = false,
          bool isFieldEnable = true,
          bool isForTime = true,
          bool isForTemp = false}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: spacing10),
        child: Row(
          mainAxisAlignment: isForBloodPressure
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize14,
                fontWeight: fontWeightSemiBold,
              ),
            ),
            if (!isForBloodPressure) SizedBox(width: spacing15),
            InkWell(
              onTap: (!isFieldEnable)
                  ? () async {
                      if (isForTime) {
                        showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        ).then((value) {
                          if (value != null) {
                            DateTime tempDate = DateFormat("hh:mm").parse(
                                value.hour.toString() +
                                    ":" +
                                    value.minute.toString());
                            var dateFormat = DateFormat("h:mm a");
                            _timeController.text = dateFormat
                                .format(tempDate)
                                .replaceAll("PM", "")
                                .replaceAll("AM", "");
                            setState(() {
                              _selectedTime = dateFormat.format(tempDate);
                            });
                            if (int.parse(_timeController.value.text
                                    .trim()
                                    .split(':')[0]) >=
                                12) {
                              setState(() {
                                isSwitchSelected = false;
                              });
                            } else {
                              setState(() {
                                isSwitchSelected = true;
                              });
                            }
                          }
                        });
                      } else {
                        if (Platform.isAndroid) {
                          openMaterialDatePicker(
                              context, _dateController, _dateFocusNode,
                              isOnlyDate: true,
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now(), onDateChanged: (value) {
                            if (value != null) {
                              var date = formattedDate(
                                  value, AppConstants.vitalReviewsDateFormat);
                              _dateController.text = date.toString();
                              setState(() {
                                _selectedDate = formattedDate(
                                    value, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z");
                              });
                            }
                          });
                        } else {
                          openCupertinoDatePicker(
                              context, _dateController, _dateFocusNode,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              onDateChanged: (value) {
                            if (value != null) {
                              var date = formattedDate(
                                  value, AppConstants.vitalReviewsDateFormat);
                              _dateController.text = date.toString();
                              setState(() {
                                _selectedDate = formattedDate(
                                    value, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z");
                              });
                            }
                          });
                        }
                      }
                    }
                  : null,
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: TextFormField(
                  controller: controller,
                  keyboardType: inputType,
                  textAlign: TextAlign.center,
                  textInputAction:
                      isForTemp ? TextInputAction.done : TextInputAction.next,
                  style: TextStyle(
                    color: Color(0xb5000000),
                    fontSize: fontSize14,
                    fontWeight: fontWeightSemiBold,
                  ),
                  focusNode: focusNode,
                  enabled: isFieldEnable,
                  decoration: InputDecoration(
                    hintText: hintLabel,
                    hintStyle: TextStyle(
                        fontSize: fontSize13, fontWeight: fontWeightMedium),
                    contentPadding: EdgeInsets.all(spacing8),
                    enabledBorder: _borderStyle,
                    disabledBorder: _borderStyle,
                    border: _borderStyle,
                  ),
                ),
              ),
            ),
            SizedBox(width: isForBloodPressure ? 0 : spacing15),
            Text(
              rightLabel,
              style:
                  TextStyle(fontSize: fontSize13, fontWeight: fontWeightMedium),
            ),
            if (isAmPMVisible)
              Row(children: [
                _yesButtonWidget(context),
                SizedBox(width: spacing10),
                _noButtonWidget(context),
              ]),
            SizedBox(width: isForBloodPressure ? 0 : spacing15),
            if (isForBloodPressure)
              Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: TextField(
                  controller: dbpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Color(0xb5000000),
                    fontSize: fontSize14,
                    fontWeight: fontWeightSemiBold,
                  ),
                  focusNode: dbpFocusNode,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontSize: fontSize13, fontWeight: fontWeightMedium),
                    contentPadding: EdgeInsets.all(spacing8),
                    enabledBorder: _borderStyle,
                    disabledBorder: _borderStyle,
                    border: _borderStyle,
                  ),
                ),
              ),
            SizedBox(width: spacing5),
          ],
        ),
      );

  Widget _yesButtonWidget(BuildContext context) => HutanoButton(
        label: Localization.of(context).amField,
        onPressed: () {
          setState(() {
            isSwitchSelected = true;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: isSwitchSelected ? colorWhite : colorPurple100,
        color: isSwitchSelected ? colorPurple100 : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(BuildContext context) => HutanoButton(
        borderColor: colorGrey,
        label: Localization.of(context).pmField,
        onPressed: () {
          setState(() {
            isSwitchSelected = false;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: !isSwitchSelected ? colorWhite : colorPurple100,
        color: !isSwitchSelected ? colorPurple100 : colorWhite,
        borderWidth: 1,
        height: 34,
      );

  void _onForwardTapButton(BuildContext context) {
    if (_dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _sbpController.text.isNotEmpty &&
        _dbpController.text.isNotEmpty &&
        _oxygenController.text.isNotEmpty &&
        _tempController.text.isNotEmpty) {
      Vitals vitalsModel = Vitals(
          date: _selectedDate,
          time: _selectedTime,
          bloodPressureSbp: int.parse(_sbpController.value.text.trim()),
          bloodPressureDbp: int.parse(_dbpController.value.text.trim()),
          heartRate: int.parse(_heartRateController.value.text.trim()),
          oxygenSaturation: int.parse(_oxygenController.value.text.trim()),
          temperature: int.parse(_tempController.value.text.trim()));
      Provider.of<HealthConditionProvider>(context, listen: false)
          .updateVitals(vitalsModel);
      Navigator.of(context).pushNamed(
        _container.projectsResponse[ArgumentConstant.serviceTypeKey]
                    .toString() ==
                '3'
            ? Routes.onsiteAddresses
            : Routes.paymentMethodScreen,
        arguments: true,
      );
    } else {
      Widgets.showToast("Please add vital details");
    }
  }

  void _addVitalsData(BuildContext context, ReqAddVitalsModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addVital(reqModel).then(((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        Widgets.showToast(result.response);
        Navigator.of(context).pushNamed(
          _container.projectsResponse[ArgumentConstant.serviceTypeKey]
                      .toString() ==
                  '3'
              ? Routes.onsiteAddresses
              : Routes.paymentMethodScreen,
          arguments: true,
        );
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
