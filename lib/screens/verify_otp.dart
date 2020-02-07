import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/register_email.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:pin_view/pin_view.dart';

class VerifyOTP extends StatefulWidget {
  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String email, otp;
  @override
  Widget build(BuildContext context) {
    final RegisterArguments args = ModalRoute.of(context).settings.arguments;
    email = args.email;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Form(
          child: ListView(
            children: getFormWidget(),
            padding: const EdgeInsets.fromLTRB(
                Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
          ),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());

    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Verify code",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Enter the OTP you received to",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 5.0),
        Text(
          "$email",
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14.0))),
        submit: (String pin) {
          otp = pin;
          print(pin);
        }));

    formWidget.add(
      Padding(
          padding: EdgeInsets.only(top: 40),
          child: FancyButton(
            title: "Verify",
            onPressed: () {
              if (otp != null) {
                ApiBaseHelper api = new ApiBaseHelper();
                Map<String, String> loginData = Map();
                loginData["email"] = email;
                loginData["type"] = "1";
                loginData["step"] = "2";
                loginData["fullName"] = "user";
                loginData["verificationCode"] = otp;

                api.register(loginData).then((dynamic user) {
                  Navigator.pushNamed(
                    context,
                    Routes.registerRoute,
                    arguments: RegisterArguments(email, "user"),
                  );
                });
              }
            },
            buttonHeight: Dimens.buttonHeight,
          )),
    );

    return formWidget;
  }
}
