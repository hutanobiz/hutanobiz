import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class AppointmentForScreen extends StatefulWidget {
  AppointmentForScreen({Key key}) : super(key: key);

  @override
  _AppointmentForScreenState createState() => _AppointmentForScreenState();
}

class _AppointmentForScreenState extends State<AppointmentForScreen> {
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
          'images/myself.png',
          "MySelf",
          "1",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/myspouse.png',
          "My Spouse",
          "2",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/mychild.png',
          "My Child",
          "3",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/appointment_other.png',
          "Other",
          "4",
        ),
      ],
    );
  }

  Widget cardView(String image, String cardText, String forType) {
    return CustomCardView(
      onTap: () {
        String type = forType;
        conatiner.setProjectsResponse("appointment_for", type);

        Navigator.pushNamed(context, Routes.reviewAppointmentScreen);
      },
      image: image,
      cardText: cardText,
      fontWeight: FontWeight.bold,
    );
  }
}
