import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/round_corner_checkbox.dart';
import 'package:hutano/widgets/widgets.dart';

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
  String name, nameTitle;

  @override
  void initState() {
    SharedPref().getToken().then((token) {
      setState(() {
        // _requestsConsent = api.getConsentContent(token);
      });
    });
    SharedPref()
        .getValue("fullName")
        .then((value) => setState(() => _name = value ?? "---"));
    super.initState();
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    var _container = InheritedContainer.of(context);
    userId = _container.providerResponse['providerData']['_id'];

    if (_container.providerResponse['providerData']["userId"] != null &&
        _container.providerResponse['providerData']["userId"] is Map) {
      nameTitle = _container.providerResponse['providerData']["userId"]["title"]
              ?.toString() ??
          'Dr. ';
      name = nameTitle +
              _container.providerResponse['providerData']["userId"]["fullName"]
                  ?.toString() ??
          "---";
    } else if (_container.providerResponse['providerData']['data'][0]["User"] !=
        null is Map) {
      nameTitle = (_container.providerResponse['providerData']['data'][0]
                  ["User"][0]["title"]
              ?.toString() ??
          'Dr. ');
      name = '$nameTitle ' +
          (_container.providerResponse['providerData']['data'][0]["User"][0]
                      ["fullName"]
                  ?.toString() ??
              "---");
    }

    print(_container);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "Consent to Treat",
        addHeader: true,
        addBottomArrows: true,
        padding: EdgeInsets.only(
            left: spacing20, right: spacing20, bottom: spacing60),
        onForwardTap: () {
          //TODO : REFACTOR CODE. COMMENTING CURRNET API AND USING ANOTHER
          // isAgree
          //     ? Navigator.of(context).pushNamed(Routes.medicalHistoryScreen)
          //     : Widgets.showToast("Please agree to continue");

          // Provider.of<SymptomsInfoProvider>(context, listen: false)
          //     .setAppoinmentData(userId, getString(PreferenceKey.id));

          // Navigator.of(context).pushNamed(routeMyMedicalHistory)
          isAgree
              ? Navigator.of(context)
                  .pushNamed(Routes.medicalHistoryScreen, arguments: true)
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
    // String text =
    //     _responseData['textString'].toString().replaceAll("\$_name", _name);
    List<Widget> formWidget = new List();

    formWidget.add(Column(
      children: <Widget>[],
    ));
    formWidget.add(_consentToTreatHeader(context));
    formWidget.add(Text(
        "I, $_name, certify that I am an adult over the age of 18 and as such, do hereby willingly agree to receive medical care by $name. I understand and agree that I will participate in my treatment plan and I may discontinue treatment and/or withdraw my consent for treatment at any time. \n\nI voluntarily consent to the rendering of healthcare including diagnostic procedures, and medical treatment by the provider and/or the provider's authorized designees. \n\nIn the event that I am injured or ill while under the care of the provider, I hereby give permission to the provider to provide first aid and take appropriate measures including contacting Emergency Medical Services (EMS) and arranging transportation to the nearest emergency medical facility.  ",
        style: TextStyle(
          color: colorBlack2,
          fontSize: fontSize14,
          fontWeight: fontWeightRegular,
          letterSpacing: -0.14,
        )));

    formWidget.add(SizedBox(height: 45));

    formWidget.add(Center(
      child: RoundCornerCheckBox(
        title: Localization.of(context).iAgreeLabel,
        value: isAgree,
        onCheck: (value) => setState(() => isAgree = !isAgree),
      ),
    ));

    return formWidget;
  }

  Widget _consentToTreatHeader(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).consentToTreatHeader,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );
}
