import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(top: 51.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(22.0),
              topRight: const Radius.circular(22.0),
            ),
          ),
          child: column(),
        ),
      ),
    );
  }

  Widget column() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Book Your Service",
            style: TextStyle(
                color: AppColors.midnight_express,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20.0),
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
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomLeft,
            child: ArrowButton(
              iconData: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
          ),
        )
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

        Navigator.pushNamed(
          context,
          Routes.providerListScreen,
        );
      },
      image: image,
      cardText: cardText,
      fontWeight: FontWeight.bold,
    );
  }
}
