import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/filter_radio_model.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';

class ProviderFiltersScreen extends StatefulWidget {
  ProviderFiltersScreen({Key key, this.filterMap}) : super(key: key);

  final Map filterMap;

  @override
  _ProviderFiltersScreenState createState() => _ProviderFiltersScreenState();
}

class _ProviderFiltersScreenState extends State<ProviderFiltersScreen> {
  InheritedContainerState _container;
  List<dynamic> _filtersList = List();

  List<RadioModel> _filterOptionsList = new List<RadioModel>();
  Map _filtersMap = Map();
  ApiBaseHelper _api = ApiBaseHelper();

  int filterListIndex = 0;
  String filterMapKey;

  bool _isLoading = false;

  RangeValues _experienceRangeValues = RangeValues(0, 50);
  RangeValues _distanceRangeValues = RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    _filterOptionsList.add(RadioModel(true, "Professional Title"));
    _filterOptionsList.add(RadioModel(false, "Speciality"));
    _filterOptionsList.add(RadioModel(false, "Degree"));
    _filterOptionsList.add(RadioModel(false, "Experience"));
    _filterOptionsList.add(RadioModel(false, "Distance"));
    _filterOptionsList.add(RadioModel(false, "Language"));

    _filtersMap = widget.filterMap;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _filtersList = _container.filterDataMap["professionalTitleList"];
    setFilterMapKey('professionalTitleId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Filters",
        isAddBack: false,
        isLoading: _isLoading,
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F2F8).withOpacity(0.50),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22.0),
                      ),
                    ),
                    width: 140,
                    child: ListView.builder(
                      itemCount: _filterOptionsList.length,
                      itemBuilder: (context, index) {
                        RadioModel model = _filterOptionsList[index];
                        return filterWidget(model).onClick(onTap: () {
                          if (filterListIndex == index) return;

                          switch (index) {
                            case 0:
                              setFilterMapKey('professionalTitleId');
                              _filtersList = _container
                                  .filterDataMap["professionalTitleList"];

                              break;
                            case 1:
                              getSpecialities();
                              break;
                            case 2:
                              getDegrees();
                              break;
                            case 5:
                              getLanguages();
                              break;
                            default:
                              setFilterMapKey('professionalTitleId');
                              _filtersList = _container
                                  .filterDataMap["professionalTitleList"];
                          }

                          setState(() {
                            filterListIndex = index;

                            _filterOptionsList.forEach(
                                (element) => element.isSelected = false);
                            model.isSelected = true;
                          });
                        });
                      },
                    ),
                  ),
                ),
                filterListIndex == 3
                    ? rangeSliderWidget(
                        'Set Experience range',
                        _experienceRangeValues,
                        (RangeValues newValues) {
                          setState(() {
                            _experienceRangeValues = newValues;

                            _filtersMap['experience'] = _experienceRangeValues
                                    .start
                                    .toStringAsFixed(0) +
                                "-" +
                                _experienceRangeValues.end.toStringAsFixed(0);
                          });

                          _filtersMap.toString().debugLog();
                        },
                      )
                    : filterListIndex == 4
                        ? rangeSliderWidget(
                            'Set Distance range',
                            _distanceRangeValues,
                            (RangeValues newValues) {
                              setState(() {
                                _distanceRangeValues = newValues;
                              });
                            },
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 20);
                              },
                              padding:
                                  const EdgeInsets.fromLTRB(10, 26, 10, 26),
                              shrinkWrap: true,
                              itemCount: _filtersList.length,
                              itemBuilder: (context, index) {
                                dynamic _filterTitle = _filtersList[index];

                                return RoundCornerCheckBox(
                                    title: _filtersList[index][
                                        filterListIndex == 5
                                            ? 'name'
                                            : "title"],
                                    textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.85),
                                    ),
                                    value: _filtersMap.containsKey(
                                        "$filterMapKey[${index.toString()}]"),
                                    onCheck: (value) {
                                      setState(() {
                                        value
                                            ? _filtersMap[
                                                    "$filterMapKey[${index.toString()}]"] =
                                                _filterTitle["_id"].toString()
                                            : _filtersMap.remove(
                                                "$filterMapKey[${index.toString()}]");
                                      });

                                      _filtersMap.toString().debugLog();
                                    });
                              },
                            ),
                          ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buttonsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonsWidget() {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(22.0),
          topRight: const Radius.circular(22.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 55,
              child: FlatButton(
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[300], width: 0.5),
                  borderRadius: BorderRadius.circular(
                    Dimens.buttonCornerRadius,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 55,
              child: FancyButton(
                title: 'Apply Filters',
                buttonHeight: 55,
                onPressed: () {
                  Navigator.pop(context, _filtersMap);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rangeSliderWidget(
      String title, RangeValues rangeValues, Function onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
            child: Text(
              rangeValues.start.toStringAsFixed(0) +
                  (title.toLowerCase().contains('distance')
                      ? ' mi. - '
                      : ' yrs - ') +
                  rangeValues.end.toStringAsFixed(0) +
                  (title.toLowerCase().contains('distance') ? ' mi.' : ' yrs'),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.goldenTainoi,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.goldenTainoi,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 20,
                disabledThumbRadius: 20,
              ),
            ),
            child: RangeSlider(
              min: 0,
              max: title.toLowerCase().contains('distance') ? 100 : 50,
              activeColor: AppColors.goldenTainoi,
              values: rangeValues,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }

  Widget filterWidget(RadioModel model) {
    return Container(
      height: 75,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Text(
        model.text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.93),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: BoxDecoration(
        color: model.isSelected ? Colors.white : Colors.transparent,
        // borderRadius: model.isSelected
        //     ? BorderRadius.only(
        //         bottomRight: const Radius.circular(22.0),
        //         topRight: const Radius.circular(22.0),
        //       )
        //     : BorderRadius.all(Radius.zero),
      ),
    );
  }

  void setFilterMapKey(String key) {
    setState(() {
      filterMapKey = key;
    });
  }

  void getSpecialities() {
    setFilterMapKey('specialtyId');
    setLoading(true);

    Map<String, String> map = Map();

    map["professionalTitleId"] =
        _container.projectsResponse['professionalTitleId'];

    _api.getProfessionalSpecility(map).then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _filtersList = value;
        });
      }
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
  }

  void getDegrees() {
    setFilterMapKey('degree');
    setLoading(true);

    _api.getDegrees().then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _filtersList = value;
        });
      }
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
  }

  void getLanguages() {
    setFilterMapKey('language');
    setLoading(true);

    _api.getLanguages().then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _filtersList = value;
        });
      }
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}
