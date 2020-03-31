import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class AppointmentTypeScreen extends StatefulWidget {
  AppointmentTypeScreen({Key key}) : super(key: key);

  @override
  _AppointmentTypeScreenState createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  InheritedContainerState conatiner;

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
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/video_chat_appointment.png',
          "Video Chat Appointment",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/onsite_appointment.png',
          "Onsite Appointment",
        ),
      ],
    );
  }

  Widget cardView(String image, String cardText) {
    return CustomCardView(
      onTap: () {
        String type;
        if (cardText.contains("office")) {
          type = "1";
        } else if (cardText.toLowerCase().contains("video")) {
          type = "2";
        } else {
          type = "3";
        }

        conatiner.setProjectsResponse("serviceType", type);

        if (conatiner.getProjectsResponse().length < 3)
          Navigator.of(context).pushNamed(Routes.selectAppointmentTimeScreen);
        else
          Navigator.pushNamed(context, Routes.providerListScreen);
      },
      image: image,
      cardText: cardText,
      fontWeight: FontWeight.bold,
    );
  }
}
