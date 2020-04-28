import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class SelectServicesScreen extends StatefulWidget {
  @override
  _SelectServicesScreenState createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  Map _providerData;

  InheritedContainerState _container;

  int _radioValue = 0;
  List<Services> servicesList;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    if (_providerData["providerData"]["subServices"] != null ||
        _providerData["providerData"]["subServices"].length > 0) {
      List _serviceList = _providerData["providerData"]["subServices"];

      servicesList = _serviceList.map((m) => Services.fromJson(m)).toList();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Select Services",
        color: AppColors.snow,
        isAddBack: false,
        addBottomArrows: true,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 70.0),
          children: widgetList(),
        ),
        onForwardTap: () {
          if (_radioValue == 1) {
            int totalDuration = 0;
            for (Services services in servicesList) {
              if (services.isSelected) {
                totalDuration += services.duration;
                Navigator.of(context)
                    .pushNamed(Routes.selectAppointmentTimeScreen);
              } else {
                Widgets.showToast("Please choose at least one service");
              }
            }

            log((totalDuration / 60).toString());
          } else
            Navigator.of(context).pushNamed(Routes.selectAppointmentTimeScreen);
        },
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(ProviderWidget(
      data: _providerData["providerData"],
      degree: _providerData["degree"].toString(),
      isOptionsShow: false,
    ));

    formWidget.add(SizedBox(height: 26));

    formWidget.add(consultancyFeeWidget());

    formWidget.add(SizedBox(height: 26));

    formWidget.add(servicesWidget());

    return formWidget;
  }

  Widget consultancyFeeWidget() {
    String fee = "---", duration = "---";

    if (_providerData["providerData"]["consultanceFee"] != null) {
      for (dynamic consultanceFee in _providerData["providerData"]
          ["consultanceFee"]) {
        fee = consultanceFee["fee"].toString() ?? "---";
        duration = consultanceFee["duration"].toString() ?? "---";
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Consultation",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 7),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Fee \$ '),
                    TextSpan(
                      text: '$fee \u2022 ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: 'Duration '),
                    TextSpan(
                      text: '$duration min',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Radio(
                activeColor: AppColors.persian_blue,
                groupValue: _radioValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                onChanged: _handleRadioValueChange,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget servicesWidget() {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _radioValue == 0 ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Choose offered services",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Radio(
                      activeColor: AppColors.persian_blue,
                      groupValue: _radioValue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: 1,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _radioValue == 0
              ? Container()
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: servicesList.length ?? 0,
                  itemBuilder: (context, index) {
                    if (servicesList != null && servicesList.length > 0) {
                      Services services = servicesList[index];
                      return serviceSlotWidget(services);
                    }

                    return Container();
                  }),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return CheckboxListTile(
      dense: false,
      controlAffinity: ListTileControlAffinity.trailing,
      value: services.isSelected,
      activeColor: AppColors.goldenTainoi,
      onChanged: (value) {
        setState(() {
          services.isSelected = value;
        });
      },
      title: Text(
        services.serviceName ?? "---",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Amount \$ ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.amount} \u2022 ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: 'Duration ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.duration} min',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() => _radioValue = value);
  }
}
