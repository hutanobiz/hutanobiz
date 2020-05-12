import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';

class ConsentToTreatScreen extends StatefulWidget {
  ConsentToTreatScreen({Key key}) : super(key: key);

  @override
  _ConsentToTreatScreenState createState() => _ConsentToTreatScreenState();
}

class _ConsentToTreatScreenState extends State<ConsentToTreatScreen> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Consent to Treat",
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          isAgree
              ? Navigator.of(context).pushNamed(Routes.medicalHistoryScreen)
              : Widgets.showToast("Please agree to continue");
        },
        color: Colors.white,
        child: ListView(
          children: widgetList(),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(Column(
      children: <Widget>[],
    ));
    formWidget.add(Text(
      "This is to certify that I, Nathan Makuve, as an adult participant give my consent to a provider on Hutano’s platform and its medical representative to provide medical care for the medical condition stated here. I certify that all the information provided here is true and provided by me or a representative under my direction. I certify that I am at least 18 years of age. I understand and agree that I am financially responsible for the care provided by the Hutano provider. I understand that medical services provided by the may qualify for insurance reimbursement. I understand that it will be my responsibility and provider to file insurance claims with my insurance company. I agree to have Hutano LLC charge my credit card on behalf of the provider for services that are not covered by my insurance provider for the amount agreed upon.",
      style: TextStyle(
        fontSize: 14.0,
      ),
    ));

    formWidget.add(SizedBox(height: 45));

    formWidget.add(Center(
      child: RoundCornerCheckBox(
        title: "I Agree",
        value: isAgree,
        onCheck: () => setState(() => isAgree = !isAgree),
      ),
    ));

    return formWidget;
  }
}
