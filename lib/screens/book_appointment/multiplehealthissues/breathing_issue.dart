// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
// import 'package:hutano/colors.dart';
// import 'package:hutano/dimens.dart';
// import 'package:hutano/routes.dart';
// import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
// import 'package:hutano/utils/color_utils.dart';
// import 'package:hutano/utils/common_methods.dart';
// import 'package:hutano/utils/constants/file_constants.dart';
// import 'package:hutano/utils/localization/localization.dart';
// import 'package:hutano/widgets/custom_loader.dart';
// import 'package:hutano/widgets/loading_background_new.dart';
// import 'package:hutano/widgets/loading_background_new.dart';
// import 'package:provider/provider.dart';

// import 'model/body_part_model.dart';

// //TODO STATIC TEXT WILL BE REMOVE AFTER API INTEGRATION

// class BreathingIssue extends StatefulWidget {
//   final bool isAntiAging;
//   final bool stomach;
//   final bool breathing;
//   final bool healthChest;
//   final bool nutrition;
//   BreathingIssue(
//       {this.isAntiAging = false,
//       this.stomach = false,
//       this.breathing = false,
//       this.healthChest = false,
//       this.nutrition = false});
//   @override
//   _BreathingIssueState createState() => _BreathingIssueState();
// }

// class _BreathingIssueState extends State<BreathingIssue> {
//   GlobalKey _rangeSliderKey = GlobalKey();
//   double _discomfortIntensity = 0;
//   TextEditingController _searchAssociatedSymptomsController =
//       TextEditingController();
//   FocusNode _searchAssociatedSymptomsFocusNode = FocusNode();
//   List<BodyPartModel> _listOfAssociatedSymptoms = [];
//   List<BodyPartModel> _listOfSelectedDisease = [];

//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       _listOfAssociatedSymptoms
//           .add(BodyPartModel("Feet Swelling", false, [], false, 0));
//       _listOfAssociatedSymptoms
//           .add(BodyPartModel("Swelling of hands", false, [], false, 0));
//       _listOfAssociatedSymptoms
//           .add(BodyPartModel("Anxiety", false, [], false, 0));
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.goldenTainoi,
//       resizeToAvoidBottomInset: false,
//       body: LoadingBackgroundNew(
//           title: "",
//           addHeader: true,
//           padding: EdgeInsets.only(
//               left: spacing20, right: spacing10, bottom: spacing70),
//           addBottomArrows: true,
//           onForwardTap: () {
//             // _nextScreenNavigation(context);
//             Navigator.of(context).pushNamed(Routes.routeEffectAbility);
//           },
//           // isCameraVisible: true,
//           // onCameraForTap: () {},
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _commonHeaderText(context, _getHeaderText()),
//                 _buildSearchForBodyPart(context),
//                 _associatedSymptomsList(context),
//                 _commonHeaderText(
//                     context, Localization.of(context).rateYourDiscomfort),
//                 _rateDiscomfort(context)
//               ],
//             ),
//           )),
//     );
//   }

//   String _getHeaderText() {
//     if (widget.stomach) {
//       return Localization.of(context).bowelStomachHeader;
//     } else if (widget.breathing) {
//       return Localization.of(context).breathingIssueLabel;
//     } else if (widget.healthChest) {
//       return Localization.of(context).chestAndHeartHeader;
//     } else if (widget.isAntiAging) {
//       return Localization.of(context).antiAgingHeader;
//     } else if (widget.nutrition) {
//       return Localization.of(context).nutritionHeader;
//     } else {
//       return "";
//     }
//   }

//   String _getHintText() {
//     if (widget.stomach) {
//       return Localization.of(context).searchAssociatedSymptomsLabel;
//     } else if (widget.breathing) {
//       return Localization.of(context).searchAssociatedSymptomsLabel;
//     } else if (widget.healthChest) {
//       return Localization.of(context).searchForBodyPart;
//     } else if (widget.isAntiAging) {
//       return Localization.of(context).whatIsTheProblemLabel;
//     } else if (widget.nutrition) {
//       return Localization.of(context).yourGoalsHint;
//     } else {
//       return "";
//     }
//   }

//   Widget _commonHeaderText(BuildContext context, String header) => Padding(
//         padding: EdgeInsets.symmetric(vertical: spacing20),
//         child: Text(
//           header,
//           style: TextStyle(
//               color: Color(0xff0e1c2a),
//               fontSize: fontSize16,
//               fontWeight: fontWeightBold),
//         ),
//       );

//   Widget _buildSearchForBodyPart(BuildContext context) => Container(
//         padding: const EdgeInsets.only(top: spacing2),
//         height: 40,
//         decoration: BoxDecoration(
//             color: colorBlack2.withOpacity(0.06),
//             borderRadius: BorderRadius.all(Radius.circular(8))),
//         child: TypeAheadFormField(
//           textFieldConfiguration: TextFieldConfiguration(
//               controller: _searchAssociatedSymptomsController,
//               focusNode: _searchAssociatedSymptomsFocusNode,
//               textInputAction: TextInputAction.next,
//               maxLines: 1,
//               onTap: () {},
//               onChanged: (value) {},
//               decoration: InputDecoration(
//                 prefixIconConstraints: BoxConstraints(),
//                 prefixIcon: GestureDetector(
//                     onTap: () {},
//                     child: Padding(
//                         padding: const EdgeInsets.all(spacing8),
//                         child: Image.asset(FileConstants.icSearchBlack,
//                             color: colorBlack2, width: 20, height: 20))),
//                 hintText: _getHintText(),
//                 isDense: true,
//                 hintStyle: TextStyle(
//                     color: colorBlack2,
//                     fontSize: fontSize13,
//                     fontWeight: fontWeightRegular),
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//               )),
//           suggestionsCallback: (pattern) async {
//             return pattern.length > 0 ? await _getFilteredSymptomsList() : [];
//           },
//            keepSuggestionsOnLoading: false,
//           loadingBuilder: (context) => CustomLoader(),
//           errorBuilder: (_, object) {
//             return Container();
//           },
//           itemBuilder: (context, suggestion) {
//             return ListTile(
//               title: Text(suggestion.bodyPart),
//             );
//           },
//           transitionBuilder: (context, suggestionsBox, controller) {
//             return suggestionsBox;
//           },
//           onSuggestionSelected: (suggestion) {
//             setState(() {
//               _listOfSelectedDisease.add(BodyPartModel(
//                   suggestion.bodyPart,
//                   suggestion.hasInternalPart,
//                   suggestion.sides,
//                   suggestion.isItClicked,
//                   0));
//             });
//             _searchAssociatedSymptomsController.text = "";
//           },
//           hideOnError: true,
//           hideSuggestionsOnKeyboardHide: true,
//           hideOnEmpty: true,
//         ),
//       );

//   _getFilteredSymptomsList() {
//     return _listOfAssociatedSymptoms.where((element) => element.bodyPart
//         .toLowerCase()
//         .contains(_searchAssociatedSymptomsController.text.toLowerCase()));
//   }

//   Widget _associatedSymptomsList(BuildContext context) => ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return PopupMenuButton(
//           offset: Offset(300, 50),
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             _popMenuCommonItem(
//                 context, Localization.of(context).edit, FileConstants.icEdit),
//             _popMenuCommonItem(context, Localization.of(context).remove,
//                 FileConstants.icRemoveBlack)
//           ],
//           child: ListTile(
//             contentPadding: EdgeInsets.all(0),
//             title: Text(
//               "${index + 1}. " + _listOfSelectedDisease[index].bodyPart,
//               style: TextStyle(
//                   fontWeight: fontWeightMedium,
//                   fontSize: fontSize14,
//                   color: colorBlack2),
//             ),
//             trailing: Icon(Icons.more_vert, color: colorBlack2),
//           ),
//           onSelected: (value) {
//             if (value == Localization.of(context).edit) {
//             } else {
//               setState(() {
//                 _listOfSelectedDisease.remove(_listOfSelectedDisease[index]);
//               });
//             }
//           },
//         );
//       },
//       itemCount: _listOfSelectedDisease.length);

//   Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
//       PopupMenuItem<String>(
//         value: value,
//         textStyle: const TextStyle(
//             color: colorBlack2,
//             fontWeight: fontWeightRegular,
//             fontSize: spacing12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               image,
//               height: 15,
//               width: 15,
//             ),
//             SizedBox(
//               width: spacing5,
//             ),
//             Text(value)
//           ],
//         ),
//       );

//   Widget _rateDiscomfort(BuildContext context) => FlutterSlider(
//         values: [_discomfortIntensity],
//         max: 10,
//         min: 0,
//         onDragging: (_, lowerValue, __) {
//           setState(() {
//             _discomfortIntensity = lowerValue;
//           });
//         },
//         trackBar: FlutterSliderTrackBar(
//           activeTrackBarHeight: 18,
//           inactiveTrackBarHeight: 18,
//           activeTrackBar: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.sunglow,
//               gradient: LinearGradient(
//                   colors: [Color(0xffFFE18D), Color(0xffFFC700)])),
//           inactiveTrackBar: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: colorGreyBackground,
//           ),
//         ),
//         handler: FlutterSliderHandler(
//           decoration: BoxDecoration(),
//           child: Container(
//             child: Container(
//               key: _rangeSliderKey,
//               height: 18,
//               width: 18,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: accentColor),
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: accentColor.withOpacity(0.4),
//                     blurRadius: 5,
//                     offset: Offset(0, 2),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         tooltip: FlutterSliderTooltip(
//           custom: (value) {
//             return _buildButton(value);
//           },
//           boxStyle: FlutterSliderTooltipBox(),
//           direction: FlutterSliderTooltipDirection.top,
//           alwaysShowTooltip: true,
//         ),
//         rangeSlider: false,
//       );

//   Widget _buildButton(double value) => InkWell(
//         child: Container(
//           margin: EdgeInsets.only(top: spacing2),
//           child: Text(
//             _getTextValue(value),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//                 color: Color(0xffFFC259),
//                 fontWeight: fontWeightMedium,
//                 fontSize: fontSize10),
//           ),
//           alignment: Alignment.center,
//           padding: EdgeInsets.all(spacing5),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//               color: colorBlack2),
//         ),
//       );

//   String _getTextValue(double value) {
//     if (value >= 0.0 && value < 4) {
//       return Localization.of(context).lowLabel;
//     } else if (value >= 4 && value < 8) {
//       return Localization.of(context).mediumLabel;
//     } else {
//       return Localization.of(context).highLabel;
//     }
//   }

//   void _nextScreenNavigation(BuildContext context) {
//     if (widget.isAntiAging) {
//       if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(12)) {
//         Navigator.pushNamed(context, Routes.routeImmunization);
//       } else {
//         Navigator.pushNamed(context, Routes.routeEffectAbility);
//       }
//     } else if (widget.stomach) {
//       if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(3)) {
//         breathingNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(4)) {
//         abnormalNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(5)) {
//         femaleHealthNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(6)) {
//         maleHealthNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(7)) {
//         woundSkinNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(8)) {
//         healthAndChestNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(9)) {
//         dentalCareNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(11)) {
//         antiAgingNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(12)) {
//         Navigator.pushNamed(context, Routes.routeImmunization);
//       } else {
//         Navigator.pushNamed(context, Routes.routeEffectAbility);
//       }
//     } else if (widget.breathing) {
//       if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(4)) {
//         abnormalNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(5)) {
//         femaleHealthNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(6)) {
//         maleHealthNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(7)) {
//         woundSkinNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(8)) {
//         healthAndChestNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(9)) {
//         dentalCareNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(11)) {
//         antiAgingNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(12)) {
//         Navigator.pushNamed(context, Routes.routeImmunization);
//       } else {
//         Navigator.pushNamed(context, Routes.routeEffectAbility);
//       }
//     } else if (widget.healthChest) {
//       if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(9)) {
//         dentalCareNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(11)) {
//         antiAgingNavigation(context);
//       } else if (Provider.of<HealthConditionProvider>(context, listen: false)
//           .healthConditions
//           .contains(12)) {
//         Navigator.pushNamed(context, Routes.routeImmunization);
//       } else {
//         Navigator.pushNamed(context, Routes.routeEffectAbility);
//       }
//     }
//   }

//   int getIssueIndex() {
//     if (widget.isAntiAging) {
//       return 11;
//     } else if (widget.stomach) {
//       return 2;
//     } else if (widget.breathing) {
//       return 3;
//     } else if (widget.healthChest) {
//       return 8;
//     } else {
//       return 1;
//     }
//   }
// }
