import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';

class AvailableTimingsScreen extends StatefulWidget {
  @override
  _AvailableTimingsScreenState createState() => _AvailableTimingsScreenState();
}

class _AvailableTimingsScreenState extends State<AvailableTimingsScreen> {
  Map _providerData;

  InheritedContainerState _container;

  Map profileMap = Map();

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Available Timings",
        color: AppColors.snow,
        isAddBack: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 70.0),
          children: widgetList(),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    if (_providerData["providerData"]["data"] != null) {
      if (_providerData["providerData"]["data"] is List) {
        _providerData["providerData"]["data"].map((f) {
          profileMap.addAll(f);
        }).toList();
      } else {
        profileMap = _providerData["providerData"]["data"];
      }
    } else {
      profileMap = _providerData["providerData"];
    }

    formWidget.add(ProviderWidget(
      data: profileMap,
      degree: _providerData["degree"].toString(),
      isOptionsShow: false,
    ));

    formWidget.add(SizedBox(height: 26));

    formWidget.add(timingWidget());

    return formWidget;
  }

  Widget timingWidget() {
    return Row(
      children: <Widget>[],
    );
  }
}
