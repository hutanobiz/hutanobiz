import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';

import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';
import 'model/req_selected_condition_model.dart';
import 'model/res_selected_condition_model.dart';

class MakesConditionBetterWorst extends StatefulWidget {
  final String? problemId;
  MakesConditionBetterWorst({this.problemId});
  @override
  _MakesConditionBetterWorstState createState() =>
      _MakesConditionBetterWorstState();
}

class _MakesConditionBetterWorstState extends State<MakesConditionBetterWorst> {
  TextEditingController _problemBetterController = TextEditingController();
  TextEditingController _problemWorstController = TextEditingController();
  FocusNode _problemBetterFocusNode = FocusNode();
  FocusNode _problemWorstFocusNode = FocusNode();
  List<String>? _problemBetterList = [];
  List<String> _selectedProblemBetterList = [];
  List<String>? _problemWorstList = [];
  List<String> _selectedProblemWorstList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getHealthConditionDetails(
          context, ReqSelectConditionModel(problemIds: [widget.problemId]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "",
            addHeader: true,
            padding: EdgeInsets.only(
                left: spacing20, right: spacing10, bottom: spacing70),
            addBottomArrows: true,
            onForwardTap: () {
              // final model =
              //     Provider.of<HealthConditionProvider>(context, listen: false)
              //         .boneAndMuscleData;
              // model.problemBetter = _selectedProblemBetterList;
              // model.problemWorst = _selectedProblemWorstList;
              // Provider.of<HealthConditionProvider>(context, listen: false)
              //     .updateBoneAndMuscleData(model);
              // Navigator.pushNamed(context, routeEffectAbility);
            },
            // isCameraVisible: true,
            // onCameraForTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commonHeaderText(
                      context, Localization.of(context)!.makesYourProblemBetter),
                  _buildSearchForProblemBetter(context),
                  _selectedProblemBetterListItems(context),
                  SizedBox(height: spacing15),
                  _buildSearchForProblemWorst(context),
                  _selectedProblemWorstListItems(context)
                ],
              ),
            )));
  }

  Widget _commonHeaderText(BuildContext context, String header) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          header,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _buildSearchForProblemBetter(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: _problemBetterController,
              focusNode: _problemBetterFocusNode,
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
                  hintText:
                      Localization.of(context)!.actuallyMakesYourProblemBetter,
                  isDense: true,
                  hintStyle: TextStyle(
                      color: colorBlack2,
                      fontSize: fontSize13,
                      fontWeight: fontWeightRegular),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none)),
          suggestionsCallback: (pattern) async {
            return pattern.length > 0
                ? await _getFilteredProblemBetterList()
                : [];
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, dynamic suggestion) {
            return ListTile(title: Text(suggestion));
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (dynamic suggestion) {
            setState(() {
              if (!_selectedProblemBetterList.contains(suggestion))
                _selectedProblemBetterList.add(suggestion);
            });
            _problemBetterController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  _getFilteredProblemBetterList() {
    return _problemBetterList!.where((element) => element
        .toLowerCase()
        .contains(_problemBetterController.text.toLowerCase()));
  }

  Widget _selectedProblemBetterListItems(BuildContext context) =>
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PopupMenuButton(
              offset: Offset(300, 50),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _popMenuCommonItem(context, Localization.of(context)!.remove,
                    FileConstants.icRemoveBlack) as PopupMenuEntry<String>
              ],
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${index + 1}. " + _selectedProblemBetterList[index],
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorBlack2),
                ),
                trailing: Icon(Icons.more_vert, color: colorBlack2),
              ),
              onSelected: (dynamic value) {
                setState(() {
                  _selectedProblemBetterList
                      .remove(_selectedProblemBetterList[index]);
                });
              },
            );
          },
          itemCount: _selectedProblemBetterList.length);

  Widget _buildSearchForProblemWorst(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: _problemWorstController,
              focusNode: _problemWorstFocusNode,
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
                hintText:
                    Localization.of(context)!.actuallyMakesYourProblemWorst,
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
            return pattern.length > 0
                ? await _getFilteredProblemWorstLst()
                : [];
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, dynamic suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (dynamic suggestion) {
            setState(() {
              if (!_selectedProblemWorstList.contains(suggestion))
                _selectedProblemWorstList.add(suggestion);
            });
            _problemWorstController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  _getFilteredProblemWorstLst() {
    return _problemWorstList!.where((element) => element
        .toLowerCase()
        .contains(_problemWorstController.text.toLowerCase()));
  }

  Widget _selectedProblemWorstListItems(BuildContext context) =>
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PopupMenuButton(
              offset: Offset(300, 50),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _popMenuCommonItem(context, Localization.of(context)!.remove,
                    FileConstants.icRemoveBlack) as PopupMenuEntry<String>
              ],
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${index + 1}. " + _selectedProblemWorstList[index],
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorBlack2),
                ),
                trailing: Icon(Icons.more_vert, color: colorBlack2),
              ),
              onSelected: (dynamic value) {
                setState(() {
                  _selectedProblemWorstList
                      .remove(_selectedProblemWorstList[index]);
                });
              },
            );
          },
          itemCount: _selectedProblemWorstList.length);

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
          value: value,
          textStyle: const TextStyle(
              color: colorBlack2,
              fontWeight: fontWeightRegular,
              fontSize: spacing12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(image, height: 15, width: 15),
            SizedBox(width: spacing5),
            Text(value)
          ]));

  void _getHealthConditionDetails(
      BuildContext context, ReqSelectConditionModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().getHealthConditionDetails(reqModel).then(((result) {
      if (result is ResSelectConditionModel) {
        ProgressDialogUtils.dismissProgressDialog();
        setState(() {
          _problemBetterList = result.response![0].problemBetter;
          _problemWorstList = result.response![0].problemWorst;
        });
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
