import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CancelAppointmentScreen extends StatefulWidget {
  const CancelAppointmentScreen({Key key, this.appointmentData})
      : super(key: key);

  final Map appointmentData;

  @override
  _CancelAppointmentScreenState createState() =>
      _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  Map _appointmentData = Map();

  int _radioValue;
  String _selectedReason;

  final List<String> _reasonList = [
    'Booked by mistake.',
    'Clinician did not arrive.',
    'ETA is too long',
    'Found another clinician',
    'Other'
  ];

  TextEditingController _otherReasonController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _otherReasonController.addListener(() {
      setState(() {});
    });

    if (widget.appointmentData != null) {
      _appointmentData = widget.appointmentData;
    }

    _appointmentData.toString().debugLog();
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Cancel Appointment",
        isLoading: _isLoading,
        isAddBack: false,
        addBackButton: true,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 65),
                physics: ClampingScrollPhysics(),
                children: [
                  _container(
                    addBorder: false,
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        _appointmentWidget(_appointmentData),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            'You have been charged a cancellation fee of '
                            '\$20 since your clinician was already on the way.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.65),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Row(
                      children: [
                        Text(
                          'Cancellation Fee',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '\$20',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _reasonWidget(),
                  _selectedReason != null &&
                          _selectedReason.toLowerCase() == 'other'
                      ? Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            scrollPadding: EdgeInsets.only(
                              bottom: 100,
                            ),
                            controller: _otherReasonController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 10,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: "Type something here...",
                              alignLabelWithHint: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: 200.0,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(right: 20.0),
                child: FancyButton(
                  title: 'Done',
                  onPressed: () {
                    if (_selectedReason == null) {
                      Widgets.showErrorDialog(
                          context: context,
                          description: 'Please select a reason');
                      return;
                    } else if (_selectedReason.toLowerCase() == 'other' &&
                        _otherReasonController.text.isEmpty) {
                      Widgets.showErrorDialog(
                        context: context,
                        description: 'Please write a reason',
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    SharedPref().getToken().then((token) {
                      Map appointmentData = Map();

                      appointmentData['appointmentId'] =
                          _appointmentData['data']['_id'];
                      appointmentData['cancellationFees'] = '20';
                      appointmentData['cancelledReason'] = _selectedReason;

                      ApiBaseHelper _api = ApiBaseHelper();

                      _api.cancelAppointment(token, appointmentData).then((v) {
                        setState(() {
                          _isLoading = false;
                        });

                        Widgets.showErrorDialog(
                          context: context,
                          title: 'Cancelled',
                          description: 'Appointment cancelled successfully',
                          onPressed: () => Navigator.popUntil(
                            context,
                            (r) => r.isFirst,
                          ),
                        );
                      }).futureError(
                        (onError) {
                          setState(() {
                            _isLoading = false;
                          });

                          onError.toString().debugLog();
                        },
                      );
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appointmentWidget(Map response) {
    Map _data = response['data'];

    String name = "---",
        avatar,
        address = "---",
        averageRating = "---",
        appointmentType = "---",
        professionalTitle = "---";

    if (_data["type"] != null)
      switch (_data["type"]) {
        case 1:
          appointmentType = "Office Appt.";
          break;
        case 2:
          appointmentType = "Video Chat Appt.";
          break;
        case 3:
          appointmentType = "Onsite Appt.";
          break;
        default:
      }

    averageRating = response["averageRating"]?.toStringAsFixed(2) ?? "0";
    name = _data["doctorName"]?.toString() ?? "---";
    if (response["doctorData"] != null && response["doctorData"].length > 0) {
      dynamic detail = response["doctorData"][0];

      if (detail["businessLocation"] != null) {
        dynamic business = detail["businessLocation"];

        address = Extensions.addressFormat(
          business["address"]?.toString(),
          business["street"]?.toString(),
          business["city"]?.toString(),
          business["state"],
          business["zipCode"]?.toString(),
        );
      }

      if (detail["professionalTitle"] != null) {
        professionalTitle = detail["professionalTitle"]["title"] ?? "---";
        name += Extensions.getSortProfessionTitle(professionalTitle);
      }
    }

    if (_data["type"].toString() == '3') {
      address = Extensions.addressFormat(
        _data["userAddress"]["address"]?.toString(),
        _data["userAddress"]["street"]?.toString(),
        _data["userAddress"]["city"]?.toString(),
        _data["userAddress"]["state"],
        _data["userAddress"]["zipCode"]?.toString(),
      );
    }

    if (_data["doctor"] != null) {
      avatar = _data["doctor"]["avatar"].toString();
    }

    return _container(
      addMargin: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 62.0,
                  height: 62.0,
                  margin: const EdgeInsets.only(top: 14.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: avatar == null
                          ? AssetImage('images/profile_user.png')
                          : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$name",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            "images/ic_star_rating.png",
                            width: 12,
                            height: 12,
                            color: AppColors.goldenTainoi,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            "$averageRating \u2022 $professionalTitle",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        appointmentType,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      "ic_location_grey".imageIcon(width: 11.0),
                      SizedBox(width: 3.0),
                      Expanded(
                        child: Text(
                          "$address",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Row(
                  children: <Widget>[
                    "ic_app_distance".imageIcon(),
                    SizedBox(width: 5.0),
                    Text(
                      Extensions.getDistance(response['distance']),
                      style: TextStyle(
                        color: AppColors.windsor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 14.0),
            child: Row(
              children: <Widget>[
                "ic_appointment_time".imageIcon(height: 12.0, width: 12.0),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    // DateFormat(
                    // 'EEEE, dd MMMM,')
                    //       .format(DateTime.parse(_data['date']))
                    //       .toString() +
                    //   " " +
                    DateFormat('EEEE, dd MMMM, HH:mm')
                            .format(DateTime.utc(
                                    DateTime.parse(_data['date']).year,
                                    DateTime.parse(_data['date']).month,
                                    DateTime.parse(_data['date']).day,
                                    int.parse(_data['fromTime'].split(':')[0]),
                                    int.parse(_data['fromTime'].split(':')[1]))
                                .toLocal())
                            .toString() +
                        ' to ' +
                        DateFormat('HH:mm')
                            .format(DateTime.utc(
                                    DateTime.parse(_data['date']).year,
                                    DateTime.parse(_data['date']).month,
                                    DateTime.parse(_data['date']).day,
                                    int.parse(_data['toTime'].split(':')[0]),
                                    int.parse(_data['toTime'].split(':')[1]))
                                .toLocal())
                            .toString(),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonWidget() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ScrollPhysics(),
      itemCount: _reasonList.length,
      itemBuilder: (context, index) {
        String _reason = _reasonList[index];
        return RadioListTile(
          activeColor: AppColors.windsor,
          groupValue: _radioValue,
          value: index,
          title: Text(
            _reason,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (value) {
            setState(
              () => _radioValue = value,
            );

            _selectedReason = _reasonList[index];
          },
        );
      },
    );
  }

  Widget _container({
    bool addBorder = true,
    Color color,
    Widget child,
    EdgeInsets padding,
    bool addMargin = true,
  }) {
    return Container(
      padding: padding,
      margin: addMargin
          ? const EdgeInsets.fromLTRB(20, 0, 20, 20)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: addBorder ? Border.all(color: Colors.grey[200]) : null,
      ),
      child: child,
    );
  }
}
