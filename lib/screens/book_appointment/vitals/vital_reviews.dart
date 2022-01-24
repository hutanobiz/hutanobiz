import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class VitalReviews extends StatefulWidget {
  VitalReviews({Key key, this.args}) : super(key: key);
  dynamic args;
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
  TextEditingController _weightController = TextEditingController();
  TextEditingController _feetController = TextEditingController();
  TextEditingController _inchesController = TextEditingController();
  TextEditingController _glucoseController = TextEditingController();
  TextEditingController _bmiController = TextEditingController();
  FocusNode _glucoseFocusNode = FocusNode();
  FocusNode _dateFocusNode = FocusNode();
  FocusNode _timeFocusNode = FocusNode();
  FocusNode _sbpFocusNode = FocusNode();
  FocusNode _dbpFocusNode = FocusNode();
  FocusNode _heartRateFocusNode = FocusNode();
  FocusNode _oxygenFocusNode = FocusNode();
  FocusNode _tempFocusNode = FocusNode();
  FocusNode _feetFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();
  FocusNode _inchesFocusNode = FocusNode();
  bool isSwitchSelected = false;
  OutlineInputBorder _borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: BorderRadius.circular(15),
  );
  GlobalKey<FormState> _vitalFormKey = GlobalKey();
  InheritedContainerState _container;
  String _selectedDate = "";
  String _selectedTime = "";
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  void initState() {
    super.initState();
    _feetController.addListener(() {
      calculateBmi();
    });
    _inchesController.addListener(() {
      calculateBmi();
    });
    _weightController.addListener(() {
      calculateBmi();
    });

    if (widget.args['isEdit'] && widget.args['vitals'] != null) {
      String height = widget.args['vitals']['height'] ?? '';
      String time = widget.args['vitals']['time'] ?? '';
      _dateController.text = widget.args['vitals']['date'] != null
          ? widget.args['vitals']['date']
          : '';
      _selectedDate = widget.args['vitals']['date'] != null
          ? widget.args['vitals']['date']
          : DateFormat("MMM dd,yyyy").format(DateTime.now());
      _selectedTime = time;
      if (time.contains('PM')) {
        isSwitchSelected = false;
      } else {
        isSwitchSelected = true;
      }
      _timeController.text = time.contains(' ') ? time.split(' ')[0] : '';
      if (time == '') {
        _dateController.text =
            formattedDate(DateTime.now(), AppConstants.vitalReviewsDateFormat);
        _selectedDate = DateFormat("MM-dd-yyyy").format(DateTime.now());
        _selectedTime = DateFormat("hh:mm a").format(DateTime.now());
        _timeController.text = DateFormat("h:mm a")
            .format(DateTime.now())
            .replaceAll("PM", "")
            .replaceAll("AM", "");
        if (DateTime.now().hour >= 12) {
          isSwitchSelected = false;
        } else {
          isSwitchSelected = true;
        }
      }

      _dateController.text = widget.args['vitals'][''];

      _sbpController.text = widget.args['vitals']['bloodPressureSbp'] ?? '';
      _dbpController.text = widget.args['vitals']['bloodPressureDbp'] ?? '';
      _heartRateController.text = widget.args['vitals']['heartRate'] ?? '';
      _oxygenController.text = widget.args['vitals']['oxygenSaturation'] ?? '';
      _tempController.text = widget.args['vitals']['temperature'] ?? '';
      _weightController.text = widget.args['vitals']['weight'] ?? '';
      _feetController.text = height.contains('.') ? height.split('.')[0] : '';
      _inchesController.text = height.contains('.') ? height.split('.')[1] : '';
      _glucoseController.text = widget.args['vitals']['bloodGlucose'] ?? '';
      _bmiController.text = widget.args['vitals']['bmi'] ?? '';
    } else {
      _dateController.text = DateFormat("MM-dd-yyyy").format(DateTime.now());
      _selectedDate = DateFormat("MM-dd-yyyy").format(DateTime.now());
      _selectedTime = DateFormat("hh:mm a").format(DateTime.now());
      _timeController.text = DateFormat("h:mm a")
          .format(DateTime.now())
          .replaceAll("PM", "")
          .replaceAll("AM", "");
      if (DateTime.now().hour >= 12) {
        isSwitchSelected = false;
      } else {
        isSwitchSelected = true;
      }
    }
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
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
          title: "",
          addHeader: true,
          isLoading: isLoading,
          addBottomArrows: MediaQuery.of(context).viewInsets.bottom == 0,
          onForwardTap: () {
            _onForwardTapButton(context);
          },
          isSkipLater: !widget.args['isEdit'],
          padding: EdgeInsets.only(
              left: spacing20,
              bottom: MediaQuery.of(context).viewInsets.bottom == 0
                  ? spacing70
                  : 0),
          onSkipForTap: () {
            Provider.of<HealthConditionProvider>(context, listen: false)
                .updateVitals(Vitals());
            Navigator.pushNamed(context, Routes.bookingSummary);
            // Navigator.of(context).pushNamed(
            //   _container.projectsResponse[ArgumentConstant.serviceTypeKey]
            //               .toString() ==
            //           '3'
            //       ? Routes.onsiteAddresses
            //       : Routes.paymentMethodScreen,
            //   arguments: true,
            // );
          },
          // child: SingleChildScrollView(
          child: Form(
            key: _vitalFormKey,
            autovalidate: true,
            child: ListView(
              children: [
                _takeAnyMedicines(context),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    border: Border.all(width: 0.5, color: Colors.grey[300]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          "\u2109",
                          TextInputType.number,
                          maxLength: 5,
                          isForTemp: true),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                      border: Border.all(width: 0.5, color: Colors.grey[300]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _commonTextFormField(
                            context,
                            'Weight',
                            _weightController,
                            _weightFocusNode,
                            "",
                            'Lbs',
                            TextInputType.number),
                        _heightTextFormField(
                          context,
                          'Height',
                          _feetController,
                          _feetFocusNode,
                          'feet',
                          "Feet",
                          TextInputType.number,
                          dbpController: _inchesController,
                          dbpFocusNode: _inchesFocusNode,
                          hint: 'inches',
                        ),
                        _bmiTextFormField(context, 'My BMI', _bmiController, "",
                            "%", TextInputType.number),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                      border: Border.all(width: 0.5, color: Colors.grey[300]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _commonTextFormField(
                            context,
                            'Blood Glucose',
                            _glucoseController,
                            _glucoseFocusNode,
                            "",
                            'g/dL',
                            TextInputType.number),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            // ),
          )).onClick(onTap: () {
        FocusScope.of(context).unfocus();
      }),
    );
  }

  calculateBmi() {
    var aa = (703 * double.parse(_weightController.text)) /
        (((12 * double.parse(_feetController.text)) +
                double.parse(_inchesController.text)) *
            ((12 * double.parse(_feetController.text)) +
                double.parse(_inchesController.text)));
    _bmiController.text = aa.toStringAsFixed(1);
    //    = TextEditingController();
    // TextEditingController _feetController = TextEditingController();
    // TextEditingController _inchesController
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
          int maxLength = 3,
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
                            var dateFormat = DateFormat("hh:mm a");
                            _timeController.text = dateFormat
                                .format(tempDate)
                                .replaceAll("PM", "")
                                .replaceAll("AM", "");
                            _selectedTime = dateFormat.format(tempDate);
                            if (value.hour >= 12) {
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
                              var date = DateFormat("MM-dd-yyyy")
                                  .format(DateTime.parse(value));
                              _dateController.text = date;
                              setState(() {
                                _selectedDate = DateFormat("MM-dd-yyyy")
                                    .format(DateTime.parse(value));
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
                              var date = DateFormat("MM-dd-yyyy")
                                  .format(DateTime.parse(value));
                              _dateController.text = date;
                              setState(() {
                                _selectedDate = DateFormat("MM-dd-yyyy")
                                    .format(DateTime.parse(value));
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
                  maxLength: maxLength,
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
                    counterText: '',
                    hintText: hintLabel,
                    hintStyle: TextStyle(
                        fontSize: fontSize13, fontWeight: fontWeightMedium),
                    contentPadding: EdgeInsets.all(spacing8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: AppColors.windsor),
                    ),
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
                  maxLength: maxLength,
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
                    counterText: '',
                    hintStyle: TextStyle(
                        fontSize: fontSize13, fontWeight: fontWeightMedium),
                    contentPadding: EdgeInsets.all(spacing8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey[100]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: AppColors.windsor),
                    ),
                  ),
                ),
              ),
            SizedBox(width: spacing5),
          ],
        ),
      );

  Widget _bmiTextFormField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hintLabel,
    String rightLabel,
    TextInputType inputType,
  ) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: spacing10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize14,
                fontWeight: fontWeightSemiBold,
              ),
            ),
            SizedBox(width: spacing15),
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: TextFormField(
                controller: controller,
                keyboardType: inputType,
                maxLength: 5,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xb5000000),
                  fontSize: fontSize14,
                  fontWeight: fontWeightSemiBold,
                ),
                enabled: false,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hintLabel,
                  hintStyle: TextStyle(
                      fontSize: fontSize13, fontWeight: fontWeightMedium),
                  contentPadding: EdgeInsets.all(spacing8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.windsor),
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing15),
            _bmiController.text == ''
                ? SizedBox()
                : Image.asset('assets/images/ic_card_check.png', width: 20)
          ],
        ),
      );

  Widget _heightTextFormField(
          BuildContext context,
          String label,
          TextEditingController controller,
          FocusNode focusNode,
          String hintLabel,
          String rightLabel,
          TextInputType inputType,
          {TextEditingController dbpController,
          FocusNode dbpFocusNode,
          String hint,
          bool isFieldEnable = true,
          int maxLength = 3}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: spacing10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize14,
                fontWeight: fontWeightSemiBold,
              ),
            ),
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: TextFormField(
                controller: controller,
                keyboardType: inputType,
                maxLength: maxLength,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: Color(0xb5000000),
                  fontSize: fontSize14,
                  fontWeight: fontWeightSemiBold,
                ),
                focusNode: focusNode,
                enabled: isFieldEnable,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hintLabel,
                  hintStyle: TextStyle(
                      fontSize: fontSize13, fontWeight: fontWeightMedium),
                  contentPadding: EdgeInsets.all(spacing8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.windsor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 0),
            Text(
              rightLabel,
              style:
                  TextStyle(fontSize: fontSize13, fontWeight: fontWeightMedium),
            ),
            SizedBox(width: 0),
            Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: TextField(
                controller: dbpController,
                keyboardType: TextInputType.number,
                maxLength: maxLength,
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
                  counterText: '',
                  hintStyle: TextStyle(
                      fontSize: fontSize13, fontWeight: fontWeightMedium),
                  contentPadding: EdgeInsets.all(spacing8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey[100]),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColors.windsor),
                  ),
                ),
              ),
            ),
            Text(
              'inches',
              style:
                  TextStyle(fontSize: fontSize13, fontWeight: fontWeightMedium),
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
    // if (_dateController.text.isNotEmpty &&
    //     _timeController.text.isNotEmpty &&
    //     _sbpController.text.isNotEmpty &&
    //     _dbpController.text.isNotEmpty &&
    //     _oxygenController.text.isNotEmpty &&
    //     _tempController.text.isNotEmpty) {
    Vitals vitalsModel = Vitals(
      date: _tempController.text.isNotEmpty || _sbpController.text.isNotEmpty
          ? _selectedDate
          : null,
      time: _tempController.text.isNotEmpty || _sbpController.text.isNotEmpty
          ? _selectedTime
          : null,
      bloodPressureSbp: _sbpController.value.text != ''
          ? int.parse(_sbpController.value.text.trim())
          : null,
      bloodPressureDbp: _dbpController.value.text != ''
          ? int.parse(_dbpController.value.text.trim())
          : null,
      heartRate: _heartRateController.value.text != ''
          ? int.parse(_heartRateController.value.text.trim())
          : null,
      oxygenSaturation: _oxygenController.value.text != ''
          ? int.parse(_oxygenController.value.text.trim())
          : null,
      temperature: _tempController.value.text != ''
          ? double.parse(_tempController.value.text.trim())
          : null,
      height: _feetController.value.text != ''
          ? double.parse(_feetController.value.text.trim() +
              '.' +
              (_inchesController.value.text == ''
                  ? 0
                  : _inchesController.value.text.trim()))
          : null,
      weight: _weightController.value.text != ''
          ? double.parse(_weightController.value.text.trim())
          : null,
      bmi: _bmiController.value.text != ''
          ? double.parse(_bmiController.value.text.trim())
          : null,
      bloodGlucose: _glucoseController.value.text != ''
          ? double.parse(_glucoseController.value.text.trim())
          : null,
    );
    if (widget.args['isEdit']) {
      Map<String, dynamic> model = {};
      model['vitals'] = vitalsModel;
      model['appointmentId'] = widget.args['appointmentId'];
      setLoading(true);
      ApiManager().updateAppointmentData(model).then((value) {
        setLoading(false);
        Navigator.pop(context);
      });
    } else {
      Provider.of<HealthConditionProvider>(context, listen: false)
          .updateVitals(vitalsModel);
      Navigator.pushNamed(context, Routes.bookingSummary);
      // Navigator.of(context).pushNamed(
      //   _container.projectsResponse[ArgumentConstant.serviceTypeKey].toString() ==
      //           '3'
      //       ? Routes.onsiteAddresses
      //       : Routes.paymentMethodScreen,
      //   arguments: true,
      // );
      // } else {
      //   Widgets.showToast("Please add vital details");
      // }
    }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void _addVitalsData(BuildContext context, ReqAddVitalsModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addVital(reqModel).then(((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        Widgets.showToast(result.response);
        Navigator.pushNamed(context, Routes.bookingSummary);
        // Navigator.of(context).pushNamed(
        //   _container.projectsResponse[ArgumentConstant.serviceTypeKey]
        //               .toString() ==
        //           '3'
        //       ? Routes.onsiteAddresses
        //       : Routes.paymentMethodScreen,
        //   arguments: true,
        // );
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({@required this.min, @required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}
