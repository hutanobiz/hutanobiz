import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/medical_history/model/req_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:provider/provider.dart';

class AddMedicationBottomSheet extends StatefulWidget {
  AddMedicationBottomSheet(
      {Key key,
      this.user,
      this.appointment,
      this.status,
      this.id,
      this.current})
      : super(key: key);
  String user, appointment, status, id;
  Data current;

  @override
  State<AddMedicationBottomSheet> createState() => _AddMedicationBottomState();
}

class _AddMedicationBottomState extends State<AddMedicationBottomSheet> {
  dynamic currentPrescriptions;
  bool isLoading = false;
  ApiBaseHelper api = ApiBaseHelper();
  String selectedDose;
  String selectedFrequency;
  List<String> doses = [
    "Once a day",
    "Twice a Day",
    "Three times a day",
    "Four times a day",
    "As needed (PRN)"
  ];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.current != null) {
      isLoading = true;
      searchPrescription(widget.current.name).then((value) {
        currentPrescriptions = value[0];
        try {
          selectedDose = widget.current.dose;
          selectedFrequency = widget.current.frequency;
        } catch (e) {}

        setLoading(false);
      });
    }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height - 100,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              Text(
                  widget.status == '0'
                      ? "Add medication"
                      : widget.status == '1'
                          ? "Review"
                          : "Discontinue",
                  style: AppTextStyle.boldStyle(fontSize: 18)),
              widget.status == '0'
                  ? Container(
                      padding: const EdgeInsets.only(top: spacing2),
                      height: 40,
                      decoration: BoxDecoration(
                          color: colorBlack2.withOpacity(0.06),
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            controller: searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.mineShaft.withOpacity(0.06),
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Search Prescription',
                              prefixIconConstraints: BoxConstraints(),
                              prefixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                      padding: const EdgeInsets.all(spacing8),
                                      child: Image.asset(
                                          FileConstants.icSearchBlack,
                                          color: colorBlack2,
                                          width: 20,
                                          height: 20))),
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
                        keepSuggestionsOnLoading: false,
                        loadingBuilder: (context) =>
                            Center(child: CircularLoader()),
                        suggestionsCallback: (pattern) async {
                          return pattern.length > 0
                              ? await searchPrescription(pattern)
                              : [];
                        },
                        noItemsFoundBuilder: (_) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Text(
                              "No Items Found",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion['name']),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          searchController.text = '';
                          currentPrescriptions = suggestion;
                          setState(() {});
                        },
                      ))
                  : SizedBox(),
              currentPrescriptions == null
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.status == '0'
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      currentPrescriptions['name'],
                                      style: AppTextStyle.semiBoldStyle(
                                          fontSize: 16),
                                    )),
                                    PopupMenuButton<String>(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      iconSize: 17,
                                      onSelected: (val) {
                                        removeCurrentPrescription();
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return {'Remove'}.map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  choice,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ],
                                )
                              : Text(
                                  '${currentPrescriptions['name']} ${widget.current.dose} ${widget.current.frequency}'),
                          widget.status == '2'
                              ? SizedBox()
                              : SizedBox(height: 10),
                          widget.status == '2'
                              ? SizedBox()
                              : Text(
                                  'Dose',
                                  style: AppTextStyle.mediumStyle(fontSize: 14),
                                ),
                          widget.status == '2'
                              ? SizedBox()
                              : SizedBox(height: 10),
                          widget.status == '2'
                              ? SizedBox()
                              : Container(
                                  height: 44,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(width: 10),
                                    itemCount:
                                        currentPrescriptions['dose'].length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDose =
                                                currentPrescriptions['dose']
                                                    [index];
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: selectedDose ==
                                                    currentPrescriptions['dose']
                                                        [index]
                                                ? AppColors.windsor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: AppColors.windsor),
                                          ),
                                          child: Center(
                                            child: Text(
                                                currentPrescriptions['dose']
                                                    [index],
                                                style:
                                                    AppTextStyle.regularStyle(
                                                  fontSize: 12,
                                                  color: selectedDose ==
                                                          currentPrescriptions[
                                                              'dose'][index]
                                                      ? Colors.white
                                                      : AppColors.windsor,
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          widget.status == '2'
                              ? SizedBox()
                              : SizedBox(height: 30),
                          widget.status == '2'
                              ? SizedBox()
                              : Text(
                                  'Frequency',
                                  style: AppTextStyle.mediumStyle(fontSize: 14),
                                ),
                          widget.status == '2'
                              ? SizedBox()
                              : SizedBox(height: 10),
                          widget.status == '2'
                              ? SizedBox()
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 20),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: doses.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          doses[index],
                                          style: AppTextStyle.regularStyle(
                                              fontSize: 12),
                                        )),
                                        Radio(
                                            value: doses[index],
                                            groupValue: selectedFrequency,
                                            activeColor: AppColors.windsor,
                                            onChanged: (val) {
                                              setState(() {
                                                selectedFrequency = val;
                                              });
                                            })
                                      ],
                                    );
                                  },
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          FancyButton(
                              buttonColor: AppColors.windsor,
                              buttonHeight: 55,
                              title: widget.status == '0'
                                  ? "Add medication"
                                  : widget.status == '1'
                                      ? "Review medication"
                                      : "Discontinue medication",
                              onPressed: () {
                                if (widget.status == '0' &&
                                    (selectedDose == null ||
                                        selectedFrequency == null)) {
                                  Widgets.showToast("Please select all fields");
                                } else {
                                  final reqModel = ReqMedicationDetail(
                                      dose: selectedDose,
                                      name: currentPrescriptions['name'],
                                      frequency: selectedFrequency,
                                      prescriptionId:
                                          currentPrescriptions['_id']);
                                  _addMedicationDetailData(context, reqModel);
                                }
                              })
                        ],
                      ),
                    ),
            ],
          ),
          isLoading
              ? Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: CircularLoader(),
                )
              : Container(),
        ],
      ),
    );
  }

  void _addMedicationDetailData(
      BuildContext context, ReqMedicationDetail reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addMedicationDetail(reqModel).then(((result) {
      Provider.of<HealthConditionProvider>(context, listen: false)
          .setMedicineDetails(medicine: reqModel);
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.pop(context, true);
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  Future<List<dynamic>> searchPrescription(String pattern) async {
    return await ApiManager().searchMedicine(pattern);
  }

  void removeCurrentPrescription() {
    setState(() {
      selectedFrequency = null;
      selectedDose = null;
      currentPrescriptions = null;
    });
  }
}
