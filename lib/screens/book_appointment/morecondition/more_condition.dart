import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/res_condition_type.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class MoreCondition extends StatefulWidget {
  @override
  _MoreConditionState createState() => _MoreConditionState();
}

class _MoreConditionState extends State<MoreCondition> {
  List<ResConditionType> _conditionList = [];
  List<ResConditionType> _tempConditionList = [];
  final _searchConditionController = TextEditingController();
  final _searchConditionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 1));
      _conditionList.add(ResConditionType("Bowel, Stomach or Eating",
          "Digestive and Excretion", FileConstants.icChatSend, false, 2));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 3));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 4));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 5));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 6));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 7));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 8));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 9));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 10));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 11));
      _conditionList.add(ResConditionType("Bone and Muscle Pain",
          "Musculoskeletal Problem", FileConstants.icChatSend, false, 12));
      _tempConditionList = _conditionList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "",
            addHeader: true,
            padding: EdgeInsets.zero,
            addBottomArrows: true,
            onForwardTap: () {
              List<int> _selectedConditionList = [];
              _conditionList.forEach((element) {
                if (element.isSelected) {
                  _selectedConditionList.add(element.number);
                }
              });
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateHealthConditions(_selectedConditionList);
              Navigator.of(context).pushNamed(Routes.routeWelcomeNewFollowup);
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
                        Text(
                          Localization.of(context).tellUsAboutMore,
                          style: TextStyle(
                              fontSize: fontSize20,
                              fontWeight: fontWeightBold,
                              color: Color(0xff0E1C2A)),
                        ),
                        Container(
                          height: 42,
                          margin: EdgeInsets.only(
                              top: spacing10,
                              right: spacing15,
                              bottom: spacing10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 1,
                            minLines: 1,
                            controller: _searchConditionController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText:
                                    Localization.of(context).searchForProblem,
                                hintStyle: TextStyle(
                                    fontSize: fontSize14,
                                    fontWeight: fontWeightRegular),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(spacing8),
                                  child: Image.asset(
                                    FileConstants.icSearch,
                                    width: 10,
                                    height: 10,
                                  ),
                                )),
                            focusNode: _searchConditionFocusNode,
                            onChanged: (value) {
                              _getConditionList(value, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing10),
                    child: GridView.builder(
                      itemCount: _conditionList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return _columnCommonItem(
                          context,
                          _conditionList[index].conditionHeader,
                          _conditionList[index].conditionSubHeader,
                          _conditionList[index].image,
                          index,
                          _conditionList[index].isSelected,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _columnCommonItem(BuildContext context, String header,
          String subHeader, String image, int viewNumber, bool isSelected) =>
      Card(
        child: Container(
          padding: EdgeInsets.all(spacing15),
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
                ApiBaseHelper.imageUrl + "medicalDocuments-1622183421709.jpg",
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
                child: Padding(
                  padding: EdgeInsets.only(top: spacing10),
                  child: Text(
                    subHeader,
                    style: TextStyle(
                        color: colorBlack2,
                        fontWeight: fontWeightRegular,
                        fontSize: fontSize12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _getConditionList(String _searchText, BuildContext context) {
    List<ResConditionType> tempList = [];
    if (_searchText == null || _searchText.isEmpty) {
      tempList.addAll(_tempConditionList);
    } else {
      List<ResConditionType> tempCountry = [];
      for (var item in _tempConditionList) {
        if (item.conditionHeader != null) {
          if (item.conditionHeader
                  .toLowerCase()
                  .startsWith(_searchText.trim().toLowerCase()) ||
              item.conditionSubHeader
                      .toLowerCase()
                      .indexOf(_searchText.trim().toLowerCase()) !=
                  -1) {
            tempCountry.add(item);
          }
        } else {
          if (item.conditionSubHeader
                  .toLowerCase()
                  .indexOf(_searchText.trim().toLowerCase()) !=
              -1) {
            tempCountry.add(item);
          }
        }
      }
      if (tempCountry.isNotEmpty) {
        tempList.addAll(tempCountry);
      }
    }
    setState(() {
      _conditionList = tempList;
    });
  }
}
