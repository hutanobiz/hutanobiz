import 'package:flutter/material.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';

import '../../colors.dart';
import '../../routes.dart';

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
          'images/myself.png',
          "MySelf","1",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/myspouse.png',
          "My Spouse","2",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/mychild.png',
          "My Child","3",
        ),
        SizedBox(height: 20.0),
        cardView(
          'images/appointment_other.png',
          "Other","4",
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

  Widget cardView(String image, String cardText,String forType) {
    return CustomCardView(
      onTap: () {
        String type = forType;
        conatiner.setProjectsResponse("appointment_for", type);

        // Navigator.pushNamed(
        //   context,
        //   Routes.providerListScreen,
        // );
      },
      image: image,
      cardText: cardText,
      fontWeight: FontWeight.bold,
    );
  }
}