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
        title: "How do you want to receive care?",
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
          "At the providers office",
          _appointentTypeMap["isOfficeEnabled"],'1'
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/video_chat_appointment.png',
          "Virtually by telemedicine",
          _appointentTypeMap["isVideoChatEnabled"],'2'
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/onsite_appointment.png',
          "In your home or office",
          _appointentTypeMap["isOnsiteEnabled"],'3'
        ),
      ],
    );
  }

  Widget cardView(String image, String cardText, bool isAppointmentTypeTrue,String type) {
    return !isAppointmentTypeTrue
        ? Container()
        : CustomCardView(
            onTap: () {
              conatiner.setProjectsResponse("serviceType", type);

              Navigator.of(context).pushNamed(Routes.selectServicesScreen);
            },
            image: image,
            cardText: cardText,
            fontWeight: FontWeight.bold,
          );
  }
}
