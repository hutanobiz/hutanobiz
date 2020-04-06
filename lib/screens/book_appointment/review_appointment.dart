import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class ReviewAppointmentScreen extends StatefulWidget {
  @override
  _ReviewAppointmentScreenState createState() =>
      _ReviewAppointmentScreenState();
}

class _ReviewAppointmentScreenState extends State<ReviewAppointmentScreen> {
  InheritedContainerState _container;
  Map _appointmentData;
  Map _providerData;
  bool _isLoading = false;
  String _timeHours, _timeMins;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _providerData = _container.getProviderData();
    _appointmentData = _container.appointmentData;

    _timeHours = _appointmentData["time"].substring(0, 2);
    _timeMins = _appointmentData["time"].substring(2, 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Review Appointment",
        color: AppColors.snow,
        isLoading: _isLoading,
        isAddBack: false,
        addBackButton: true,
        buttonColor: AppColors.windsor,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList(),
        ),
        onForwardTap: () {},
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: ProviderWidget(
        data: _providerData["providerData"],
        degree: _providerData["degree"].toString(),
        isOptionsShow: false,
      ),
    ));

    formWidget.add(SizedBox(height: 30.0));

    formWidget.add(container(
        "Date & Time",
        "${DateFormat('EEEE, dd MMMM').format(_appointmentData['date']).toString()} " +
            TimeOfDay(hour: int.parse(_timeHours), minute: int.parse(_timeMins))
                .format(context),
        "ic_calendar"));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(container(
        "Office Address",
        _providerData["providerData"]['businessLocation']['address'] ?? "---",
        "ic_office_address"));

    formWidget.add(Expanded(
      child: Align(
        alignment: FractionalOffset.bottomRight,
        child: Container(
          height: 55.0,
          width: MediaQuery.of(context).size.width - 76.0,
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: FancyButton(
            title: "Send Office Request",
            svgIcon: "ic_send_request",
            buttonColor: AppColors.windsor,
            onPressed: () {
              _loading(true);

              String doctorId =
                  _providerData["providerData"]["userId"]["_id"].toString();

              String startTime = _timeHours + ":" + _timeMins;

              String endTime =
                  (int.parse(_timeHours) + 1).toString() + ":" + _timeMins;

              Map appointmentData = Map();

              appointmentData["type"] =
                  _container.getProjectsResponse()["serviceType"];
              appointmentData["date"] = DateFormat("MM/dd/yyyy")
                  .format(_appointmentData["date"])
                  .toString();

              appointmentData["fromTime"] = startTime;
              appointmentData["toTime"] = endTime;
              appointmentData["doctor"] = doctorId;

              SharedPref().getToken().then((String token) {
                debugPrint(token, wrapWidth: 1024);

                ApiBaseHelper api = ApiBaseHelper();

                api.bookAppointment(token, appointmentData).then((response) {
                  _loading(false);

                  Widgets.showToast("Booking request sent successfully!");
                }).catchError((error) {
                  _loading(false);
                  debugPrint(error.toString(), wrapWidth: 1024);
                });
              });
            },
          ),
        ),
      ),
    ));
    return formWidget;
  }

  Widget container(String heading, String subtitle, String icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              "icon".svgIcon(),
              SizedBox(width: 8.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }
}
