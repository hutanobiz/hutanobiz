import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/pin_view.dart';
import 'package:hutano/widgets/widgets.dart';

class VerifyOTP extends StatefulWidget {
  final RegisterArguments args;

  const VerifyOTP({Key key, @required this.args}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String cleanedPhoneNumber, phoneNumber, otp;
  bool isForgot;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    phoneNumber = widget.args.phoneNumber;
    cleanedPhoneNumber = Validations.getCleanedNumber(widget.args.phoneNumber);
    isForgot = widget.args.isForgot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
          children: getFormWidget(),
          padding: const EdgeInsets.fromLTRB(
              Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Verify your mobile number",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Enter the one-time password sent to",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.normal),
        ),
        Widgets.sizedBox(height: 5.0),
        Text(
          "+1 $phoneNumber",
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
            counterText: "",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(14.0)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14.0))),
        submit: (String pin) {
          setState(() {
            if (pin.length == 6) {
              otp = pin;
            } else {
              otp = null;
            }
          });

          print(pin);
        }));

    formWidget.add(
      Padding(
          padding: EdgeInsets.only(top: 40),
          child: FancyButton(
            title: "Verify",
            onPressed: otp != null
                ? () {
                    setLoading(true);

                    ApiBaseHelper api = new ApiBaseHelper();
                    Map<String, String> loginData = Map();

                    if (isForgot) {
                      loginData["phoneNumber"] = cleanedPhoneNumber;
                      loginData["step"] = "2";
                      loginData["verificationCode"] = otp;
                      api.resetPassword(loginData).then((dynamic user) {
                        setLoading(false);

                        Widgets.showToast(user.toString());

                        Navigator.pushNamed(
                          context,
                          Routes.resetPasswordRoute,
                          arguments: RegisterArguments(phoneNumber, false),
                        );
                      }).futureError((error) {
                        setLoading(false);
                        error.toString().debugLog();
                      });
                    } else {
                      loginData["phoneNumber"] = cleanedPhoneNumber;
                      loginData["type"] = "1";
                      loginData["verificationCode"] = otp;

                      api
                          .verifyPhoneOtp(context, loginData)
                          .then((dynamic user) {
                        setLoading(false);
                        Widgets.showToast("Verified successfully");

                        Navigator.pushReplacementNamed(
                            context, Routes.registerRoute,
                            arguments: RegisterArguments(phoneNumber, false));
                      }).futureError((error) {
                        setLoading(false);
                        error.toString().debugLog();
                      });
                    }
                  }
                : null,
            buttonHeight: Dimens.buttonHeight,
          )),
    );

    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(
      FlatButton(
        onPressed: () {
          setLoading(true);
          ApiBaseHelper api = new ApiBaseHelper();

          Map<String, String> loginData = Map();
          if (isForgot) {
            loginData["phoneNumber"] = cleanedPhoneNumber;
            loginData["step"] = "1";
            api.resetPassword(loginData).then((dynamic user) {
              setLoading(false);
              Widgets.showToast(user.toString());
            }).futureError((error) {
              setLoading(false);
              error.toString().debugLog();
            });
          } else {
            loginData["phoneNumber"] = cleanedPhoneNumber;
            loginData["type"] = "1";
            api.resendPhoneOtp(context, loginData).then((dynamic user) {
              setLoading(false);

              Widgets.showToast(
                  'A 6-digit verification number has been re-sent to your phone.');
            }).futureError((error) {
              setLoading(false);
              error.toString().debugLog();
            });
          }
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

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
