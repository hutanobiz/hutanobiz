import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class Customer {
  String? name;
  List<Services> services;

  Customer(this.name, this.services);

  @override
  String toString() {
    return '{ ${this.name}, ${this.services} }';
  }
}

class SelectServicesScreen extends StatefulWidget {
  @override
  _SelectServicesScreenState createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  late Map _providerData;

  late InheritedContainerState _container;

  int? _radioValue = 0;
  String? _selectedAppointmentType = '1', _appointmentTypeKey;
  late List<Services> servicesList;
  Map<String?, Services> _selectedServicesMap = Map();
  List? _serviceList;
  Map? profileMap = Map();
  List<Customer> groupList = [];

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    if (_container.projectsResponse != null) {
      _selectedAppointmentType =
          _container.projectsResponse['serviceType']?.toString() ?? '0';

      switch (_selectedAppointmentType) {
        case '1':
          _appointmentTypeKey = 'officeConsultanceFee';
          break;
        case '2':
          _appointmentTypeKey = 'vedioConsultanceFee';
          break;
        case '3':
          _appointmentTypeKey = 'onsiteConsultanceFee';
          break;
        default:
      }
    }

    if (_providerData["providerData"]["subServices"] != null) {
      if (_providerData["providerData"]["subServices"] is List) {
        _serviceList = _providerData["providerData"]["subServices"];
      }
    } else if (_providerData["providerData"]["services"] != null) {
      if (_providerData["providerData"]["services"] is List) {
        _serviceList = _providerData["providerData"]["services"];
      }
    } else if (_providerData["subServices"] != null) {
      if (_providerData["subServices"] is List) {
        _serviceList = _providerData["subServices"];
      }
    }

    if (_serviceList != null) {
      _serviceList = _serviceList!
          .where((e) => e['serviceType'].toString() == _selectedAppointmentType)
          .toList();

      servicesList = _serviceList!.map((m) => Services.fromJson(m)).toList();
    }

    var groupMap = groupBy(servicesList, (dynamic obj) => obj.serviceName);

    groupMap.forEach((k, v) => groupList.add(Customer(k, v)));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "Select Services",
        color: AppColors.snow,
        isAddBack: false,
        addHeader: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 70.0),
                children: widgetList(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ArrowButton(
                iconData: Icons.arrow_forward,
                onTap: () {
                  if (_radioValue == 1) {
                    if (_selectedServicesMap.values.toList().length > 0) {
                      _container.setServicesData("status", "1");
                      _container.setServicesData(
                          "services", _selectedServicesMap.values.toList());

                      Navigator.of(context).pushNamed(
                          Routes.selectAppointmentTimeScreen,
                          arguments: SelectDateTimeArguments(fromScreen: 0));
                    } else {
                      Widgets.showToast("Please choose at least one service");
                    }
                  } else {
                    _container.setServicesData("status", "0");
                    _container.setServicesData(
                        "consultaceFee", profileMap![_appointmentTypeKey]);
                    Navigator.of(context).pushNamed(
                        Routes.selectAppointmentTimeScreen,
                        arguments: SelectDateTimeArguments(fromScreen: 0));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = [];
    String averageRating = "0";

    if (_providerData["providerData"]["data"] != null) {
      if (_providerData["providerData"]["data"] is List) {
        _providerData["providerData"]["data"].map((f) {
          profileMap!.addAll(f);
        }).toList();
      } else {
        profileMap = _providerData["providerData"]["data"];
      }

      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(1) ??
              "0";
    } else {
      profileMap = _providerData["providerData"];
      averageRating = profileMap!["averageRating"]?.toStringAsFixed(1) ?? "0";
    }

    formWidget.add(ProviderWidget(
      data: profileMap,
      selectedAppointment:
          _container.projectsResponse['serviceType'].toString(),
      isOptionsShow: false,
      averageRating: averageRating,
    ));

    formWidget.add(SizedBox(height: 26));

    formWidget.add(consultancyFeeWidget());

    formWidget.add(SizedBox(height: 26));

    formWidget
        .add(_selectedAppointmentType == '2' ? SizedBox() : servicesWidget());

    return formWidget;
  }

  Widget consultancyFeeWidget() {
    String fee = "0.00", duration = "0";

    if (profileMap![_appointmentTypeKey] != null &&
        profileMap![_appointmentTypeKey].length > 0) {
      fee = profileMap![_appointmentTypeKey][0]['fee'].toStringAsFixed(2) ??
          '0.00';
      duration = profileMap![_appointmentTypeKey][0]['duration'].toString();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100]!,
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Localization.of(context)!.consultationLabel,
                  style: TextStyle(
                    fontSize: fontSize16,
                    color: colorBlack2,
                    fontWeight: fontWeightBold,
                  ),
                ),
                SizedBox(height: 7),
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'Amount \$',
                      style: TextStyle(
                          fontSize: fontSize13,
                          fontWeight: fontWeightMedium,
                          color: colorBlack2)),
                  TextSpan(
                      text: '$fee \u2022 ',
                      style: TextStyle(
                          fontSize: fontSize13,
                          fontWeight: fontWeightSemiBold,
                          color: colorBlack2)),
                  TextSpan(
                      text: Localization.of(context)!.durationLabel,
                      style: TextStyle(
                          fontSize: fontSize13,
                          fontWeight: fontWeightMedium,
                          color: colorBlack2)),
                  TextSpan(
                      text: '$duration min',
                      style: TextStyle(
                          fontSize: fontSize13,
                          fontWeight: fontWeightSemiBold,
                          color: colorBlack2))
                ]))
              ]),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Radio(
                activeColor: AppColors.windsor,
                groupValue: _radioValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                onChanged: _handleRadioValueChange,
              ),
            ),
          )
        ],
      ),
    ).onClick(
      onTap: () => _handleRadioValueChange(0),
    );
  }

  Widget servicesWidget() {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100]!,
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
                        fontSize: fontSize16,
                        color: colorBlack2,
                        fontWeight: fontWeightBold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(Localization.of(context)!.chooseOfferedServices,
                        style: TextStyle(
                            fontSize: fontSize13,
                            fontWeight: fontWeightMedium,
                            color: colorBlack2)),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Radio(
                      activeColor: AppColors.windsor,
                      groupValue: _radioValue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: 1,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                ),
              ],
            ),
          ).onClick(
            onTap: () => _handleRadioValueChange(1),
          ),
          _radioValue == 0
              ? Container()
              : groupList != null && groupList.length > 0
                  ? ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groupList.length,
                      itemBuilder: (context, index) {
                        if (groupList != null && groupList.length > 0) {
                          return ExpansionTile(
                            title: Text(
                              groupList[index].name!,
                              style: TextStyle(
                                fontSize: fontSize16,
                                color: colorBlack2,
                                fontWeight: fontWeightSemiBold,
                              ),
                            ),
                            children: [
                              ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                            height: 10,
                                          ),
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: groupList[index].services.length,
                                  itemBuilder: (context, itemIndex) {
                                    Services services =
                                        groupList[index].services[itemIndex];
                                    return serviceSlotWidget(services);
                                  })
                            ],
                          );
                        }

                        return Container();
                      })
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(20),
                      child: Text("NO services available"),
                    ),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return CheckboxListTile(
      dense: false,
      controlAffinity: ListTileControlAffinity.trailing,
      value: _selectedServicesMap.containsKey(services.subServiceId),
      activeColor: AppColors.goldenTainoi,
      onChanged: (value) {
        value!
            ? _selectedServicesMap[services.subServiceId] = services
            : _selectedServicesMap.remove(services.subServiceId);

        setState(() {});
      },
      title: Text(
        services.subServiceName ?? "---",
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
              text: 'Amount \$',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.amount.toStringAsFixed(2)} \u2022 ',
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

  void _handleRadioValueChange(int? value) {
    setState(() => _radioValue = value);

    if (value == 0) {
      _selectedServicesMap.clear();
    }
  }
}
