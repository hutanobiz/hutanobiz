import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/book_appointment/vitals/model/social_history.dart';
import 'package:hutano/screens/medical_history/provider/appoinment_provider.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

class SocialHistoryScreen extends StatefulWidget {
  SocialHistoryScreen({Key? key, this.map}) : super(key: key);
  dynamic map;

  @override
  _SocialHistoryScreenState createState() => _SocialHistoryScreenState();
}

class _SocialHistoryScreenState extends State<SocialHistoryScreen> {
  bool isLoading = false;
  bool isSmoker = false, isDrinker = false, isRecreationalDrug = false;
  bool isMarijuana = false,
      isCoccine = false,
      isMetaphetamin = false,
      isHeroine = false;
  String? smokerGroupValue = "1",
      drinkGroupValue = "1",
      recreationalGroupValue = "1";
  String? marijuanaGroupValue = "1",
      coccineGroupValue = "1",
      metaGroupValue = "1",
      heroineGroupValue = "1";
  bool isLiquor = false, isBeer = false;
  int _isBeerMore = 0, _isLiquorMore = 0;

  @override
  void initState() {
    // if (widget.map['isEdit']) {
    if (widget.map['socialHistory'] != null) {
      if (widget.map['socialHistory']['smoking'] != null &&
          widget.map['socialHistory']['smoking']['frequency'] != null &&
          widget.map['socialHistory']['smoking']['frequency'] != '0') {
        isSmoker = true;
        smokerGroupValue = widget.map['socialHistory']['smoking']['frequency'];
      }

      if (widget.map['socialHistory']['Drinker'] != null &&
          widget.map['socialHistory']['Drinker']['frequency'] != null &&
          widget.map['socialHistory']['Drinker']['frequency'] != '0') {
        isDrinker = true;

        drinkGroupValue = widget.map['socialHistory']['Drinker']['frequency'];
        if (widget.map['socialHistory']['Drinker']['liquorQuantity'] != null &&
            widget.map['socialHistory']['Drinker']['liquorQuantity'] != '0') {
          isLiquor = true;
          _isLiquorMore =
              widget.map['socialHistory']['Drinker']['liquorQuantity'] == '2'
                  ? 2
                  : 1;
        }

        if (widget.map['socialHistory']['Drinker']['BeerQuantity'] != null &&
            widget.map['socialHistory']['Drinker']['BeerQuantity'] != '0') {
          isBeer = true;
          _isBeerMore =
              widget.map['socialHistory']['Drinker']['BeerQuantity'] == '2'
                  ? 2
                  : 1;
        }
      }
      if (widget.map['socialHistory']['recreationalDrugs'] != null &&
          widget.map['socialHistory']['recreationalDrugs'] is List &&
          widget.map['socialHistory']['recreationalDrugs'].length > 0) {
        isRecreationalDrug = true;

        for (dynamic map in widget.map['socialHistory']['recreationalDrugs']) {
          // Marijuana,Coccine,Metaphetamin,Heroine
          if (map['type'].toString().toLowerCase() == 'marijuana') {
            isMarijuana = true;
            marijuanaGroupValue =
                map['frequency'] == "0" ? "3" : map['frequency'];
          }
          if (map['type'].toString().toLowerCase() == 'cocaine') {
            isCoccine = true;
            coccineGroupValue =
                map['frequency'] == "0" ? "3" : map['frequency'];
          }
          if (map['type'].toString().toLowerCase() == 'metaphetamin') {
            isMetaphetamin = true;
            metaGroupValue = map['frequency'] == "0" ? "3" : map['frequency'];
          }
          if (map['type'].toString().toLowerCase() == 'heroine') {
            isHeroine = true;
            heroineGroupValue =
                map['frequency'] == "0" ? "3" : map['frequency'];
          }
        }
      }
      setState(() {});
    }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            addHeader: true,
            title: "",
            color: AppColors.snow,
            isAddBack: false,
            addBackButton: false,
            addBottomArrows: true,
            onForwardTap: saveSocialHistory,
            isLoading: isLoading,
            padding: EdgeInsets.zero,
            child: ListView(padding: EdgeInsets.all(20), children: [
              Text(
                'Social History',
                style: const TextStyle(
                    color: colorDarkBlack,
                    fontWeight: fontWeightBold,
                    fontSize: fontSize16),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    border: Border.all(width: 0.5, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      titleWidget(1, 'Smoker', isSmoker),
                      isSmoker
                          ? Column(
                              children: [
                                smokerRadioListItem(
                                    1,
                                    "1",
                                    '1-10 cigarettes per day',
                                    smokerGroupValue),
                                smokerRadioListItem(
                                    1, "2", 'a Pack a day', smokerGroupValue),
                                smokerRadioListItem(
                                    1,
                                    "3",
                                    'More than one pack a day',
                                    smokerGroupValue)
                              ],
                            )
                          : SizedBox()
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    border: Border.all(width: 0.5, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      titleWidget(2, 'Drinker', isDrinker),
                      isDrinker
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                smokerRadioListItem(
                                    2, "1", 'Rarely', drinkGroupValue),
                                smokerRadioListItem(
                                    2, "2", 'Socially', drinkGroupValue),
                                smokerRadioListItem(
                                    2, "3", 'Daily', drinkGroupValue),
                                drinkGroupValue == "3"
                                    ? SizedBox(height: 12)
                                    : SizedBox(),
                                drinkGroupValue == "3"
                                    ? Row(
                                        children: [
                                          Text('Liquor'),
                                          // SizedBox(
                                          //   width: 50,
                                          // ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isLiquor = !isLiquor;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Image.asset(
                                                isLiquor
                                                    ? 'images/checkedCheck.png'
                                                    : 'images/uncheckedCheck.png',
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          isLiquor
                                              ? Column(
                                                  children: [
                                                    _yesButtonWidget(
                                                        context,
                                                        1,
                                                        'Less than 1pt',
                                                        _isLiquorMore),
                                                    SizedBox(height: 2),
                                                    _noButtonWidget(
                                                        context,
                                                        1,
                                                        'More than 1pt',
                                                        _isLiquorMore),
                                                  ],
                                                )
                                              : Spacer(),
                                        ],
                                      )
                                    : SizedBox(),
                                drinkGroupValue == "3"
                                    ? SizedBox(height: 8)
                                    : SizedBox(),
                                drinkGroupValue == "3"
                                    ? Row(
                                        // crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text('Beer   '),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isBeer = !isBeer;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Image.asset(
                                                isBeer
                                                    ? 'images/checkedCheck.png'
                                                    : 'images/uncheckedCheck.png',
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          isBeer
                                              ? Column(
                                                  children: [
                                                    _yesButtonWidget(
                                                        context,
                                                        2,
                                                        'Less than 6',
                                                        _isBeerMore),
                                                    SizedBox(height: 2),
                                                    _noButtonWidget(
                                                        context,
                                                        2,
                                                        'More than 6',
                                                        _isBeerMore),
                                                  ],
                                                )
                                              : Spacer(),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox()
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    border: Border.all(width: 0.5, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      recreationaltitleWidget(
                          3, 'Recreational Drugs', isRecreationalDrug),
                      isRecreationalDrug
                          ? Column(
                              children: [
                                titleWidget(4, 'Marijuana', isMarijuana),
                                isMarijuana
                                    ? Column(children: [
                                        smokerRadioListItem(4, "1", 'Rarely',
                                            marijuanaGroupValue),
                                        smokerRadioListItem(4, "2", 'Socially',
                                            marijuanaGroupValue),
                                        smokerRadioListItem(4, "3", 'Daily',
                                            marijuanaGroupValue)
                                      ])
                                    : SizedBox(),
                                titleWidget(5, 'Cocaine', isCoccine),
                                isCoccine
                                    ? Column(children: [
                                        smokerRadioListItem(5, "1", 'Rarely',
                                            coccineGroupValue),
                                        smokerRadioListItem(5, "2", 'Socially',
                                            coccineGroupValue),
                                        smokerRadioListItem(
                                            5, "3", 'Daily', coccineGroupValue)
                                      ])
                                    : SizedBox(),
                                titleWidget(
                                    6, 'Methamphetamine', isMetaphetamin),
                                isMetaphetamin
                                    ? Column(children: [
                                        smokerRadioListItem(
                                            6, "1", 'Rarely', metaGroupValue),
                                        smokerRadioListItem(
                                            6, "2", 'Socially', metaGroupValue),
                                        smokerRadioListItem(
                                            6, "3", 'Daily', metaGroupValue)
                                      ])
                                    : SizedBox(),
                                titleWidget(7, 'Heroine', isHeroine),
                                isHeroine
                                    ? Column(children: [
                                        smokerRadioListItem(7, "1", 'Rarely',
                                            heroineGroupValue),
                                        smokerRadioListItem(7, "2", 'Socially',
                                            heroineGroupValue),
                                        smokerRadioListItem(
                                            7, "3", 'Daily', heroineGroupValue)
                                      ])
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox()
                    ],
                  )),
              SizedBox(
                height: 60,
              ),
            ])));
  }

  titleWidget(int type, String title, bool isDrugChecked) {
    return GestureDetector(
        onTap: () {
          setState(() {
            switch (type) {
              case 1:
                isSmoker = !isSmoker;
                break;
              case 2:
                isDrinker = !isDrinker;
                break;
              case 3:
                isRecreationalDrug = !isRecreationalDrug;
                break;
              case 4:
                isMarijuana = !isMarijuana;
                break;
              case 5:
                isCoccine = !isCoccine;
                break;
              case 6:
                isMetaphetamin = !isMetaphetamin;
                break;
              case 7:
                isHeroine = !isHeroine;
                break;
              default:
            }
          });
        },
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
              child: Image.asset(
                isDrugChecked
                    ? 'images/checkedCheck.png'
                    : 'images/uncheckedCheck.png',
                height: 20,
              ),
            ),
          ],
        ));
  }

  recreationaltitleWidget(int type, String title, bool isDrugChecked) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isRecreationalDrug = !isRecreationalDrug;
          });
        },
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isDrugChecked
                    ? Icons.keyboard_arrow_down_sharp
                    : Icons.keyboard_arrow_down_sharp,
                size: 20,
              ),
            ),
          ],
        ));
  }

  Widget _yesButtonWidget(
          BuildContext context, int type, String title, int isMore) =>
      HutanoButton(
        width: 140,
        borderColor: colorGrey,
        label: title,
        onPressed: () {
          setState(() {
            switch (type) {
              case 1:
                _isLiquorMore = 1;
                break;
              default:
                _isBeerMore = 1;
            }
          });
          // _wholeBodyController
          //     .jumpTo(_wholeBodyController.position.maxScrollExtent);
          // _wholeBodyController.animateTo(
          //     _wholeBodyController.position.maxScrollExtent,
          //     duration: Duration(milliseconds: 500),
          //     curve: Curves.ease);
        },
        buttonType: HutanoButtonType.onlyLabel,
        // width: 65,
        borderWidth: 1,
        labelColor: isMore == 1 ? colorWhite : Colors.grey,
        color: isMore == 1 ? colorPurple100 : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(
          BuildContext context, int type, String title, int isMore) =>
      HutanoButton(
        borderColor: colorGrey,
        label: title,
        width: 140,
        onPressed: () {
          setState(() {
            switch (type) {
              case 1:
                _isLiquorMore = 2;
                break;
              default:
                _isBeerMore = 2;
            }
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        // width: 65,
        labelColor: isMore == 2 ? colorWhite : Colors.grey,
        color: isMore == 2 ? colorPurple100 : colorWhite,
        borderWidth: 1,
        height: 34,
      );

  Row smokerRadioListItem(
      int type, String value, String title, String? groupValue) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Radio(
            value: value,
            activeColor: AppColors.windsor,
            groupValue: groupValue,
            onChanged: ((dynamic val) {
              setState(() {
                switch (type) {
                  case 1:
                    smokerGroupValue = val;
                    break;
                  case 2:
                    drinkGroupValue = val;
                    isBeer = false;
                    isLiquor = false;
                    _isBeerMore = 0;
                    _isLiquorMore = 0;
                    break;
                  case 3:
                    recreationalGroupValue = val;
                    break;
                  case 4:
                    marijuanaGroupValue = val;
                    break;
                  case 5:
                    coccineGroupValue = val;
                    break;
                  case 6:
                    metaGroupValue = val;
                    break;
                  case 7:
                    heroineGroupValue = val;
                    break;
                  default:
                }
                groupValue = val;
              });
            }))
      ],
    );
  }

  void saveSocialHistory() {
    SocialHistory socialHistory = SocialHistory();
    if (isSmoker) {
      socialHistory.smoking = Smoking(frequency: smokerGroupValue);
    }
    // if (isRecreationalDrug) {
    List<RecreationalDrugs> recreationalDrugs = [];
    if (isMarijuana) {
      recreationalDrugs.add(
          RecreationalDrugs(type: 'Marijuana', frequency: marijuanaGroupValue));
    }
    if (isCoccine) {
      recreationalDrugs.add(
          RecreationalDrugs(type: 'Cocaine', frequency: coccineGroupValue));
    }
    if (isMetaphetamin) {
      recreationalDrugs.add(RecreationalDrugs(
          type: 'Methamphetamine', frequency: metaGroupValue));
    }
    if (isHeroine) {
      recreationalDrugs.add(
          RecreationalDrugs(type: 'Heroine', frequency: heroineGroupValue));
    }
    socialHistory.recreationalDrugs = recreationalDrugs;
    // }
    if (isDrinker) {
      Drinker drinker = Drinker(
          frequency: drinkGroupValue,
          liquorQuantity: isLiquor
              ? _isLiquorMore == 2
                  ? "2"
                  : "1"
              : "0",
          beerQuantity: isBeer
              ? _isBeerMore == 2
                  ? "2"
                  : "1"
              : "0");

      socialHistory.drinker = drinker;
    }
    ApiBaseHelper api = ApiBaseHelper();
    setLoading(true);
    api.profile("Bearer ${getString(PreferenceKey.tokens)}", {
      'patientSocialHistory': socialHistory.toJson(),
    }).then((value) {
      setString('patientSocialHistory', jsonEncode(socialHistory));
      if (widget.map['isEdit']) {
        if (widget.map['appointmentId'] != null) {
          Map<String, dynamic> model = {};
          model['socialHistory'] = socialHistory.toJson();
          model['appointmentId'] = widget.map['appointmentId'];

          ApiManager().updateAppointmentData(model).then((value) {
            setLoading(false);
            Navigator.pop(context);
          });
          ApiBaseHelper api = ApiBaseHelper();
          api.profile("Bearer ${getString(PreferenceKey.tokens)}", {
            'patientSocialHistory': socialHistory.toJson(),
          });
        } else {
          setLoading(false);
          Navigator.pop(context);
        }
      } else {
        setLoading(false);
        Provider.of<HealthConditionProvider>(context, listen: false)
            .updateSocialHistory(socialHistory);
        Navigator.of(context)
            .pushNamed(Routes.allergiesScreen, arguments: {'isEdit': false});
      }
    });
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
