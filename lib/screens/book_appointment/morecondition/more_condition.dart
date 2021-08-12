import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/res_condition_type.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/res_more_condition_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/selection_health_issue_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class MoreCondition extends StatefulWidget {
  @override
  _MoreConditionState createState() => _MoreConditionState();
}

class _MoreConditionState extends State<MoreCondition> {
  List<HealthCondition> _tempConditionList = [];
  final _searchConditionController = TextEditingController();
  final _searchConditionFocusNode = FocusNode();
  List<HealthCondition> _conditionList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getAllHealthConditions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: WillPopScope(
            onWillPop: _resetAction,
            child: LoadingBackgroundNew(
                title: "",
                addHeader: true,
                padding: EdgeInsets.zero,
                addBottomArrows: true,
                onUpperBackTap: () {
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .updateCurrentIndex(0);
                  Navigator.pop(context);
                },
                onForwardTap: () {
                  _onForwardTap(context);
                },
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          color: AppColors.goldenTainoi,
                          width: screenSize.width,
                          padding: EdgeInsets.only(left: spacing15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Localization.of(context).tellUsAboutMore,
                                    style: TextStyle(
                                        fontSize: fontSize20,
                                        fontWeight: fontWeightBold,
                                        color: Color(0xff0E1C2A))),
                                Text(Localization.of(context).aboutMore,
                                    style: TextStyle(
                                        fontSize: fontSize20,
                                        fontWeight: fontWeightBold,
                                        color: Color(0xff0E1C2A))),
                                Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: spacing15,
                                        right: spacing15,
                                        bottom: spacing15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                        textInputAction:
                                            TextInputAction.newline,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        maxLines: 1,
                                        minLines: 1,
                                        controller: _searchConditionController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: Localization.of(context)
                                                .searchForProblem,
                                            hintStyle: TextStyle(
                                                fontSize: fontSize14,
                                                fontWeight: fontWeightRegular),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            prefixIcon: Padding(
                                                padding: const EdgeInsets.all(
                                                    spacing8),
                                                child: Image.asset(
                                                    FileConstants.icSearchBlack,
                                                    color: colorBlack2,
                                                    width: 20,
                                                    height: 20))),
                                        focusNode: _searchConditionFocusNode,
                                        onChanged: (value) {
                                          _getConditionList(value, context);
                                        }))
                              ])),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing10),
                          child: GridView.builder(
                              itemCount: _conditionList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return _columnCommonItem(
                                  context,
                                  _conditionList[index].name,
                                  _conditionList[index].subName,
                                  _conditionList[index].image,
                                  index,
                                  _conditionList[index].isSelected,
                                );
                              }))
                    ])))));
  }

  Future<bool> _resetAction() async {
    Provider.of<HealthConditionProvider>(context, listen: false)
        .decrementCurrentIndex();
    Navigator.pop(context);
    return true;
  }

  Widget _columnCommonItem(BuildContext context, String header,
          String subHeader, String image, int viewNumber, bool isSelected) =>
      Card(
        child: Container(
          padding: EdgeInsets.only(
              top: spacing15, left: spacing15, right: spacing15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _conditionList[viewNumber].isSelected =
                            !_conditionList[viewNumber].isSelected;
                      });
                    },
                    child: _conditionList[viewNumber].isSelected
                        ? Image.asset("images/checkedCheck.png",
                            height: 24, width: 24)
                        : Image.asset("images/uncheckedCheck.png",
                            height: 24, width: 24),
                  )),
              SizedBox(height: 10),
              Image.network(
                ApiBaseHelper.imageUrl + image,
                width: 40,
                height: 40,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: spacing10),
                  child: Text(
                    header,
                    style: TextStyle(
                        color: colorBlack2,
                        fontWeight: fontWeightSemiBold,
                        fontSize: fontSize14),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  subHeader,
                  style: TextStyle(
                      color: colorBlack2,
                      fontWeight: fontWeightRegular,
                      fontSize: fontSize12),
                ),
              ),
            ],
          ),
        ),
      ).onClick(onTap: () {
        setState(() {
          _conditionList[viewNumber].isSelected =
              !_conditionList[viewNumber].isSelected;
        });
      });

  _getConditionList(String _searchText, BuildContext context) {
    List<HealthCondition> tempList = [];
    if (_searchText == null || _searchText.isEmpty) {
      tempList.addAll(_tempConditionList);
    } else {
      List<HealthCondition> tempCondition = [];
      for (var item in _tempConditionList) {
        if (item.name != null) {
          if (item.name
                  .toLowerCase()
                  .startsWith(_searchText.trim().toLowerCase()) ||
              item.subName
                      .toLowerCase()
                      .indexOf(_searchText.trim().toLowerCase()) !=
                  -1) {
            tempCondition.add(item);
          }
        } else {
          if (item.subName
                  .toLowerCase()
                  .indexOf(_searchText.trim().toLowerCase()) !=
              -1) {
            tempCondition.add(item);
          }
        }
      }
      if (tempCondition.isNotEmpty) {
        tempList.addAll(tempCondition);
      }
    }
    setState(() {
      _conditionList = tempList;
    });
  }

  void _getAllHealthConditions(BuildContext context) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().getMoreConditions().then((result) {
      ProgressDialogUtils.dismissProgressDialog();
      if (result is ResMoreConditionModel) {
        setState(() {
          _conditionList = result.response;
          _tempConditionList = result.response;
        });
      }
    }).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  void _onForwardTap(BuildContext context) {
    String doctorId =
        Provider.of<HealthConditionProvider>(context, listen: false).providerId;
    List<BookedMedicalHistory> medicalHistory =
        Provider.of<HealthConditionProvider>(context, listen: false)
            .medicalHistoryData;
    String providerAddress =
        Provider.of<HealthConditionProvider>(context, listen: false)
            .providerAddress;
    Provider.of<HealthConditionProvider>(context, listen: false)
        .resetHealthConditionProvider();
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateProviderId(doctorId);
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateMedicalHistory(medicalHistory);
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateProviderAddress(providerAddress);
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateAllHealthIssuesData([]);
    List<SelectionHealthIssueModel> _selectedConditionList = [];
    List<int> tempList = [];
    int i = 0;
    _conditionList.forEach((element) {
      if (element.isSelected) {
        _selectedConditionList.add(SelectionHealthIssueModel(
            index: i,
            sId: element.sId,
            name: element.name,
            image: element.image,
            isSelected: element.isSelected));
        tempList.add(i);
        i++;
      } else {
        i++;
      }
    });
    if (tempList.isNotEmpty) {
      Provider.of<HealthConditionProvider>(context, listen: false)
          .updateHealthConditions(tempList);
      Provider.of<HealthConditionProvider>(context, listen: false)
          .updateListOfSelectedHealthIssues(_selectedConditionList);
      for (int i = 0;
          i <
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .listOfSelectedHealthIssues
                  .length;
          i++) {
        if (i ==
            Provider.of<HealthConditionProvider>(context, listen: false)
                .currentIndexOfIssue) {
          Provider.of<HealthConditionProvider>(context, listen: false)
              .updateCurrentIndex(0);
          Navigator.of(context).pushNamed(Routes.routeBoneAndMuscle, arguments: {
            ArgumentConstant.problemIdKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .sId,
            ArgumentConstant.problemNameKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .name,
            ArgumentConstant.problemImageKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .image
          });
        }
      }
    } else {
      Widgets.showToast("Please select any health condition");
    }
  }
}
