import 'package:flutter/material.dart';

class InheritedContainer extends StatefulWidget {
  final Widget child;
  final String data;

  InheritedContainer({@required this.child, this.data});

  static InheritedContainerState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<InheritedStateContainer>()
        .data);
  }

  @override
  InheritedContainerState createState() => new InheritedContainerState();
}

class InheritedContainerState extends State<InheritedContainer> {
  Map _response = Map();
  Map _providerResponse = Map();
  Map appointmentData = Map();
  Map appointmentIdMap = Map();
  Map providerIdMap = Map();
  Map userLocationMap = Map();
  Map consentToTreatMap = Map();
  Map selectServiceMap = Map();
  Map insuranceDataMap = Map();
  List providerInsuranceList = List();

  void setProjectsResponse(String key, String data) {
    _response[key] = data;
  }

  Map getProjectsResponse() {
    return _response;
  }

  void setProviderData(String key, dynamic data) {
    _providerResponse[key] = data;
  }

  void setAppointmentData(String key, dynamic data) {
    appointmentData[key] = data;
  }

  void setProviderId(String providerId) {
    providerIdMap["providerId"] = providerId;
  }

  void setAppointmentId(String appointmentId) {
    appointmentIdMap["appointmentId"] = appointmentId;
  }

  void setUserLocation(String key, dynamic data) {
    userLocationMap[key] = data;
  }

  void setConsentToTreatData(String key, dynamic data) {
    consentToTreatMap[key] = data;
  }

  void setServicesData(String key, dynamic data) {
    selectServiceMap[key] = data;
  }

  void setProviderInsuranceMap(List providerInsuranceList) {
    this.providerInsuranceList = providerInsuranceList;
  }

  void setInsuranceData(String key, dynamic data) {
    insuranceDataMap[key] = data;
  }

  Map getProviderData() {
    return _providerResponse;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedStateContainer extends InheritedWidget {
  final InheritedContainerState data;

  InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedStateContainer oldWidget) =>
      data != oldWidget.data;
}
