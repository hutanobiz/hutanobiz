import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class AddNewUserType extends StatefulWidget {
  final Map? appointmentTypeMap;

  AddNewUserType({Key? key, this.appointmentTypeMap}) : super(key: key);

  @override
  _AddNewUserTypeState createState() => _AddNewUserTypeState();
}

class _AddNewUserTypeState extends State<AddNewUserType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        child: column(context),
        addBottomArrows: false,
        // onForwardTap: () {
        //   // if (selectedType.isNotEmpty) {

        //   // } else {
        //   //   Widgets.showToast(Localization.of(context).noAppointmentSelected);
        //   // }
        // },
      ),
    );
  }

  Widget column(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text('New Account for:',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: fontWeightSemiBold,
                  fontSize: fontSize18)),
        ),
        cardView('Child', 'under 18 years', '1'),
        SizedBox(height: 20.0),
        cardView('Individual', 'over 18', '2'),
      ],
    );
  }

  Widget cardView(String cardText, String subText, String whom) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.addUser, arguments: whom);
          },
          title: Text(
            cardText,
            style: AppTextStyle.boldStyle(fontSize: 16),
          ),
          subtitle: Text(
            subText,
            style: AppTextStyle.regularStyle(fontSize: 13),
          ),
        ));
  }
}
