import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/model/allergy.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';

import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AllergiesScreen extends StatefulWidget {
  AllergiesScreen({Key key, this.args}) : super(key: key);
  dynamic args;

  @override
  _AllergiesScreenState createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  ApiBaseHelper api = ApiBaseHelper();
  List<Allergy> myAllergiesList = [];
  List<Allergy> profileAllergiesList = [];
  String token = '';
  bool _isLoading = false;
  final _searchDiseaseController = TextEditingController();
  final _searchDiseaseFocusNode = FocusNode();
  InheritedContainerState _container;
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
      if (widget.args['allergy'] != null && widget.args['allergy'].length > 0) {
        for (dynamic aa in widget.args['allergy']) {
          myAllergiesList.add(Allergy.fromJson(aa));
        }
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPref().getToken().then((token) {
        setState(() {
          this.token = token;
        });
        _getMyAllergiesList();
      });
    });
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
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        addTitle: false,
        isAddBack: false,
        addBackButton: false,
        isLoading: _isLoading,
        addBottomArrows: true,
        onForwardTap: saveAllergies,
        color: Colors.white,
        isAddAppBar: true,
        padding: const EdgeInsets.all(spacing5),
        child: Column(
          children: <Widget>[
            _allergyHeader(context),
            _buildSearchAllergy(context),
            _currentAllergiesList(context),
          ],
        ),
      ),
    );
  }

  Widget _allergyHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.all(spacing10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Allergies',
            style: const TextStyle(
                color: colorDarkBlack,
                fontWeight: fontWeightBold,
                fontSize: fontSize16),
          ),
        ),
      );

  Widget _buildSearchAllergy(BuildContext context) => Container(
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
                hintText: 'Search Allergies',
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
            return pattern.length > 0 ? await _getAllergiesList(pattern) : [];
          },
          keepSuggestionsOnLoading: false,
          loadingBuilder: (context) => CustomLoader(),
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.name ?? ''),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            // setState(() {
            //   // _selectedAllergy = suggestion.name;
            //   // _selectedSid = suggestion.sId;
            // });
            _addMedicalAllergy(suggestion);
            // showAddDiseaseDialog(context, false);
            _searchDiseaseController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  Widget _currentAllergiesList(BuildContext context) => isIndicatorLoading
      ? Expanded(
          child: Center(
            child: CustomLoader(),
          ),
        )
      : myAllergiesList == null ||
              (myAllergiesList == null || myAllergiesList.isEmpty) &&
                  !isIndicatorLoading
          ? Expanded(
              child: Center(
                child: Text(
                  'No allergy added',
                  style: TextStyle(
                      fontSize: 16,
                      color: colorBlack2,
                      fontWeight: fontWeightSemiBold),
                ),
              ),
            )
          : Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, spacing8, 10, spacing8),
                child: ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    ListView.separated(
                      padding: EdgeInsets.only(bottom: 65),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: myAllergiesList.length,
                      itemBuilder: (context, index) {
                        return PopupMenuButton(
                          offset: Offset(300, 50),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            _popMenuCommonItem(
                                context,
                                Localization.of(context).remove,
                                FileConstants.icRemoveBlack)
                          ],
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(14.0),
                              ),
                              border: Border.all(
                                  width: 0.5, color: Colors.grey[300]),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                myAllergiesList[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(Icons.more_vert),
                            ),
                          ),
                          onSelected: (value) {
                            Widgets.showConfirmationDialog(
                              context: context,
                              description:
                                  "Are you sure to delete this allergy?",
                              onLeftPressed: () => _removeAllergy(
                                  context, myAllergiesList[index]),
                            );
                            // _removeAllergy(context, myAllergiesList[index]);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                    )
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

  void _removeAllergy(BuildContext context, Allergy allergy) {
    if (widget.args['isEdit']) {
      if (myAllergiesList.contains(allergy)) {
        setState(() {
          myAllergiesList.remove(allergy);
        });
      }
    } else {
      setLoading(true);
      if (profileAllergiesList.contains(allergy)) {
        profileAllergiesList.remove(allergy);
      }
      api.deletePatientAllergyHistory(token, allergy.sId).then((value) {
        setLoading(false);
        setState(() {
          if (myAllergiesList.contains(allergy)) {
            myAllergiesList.remove(allergy);
          }
        });
      }).futureError((error) {
        setLoading(false);
        error.toString().debugLog();
      });
    }
  }

  void saveAllergies() {
    if (widget.args['isEdit']) {
      Map<String, dynamic> model = {};
      model['allergy'] = myAllergiesList;
      model['appointmentId'] = widget.args['appointmentId'];
      setLoading(true);
      ApiManager().updateAppointmentData(model).then((value) {
        setLoading(false);
        Navigator.pop(context);
      });
    } else {
      if (myAllergiesList.length > 0) {
        Provider.of<HealthConditionProvider>(context, listen: false)
            .updateAllergies(myAllergiesList);
        Navigator.of(context).pushNamed(Routes.medicalHistoryScreen,
            arguments: {'isEdit': false});
      } else {
        Provider.of<HealthConditionProvider>(context, listen: false)
            .updateAllergies([]);
        Navigator.of(context).pushNamed(Routes.medicalHistoryScreen,
            arguments: {'isEdit': false});
      }
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  Future<List<Allergy>> _getAllergiesList(String pattern) async {
    return await ApiManager().searchAllergies(pattern);
  }

  _getMyAllergiesList() async {
    setState(() {
      isIndicatorLoading = true;
    });
    await ApiManager().getMyAllergies().then((result) {
      setLoading(false);
      profileAllergiesList = result;

      if (!widget.args['isEdit']) {
        myAllergiesList = profileAllergiesList;
      }
      setState(() {
        isIndicatorLoading = false;
      });
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

  _addMedicalAllergy(Allergy allergy) async {
    if (widget.args['isEdit']) {
      var _item = profileAllergiesList
          .firstWhere((element) => element.name == allergy.name);
      if (_item != null) {
        setState(() {
          myAllergiesList.add(_item);
        });
      }
    } else {
      allergy.allergyId = allergy.sId;
      setLoading(true);
      try {
        await ApiManager().addPatientAllergy(allergy).then(((result) {
          myAllergiesList
              .add(Allergy.fromJson(result['response']['allergy'].last));
          setLoading(false);
        }));
      } catch (e) {
        setLoading(false);
        ProgressDialogUtils.dismissProgressDialog();
        print(e);
      }
    }
  }
}
