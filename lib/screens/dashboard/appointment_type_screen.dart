import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class AppointmentTypeScreen extends StatefulWidget {
  final Map appointmentTypeMap;

  AppointmentTypeScreen({Key key, this.appointmentTypeMap}) : super(key: key);

  @override
  _AppointmentTypeScreenState createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  InheritedContainerState conatiner;
  Map _appointentTypeMap = {};

  @override
  void initState() {
    super.initState();

    _appointentTypeMap["isOfficeEnabled"] = true;
    _appointentTypeMap["isVideoChatEnabled"] = true;
    _appointentTypeMap["isOnsiteEnabled"] = true;

    if (widget.appointmentTypeMap != null) {
      _appointentTypeMap = widget.appointmentTypeMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);

    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Book Your Service",
        color: AppColors.snow,
        isAddBack: false,
        addBackButton: true,
        child: column(),
      ),
    );
  }

  Widget column() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        cardView(
          'images/office_appointment.png',
          "Office Appointment",
          _appointentTypeMap["isOfficeEnabled"],
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/video_chat_appointment.png',
          "Video Chat Appointment",
          _appointentTypeMap["isVideoChatEnabled"],
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/onsite_appointment.png',
          "Onsite Appointment",
          _appointentTypeMap["isOnsiteEnabled"],
        ),
      ],
    );
  }

  Widget cardView(String image, String cardText, bool isAppointmentTypeTrue) {
    return !isAppointmentTypeTrue
        ? Container()
        : CustomCardView(
            onTap: () {
              String type;
              if (cardText.toLowerCase().contains("office")) {
                type = "1";
              } else if (cardText.toLowerCase().contains("video")) {
                type = "2";
              } else {
                type = "3";
              }

              conatiner.setProjectsResponse("serviceType", type);

              Navigator.of(context).pushNamed(Routes.selectServicesScreen);
            },
            image: image,
            cardText: cardText,
            fontWeight: FontWeight.bold,
          );
  }
}
