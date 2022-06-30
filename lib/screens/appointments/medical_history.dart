import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/model/res_disease_model.dart';
import 'package:hutano/screens/appointments/model/req_add_disease_model.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/appointments/model/res_medical_documents_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/medical_history/provider/appoinment_provider.dart';

import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/month_year_item.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MedicalHistoryScreen extends StatefulWidget {
  MedicalHistoryScreen({Key? key, this.args}) : super(key: key);

  final dynamic args;
  // final bool isFromTreat;

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  ApiBaseHelper api = ApiBaseHelper();
  List<MedicalHistory>? _showDiseaseData = [];
  List<Disease>? _newDiseaseList = [];
  bool isBottomButtonsShow = true;
  bool isFromAppointment = false;
  String? token = '';
  bool _isLoading = false;
  final _searchDiseaseController = TextEditingController();
  final _searchDiseaseFocusNode = FocusNode();
  late InheritedContainerState _container;
  String? _selectedDisease = "";
  String? _selectedSid = "";
  bool isIndicatorLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.args['isEdit']) {
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
      });
      if (widget.args['medicalHistory'] != null &&
          widget.args['medicalHistory'].length > 0) {
        for (dynamic aa in widget.args['medicalHistory']) {
          _showDiseaseData!.add(MedicalHistory.fromJson(aa));
        }
      }
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        SharedPref().getToken().then((token) {
          setState(() {
            this.token = token;
          });
          _getMyDiseaseList();
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _container = InheritedContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          isBottomButtonsShow ? AppColors.goldenTainoi : Colors.white,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: isBottomButtonsShow,
        addTitle: !isBottomButtonsShow,
        isAddBack: false,
        addBackButton: false,
        isLoading: _isLoading,
        addBottomArrows: isBottomButtonsShow,
        onForwardTap: saveMedicalHistory,
        color: Colors.white,
        isAddAppBar: isBottomButtonsShow,
        padding: const EdgeInsets.all(spacing5),
        child: Column(
          children: <Widget>[
            if (!isFromAppointment) _medicalHistoryHeader(context),
            if (!isFromAppointment) _buildSearchPastConditions(context),
            _currentDiseaseList(context),
          ],
        ),
      ),
    );
  }

  Widget _medicalHistoryHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.all(spacing10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            Localization.of(context)!.medicalHistoryLabel,
            style: const TextStyle(
                color: colorDarkBlack,
                fontWeight: fontWeightBold,
                fontSize: fontSize16),
          ),
        ),
      );

  Widget _buildSearchPastConditions(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: _searchDiseaseController,
              focusNode: _searchDiseaseFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onTap: () {},
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(spacing8),
                        child: Image.asset(FileConstants.icSearchBlack,
                            color: colorBlack2, width: 20, height: 20))),
                hintText: Localization.of(context)!.enterPastConditionHint,
                isDense: true,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              )),
          suggestionsCallback: (pattern) async {
            return await _getDiseasesList(pattern);
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, dynamic suggestion) {
            return ListTile(
              title: Text(suggestion.name ?? ''),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (dynamic suggestion) {
            setState(() {
              _selectedDisease = suggestion.name;
              _selectedSid = suggestion.sId;
            });
            showAddDiseaseDialog(context, false);
            _searchDiseaseController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  Widget _currentDiseaseList(BuildContext context) => isIndicatorLoading
      ? Expanded(
          child: Center(
            child: CustomLoader(),
          ),
        )
      : _showDiseaseData == null ||
              (_showDiseaseData == null || _showDiseaseData!.isEmpty) &&
                  !isIndicatorLoading
          ? Expanded(
              child: Center(
                child: Text(
                  Localization.of(context)!.noMedicalHistoryFound,
                  style: TextStyle(
                      fontSize: 16,
                      color: colorBlack2,
                      fontWeight: fontWeightSemiBold),
                ),
              ),
            )
          : Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    spacing20, spacing8, spacing20, spacing8),
                child: ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    ListView.builder(
                        padding: EdgeInsets.only(
                            bottom: (_showDiseaseData!.contains('Others') ||
                                    _showDiseaseData!.contains('Other'))
                                ? 10
                                : 65),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: _showDiseaseData!.length,
                        itemBuilder: (context, index) {
                          return PopupMenuButton(
                            offset: Offset(300, 50),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              if (!isFromAppointment)
                                _popMenuCommonItem(
                                    context,
                                    Localization.of(context)!.edit,
                                    FileConstants.icEdit) as PopupMenuEntry<String>,
                              if (!isFromAppointment)
                                _popMenuCommonItem(
                                    context,
                                    Localization.of(context)!.remove,
                                    FileConstants.icRemoveBlack) as PopupMenuEntry<String>
                            ],
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                _showDiseaseData![index].name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                  "${_showDiseaseData![index].month} ${_showDiseaseData![index].year}"),
                              trailing: Icon(Icons.more_vert),
                            ),
                            onSelected: (dynamic value) {
                              if (value == Localization.of(context)!.edit) {
                                setState(() {
                                  _selectedDisease =
                                      _showDiseaseData![index].name;
                                  _selectedSid = _showDiseaseData![index].sId;
                                });
                                showAddDiseaseDialog(context, true,
                                    medical: _showDiseaseData![index]);
                              } else {
                                Widgets.showConfirmationDialog(
                                  context: context,
                                  description:
                                      "Are you sure to delete this medical history?",
                                  onLeftPressed: () => _removeDisease(
                                      context, _showDiseaseData![index]),
                                );
                                // _removeDisease(
                                //     context, _showDiseaseData[index]);
                              }
                            },
                          );
                        })
                  ],
                ),
              ),
            );

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

  showAddDiseaseDialog(BuildContext context, bool isForUpdate,
      {MedicalHistory? medical}) {
    var addDiseaseDialog = YYDialog();
    addDiseaseDialog.build(context)
      ..width = (MediaQuery.of(context).size.width - 35)
      ..backgroundColor = Colors.transparent
      ..barrierDismissible = false
      ..widget(
        MonthYearItem(
          selectedSid: _selectedSid,
          selectedDisease: _selectedDisease,
          yyDialog: addDiseaseDialog,
          onSavePressed: _onSavePressed,
          isForUpdate: isForUpdate,
          month: medical?.month ?? "",
          year: medical?.year?.toString() ?? "",
        ),
      )
      ..show();
  }

  void _onSavePressed(
      String sId, String disease, String month, int year, bool isForUpdate) {
    _addMedicalData(
        ReqAddDiseaseModel(
            medicalHistoryId: sId,
            sId: sId,
            name: disease,
            year: year.toString(),
            month: month),
        isForUpdate);
  }

  void _removeDisease(BuildContext context, MedicalHistory medicalHistory) {
    setLoading(true);
    api.deletePatientMedicalHistory(token, medicalHistory.sId).then((value) {
      setLoading(false);
      setState(() {
        if (_showDiseaseData!.contains(medicalHistory)) {
          _showDiseaseData!.remove(medicalHistory);
        }
      });
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
  }

  void saveMedicalHistory() {
    if (widget.args['isEdit']) {
      List<BookedMedicalHistory> _listOfHistory = [];

      if (_showDiseaseData != null && _showDiseaseData!.length > 0) {
        _showDiseaseData!.forEach((element) {
          _listOfHistory.add(BookedMedicalHistory(
              name: element.name,
              year: int.parse(element.year!),
              month: element.month));
        });
      }
      Map<String, dynamic> model = {};
      model['medicalHistory'] = _listOfHistory;
      model['appointmentId'] = widget.args['appointmentId'];
      setLoading(true);
      ApiManager().updateAppointmentData(model).then((value) {
        setLoading(false);
        Navigator.pop(context);
      });
    } else {
      if (_showDiseaseData != null) {
        if (_showDiseaseData!.length > 0) {
          final _gender = getInt(PreferenceKey.gender);
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .setBodyType(_gender);
          List<BookedMedicalHistory> _listOfHistory = [];
          if (isBottomButtonsShow) {
            if (_showDiseaseData != null && _showDiseaseData!.length > 0) {
              _showDiseaseData!.forEach((element) {
                _container.setConsentToTreatData(
                    "medicalHistory", element.name);
                _listOfHistory.add(BookedMedicalHistory(
                    name: element.name,
                    year: int.parse(element.year!),
                    month: element.month));
              });
            }
            Provider.of<HealthConditionProvider>(context, listen: false)
                .updateMedicalHistory(_listOfHistory);
            Navigator.of(context).pushNamed(Routes.routeWelcomeNewFollowup);
            // Navigator.of(context).pushNamed(Routes.routeMoreCondition);
          }
        } else {
          Provider.of<HealthConditionProvider>(context, listen: false)
              .updateMedicalHistory([]);
          Navigator.of(context).pushNamed(Routes.routeWelcomeNewFollowup);
          // Navigator.of(context).pushNamed(Routes.routeMoreCondition);
        }
      } else {
        Provider.of<HealthConditionProvider>(context, listen: false)
            .updateMedicalHistory([]);
        Navigator.of(context).pushNamed(Routes.routeWelcomeNewFollowup);
        // Navigator.of(context).pushNamed(Routes.routeMoreCondition);
      }
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  Future<List<Disease>> _getDiseasesList(String pattern) async {
    return await ApiManager().searchDisease(pattern);
  }

  _getMyDiseaseList() async {
    setState(() {
      isIndicatorLoading = true;
    });
    await ApiManager().getMyDisease().then((result) {
      if (result is ResMedicalDocumentsModel) {
        setLoading(false);
        setState(() {
          isIndicatorLoading = false;
        });
        if (result.response!.medicalHistory != null) {
          setState(() {
            _showDiseaseData = result.response!.medicalHistory;
          });
        }
        _getDiseaseList();
      }
    }).catchError((dynamic e) {
      setState(() {
        isIndicatorLoading = false;
      });
      if (e is ErrorModel) {
        setLoading(false);
        e.toString().debugLog();
      }
    });
  }

  _getDiseaseList() async {
    try {
      var res = await ApiManager().getNewDisease();
      setState(() {
        _newDiseaseList = res.response;
      });
      for (dynamic disease in _newDiseaseList!) {
        if (disease.name == "Other") {
          _newDiseaseList!.remove(disease);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _addMedicalData(
      ReqAddDiseaseModel reqAddDiseaseModel, bool isForUpdate) async {
    setLoading(true);
    try {
      if (isForUpdate) {
        await ApiManager()
            .updatePatientDisease(reqAddDiseaseModel)
            .then(((result) {
          int indexToUpdate = _showDiseaseData!
              .indexWhere((disease) => disease.sId == reqAddDiseaseModel.sId);
          _showDiseaseData![indexToUpdate] = MedicalHistory(
              name: reqAddDiseaseModel.name,
              year: reqAddDiseaseModel.year,
              month: reqAddDiseaseModel.month,
              sId: reqAddDiseaseModel.sId);
          setLoading(false);
        }));
      } else {
        await ApiManager()
            .addPatientDisease(reqAddDiseaseModel)
            .then(((result) {
          _showDiseaseData!.add(MedicalHistory.fromJson(
              result['response']['medicalHistory'].last));
          setLoading(false);
        }));
      }
    } catch (e) {
      setLoading(false);
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  void _getUpdatedDiseaseData() async {
    await ApiManager().getMyDisease().then((result) {
      if (result is ResMedicalDocumentsModel) {
        if (result.response!.medicalHistory != null) {
          setState(() {
            _showDiseaseData = result.response!.medicalHistory;
          });
        }
        setLoading(false);
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        setLoading(false);
        e.toString().debugLog();
      }
    });
  }
}
