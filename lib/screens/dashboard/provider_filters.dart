import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/filter_radio_model.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';

class ProviderFiltersScreen extends StatefulWidget {
  ProviderFiltersScreen({Key key}) : super(key: key);

  @override
  _ProviderFiltersScreenState createState() => _ProviderFiltersScreenState();
}

class _ProviderFiltersScreenState extends State<ProviderFiltersScreen> {
  InheritedContainerState _container;
  List<dynamic> _professionalTitleList = List();

  List<RadioModel> _filterOptionsList = new List<RadioModel>();
  Map _filtersMap = Map();

  @override
  void initState() {
    super.initState();

    _filterOptionsList.add(RadioModel(true, "Professional Title"));
    _filterOptionsList.add(RadioModel(false, "Speciality"));
    _filterOptionsList.add(RadioModel(false, "Degree"));
    _filterOptionsList.add(RadioModel(false, "Experience"));
    _filterOptionsList.add(RadioModel(false, "Appointment Type"));
    _filterOptionsList.add(RadioModel(false, "Distance"));
    _filterOptionsList.add(RadioModel(false, "Language"));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _professionalTitleList = _container.filterDataMap["professionalTitleList"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Filters",
        isAddBack: false,
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: Row(
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
                      setState(() {
                        _filterOptionsList
                            .forEach((element) => element.isSelected = false);
                        model.isSelected = true;
                      });
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20);
                },
                padding: const EdgeInsets.fromLTRB(10, 26, 10, 26),
                shrinkWrap: true,
                itemCount: _professionalTitleList.length,
                itemBuilder: (context, index) {
                  dynamic _professionalTitle = _professionalTitleList[index];

                  return RoundCornerCheckBox(
                      title: _professionalTitleList[index]["title"],
                      textStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.85),
                      ),
                      value: _filtersMap.containsKey(
                          "professionalTitleId[${index.toString()}]"),
                      onCheck: (value) {
                        setState(() {
                          value
                              ? _filtersMap[
                                      "professionalTitleId[${index.toString()}]"] =
                                  _professionalTitle["_id"].toString()
                              : _filtersMap.remove(
                                  "professionalTitleId[${index.toString()}]");

                          log(_filtersMap.toString());
                        });
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterWidget(RadioModel model) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(20),
      child: Text(model.text),
      decoration: BoxDecoration(
        color: model.isSelected ? Colors.white : Colors.transparent,
        borderRadius: model.isSelected
            ? BorderRadius.only(
                bottomRight: const Radius.circular(22.0),
                topRight: const Radius.circular(22.0),
              )
            : BorderRadius.all(Radius.zero),
      ),
    );
  }
}
