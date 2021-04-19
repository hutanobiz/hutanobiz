import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/src/ui/medical_history/provider/appoinment_provider.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConsentToTreatScreen extends StatefulWidget {
  ConsentToTreatScreen({Key key}) : super(key: key);

  @override
  _ConsentToTreatScreenState createState() => _ConsentToTreatScreenState();
}

class _ConsentToTreatScreenState extends State<ConsentToTreatScreen> {
  bool isAgree = false;
  String _name = "";

  dynamic _responseData;
  ApiBaseHelper api = ApiBaseHelper();
  Future<dynamic> _requestsConsent;
  dynamic response;
  bool isInitialLoad = false;
  bool isLoading = false;
  String userId;

  @override
  void initState() {
    SharedPref().getToken().then((token) {
      setState(() {
        // _requestsConsent = api.getConsentContent(token);
      });
    });
    super.initState();
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    var _container = InheritedContainer.of(context);
    userId = _container.providerResponse["providerData"]["userId"];
    print(_container);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Consent to Treat",
        isAddBack: false,
        addHeader: true,
        addTitle: true,
        addBottomArrows: true,
        onForwardTap: () {
          //TODO : REFACTOR CODE. COMMENTING CURRNET API AND USING ANOTHER
          // isAgree
          //     ? Navigator.of(context).pushNamed(Routes.medicalHistoryScreen)
          //     : Widgets.showToast("Please agree to continue");

          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .setAppoinmentData(userId, getString(PreferenceKey.id));

          // Navigator.of(context).pushNamed(routeMyMedicalHistory)
          isAgree
              ? Navigator.of(context).pushNamed(Routes.medicalHistoryScreen)
              : Widgets.showToast("Please agree to continue");
        },
        color: Colors.white,
        child: FutureBuilder<dynamic>(
          future: _requestsConsent,
          builder: (context, snapshot) {
            return ListView(
              children: widgetList(),
            );
            // if (snapshot.hasData) {
            //   if (isInitialLoad) {
            //     response = snapshot.data;
            //     isInitialLoad = false;
            //   }
            //   if (response is String) {
            //     return Center(child: Text(response));
            //   } else {
            //     _responseData = response;
            //     return ListView(
            //       children: widgetList(),
            //     );
            //   }
            // } else if (snapshot.hasError) {
            //   return Text("${snapshot.error}");
            // } else {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
          },
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    SharedPref()
        .getValue("fullName")
        .then((value) => setState(() => _name = value ?? "---"));

    // String text =
    //     _responseData['textString'].toString().replaceAll("\$_name", _name);
    List<Widget> formWidget = new List();

    formWidget.add(Column(
      children: <Widget>[],
    ));
    formWidget.add(Text(
      // text,
      "This is to certify that I, $_name, as an adult participant give my consent to a provider on Hutano’s platform and its medical representative to provide medical care for the medical condition stated here. I certify that all the information provided here is true and provided by me or a representative under my direction. I certify that I am at least 18 years of age. I understand and agree that I am financially responsible for the care provided by the Hutano provider. I understand that medical services provided by the may qualify for insurance reimbursement. I understand that it will be my responsibility and provider to file insurance claims with my insurance company. I agree to have Hutano LLC charge my credit card on behalf of the provider for services that are not covered by my insurance provider for the amount agreed upon.",
      style: TextStyle(
        fontSize: 14.0,
      ),
    ));

    formWidget.add(SizedBox(height: 45));

    formWidget.add(Center(
      child: RoundCornerCheckBox(
        title: "I consent to treatment",
        value: isAgree,
        onCheck: (value) => setState(() => isAgree = !isAgree),
      ),
    ));

    return formWidget;
  }
}
