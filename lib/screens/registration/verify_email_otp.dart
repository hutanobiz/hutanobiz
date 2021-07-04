import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widgets.dart';
import 'package:hutano/widgets/pin_view.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/colors.dart';

class VerifyEmailOTP extends StatefulWidget {
  // final Map args;

  const VerifyEmailOTP({
    Key key,
  }) : super(key: key);

  @override
  _VerifyEmailOTPState createState() => _VerifyEmailOTPState();
}

class _VerifyEmailOTPState extends State<VerifyEmailOTP> {
  String otp;
  String email;
  String phoneNumber;
  ApiBaseHelper api = ApiBaseHelper();
  Future<dynamic> _requestsFuture;

  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = api.profile(token, Map());
      });
      // api.profile(token, Map()).then((dynamic response) {
      //   isLoading = false;
      //   setState(() {
      //     if (response['response'] != null) {
      //       email = response['response']['email'].toString() ?? "---";
      //       phoneNumber = response['response']['phoneNumber']?.toString();
      //     }
      //   });
      // }).futureError((error) {
      //   error.toString().debugLog();
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    // email = widget.args['email'];
    // phoneNumber = widget.args['phoneNumber'];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LoadingBackground(
          padding: EdgeInsets.all(0),
          title: "",
          isAddBack: true,
          child: FutureBuilder<dynamic>(
            future: _requestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: new CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                email = snapshot.data['response']['email'].toString() ?? "---";
                phoneNumber =
                    snapshot.data['response']['phoneNumber']?.toString();
                String emailText;
                emailText = email.substring(0, email.length);

                return Form(
                  child: ListView(
                    children: getFormWidget(emailText),
                    padding: const EdgeInsets.fromLTRB(
                        Dimens.padding, 31.0, Dimens.padding, Dimens.padding),
                  ),
                );
              } else {
                return Center(
                  child: new CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }

  List<Widget> getFormWidget(String phoneText) {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Verify Your Email",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Please enter the verification code sent to your Email Address",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.normal),
        ),
        Widgets.sizedBox(height: 5.0),
        Text(
          "$phoneText",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 44.0));

    formWidget.add(PinView(
        count: 6,
        autoFocusFirstField: true,
        margin: EdgeInsets.all(2.5),
        obscureText: false,
        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w500),
        dashStyle: TextStyle(fontSize: 25.0, color: Colors.grey),
        inputDecoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(14.0)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14.0))),
        submit: (String pin) {
          if (pin.length == 6) {
            setState(() {
              otp = pin;
            });
          } else {
            setState(() {
              otp = null;
            });
          }
          print(pin);
        }));

    formWidget.add(
      Padding(
          padding: EdgeInsets.only(top: 40),
          child: FancyButton(
            title: "Verify",
            onPressed: otp != null
                ? () {
                    ApiBaseHelper api = new ApiBaseHelper();
                    Map<String, String> verifyEmail = Map();

                    verifyEmail["email"] = email;
                    verifyEmail["otp"] = otp;
                    verifyEmail['phoneNumber'] = phoneNumber;

                    api
                        .verifyEmailOtp(context, verifyEmail)
                        .then((dynamic user) {
                      Navigator.of(context).pushReplacementNamed(
                          Routes.emailVerificationComplete);

                        });
                  }
                : null,
            buttonHeight: Dimens.buttonHeight,
          )),
    );

    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(
      FlatButton(
        onPressed: () {
          ApiBaseHelper api = new ApiBaseHelper();
          Map<String, String> verifyEmail = Map();
          verifyEmail["email"] = email;
          verifyEmail['phoneNumber'] = phoneNumber;
          api.sendEmailOtp(context, verifyEmail).then((dynamic response) {
            Widgets.showToast(response["verificationCode"].toString());
          }).futureError((onError) {
            Widgets.showErrorialog(
                title: "Error", context: context, description: "Error!");
          });

          //send otp on email again
        },
        child: Wrap(
          runAlignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              "Didn't receive code? ",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 14.0),
            ),
            Text(
              "Resend",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: AppColors.sunglow,
                  fontSize: 14.0),
            )
          ],
        ),
      ),
    );
    return formWidget;
  }
}
