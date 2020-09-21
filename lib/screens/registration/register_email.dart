import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/register.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class RegisterEmail extends StatefulWidget {
  RegisterEmail({Key key}) : super(key: key);

  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final GlobalKey<FormFieldState> _phoneNumberKey = GlobalKey<FormFieldState>();
  final _phoneNumberController = TextEditingController();

  final _mobileFormatter = UsNumberTextInputFormatter();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  bool isLoading = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
            children: getFormWidget(),
            padding: const EdgeInsets.fromLTRB(
                Dimens.padding, 51.0, Dimens.padding, Dimens.padding)),
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
          "Welcome To Hutano",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Please enter your Phone number.\n A 6 digit OTP will be sent to verify your phone number!",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(
      TextFormField(
        key: _phoneNumberKey,
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        validator: Validations.validatePhone,
        inputFormatters: [
          LengthLimitingTextInputFormatter(14),
          WhitelistingTextInputFormatter.digitsOnly,
          _mobileFormatter,
        ],
        autocorrect: true,
        decoration: InputDecoration(
            labelText: "Phone",
            prefix: Text(
              "+1",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(5.0)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(
      FancyButton(
        title: "Next",
        onPressed: isButtonEnable()
            ? () {
                setLoading(true);

                ApiBaseHelper api = new ApiBaseHelper();

                Map<String, String> loginData = Map();
                loginData["phoneNumber"] = Validations.getCleanedNumber(
                    _phoneNumberController.text.toString());
                loginData["type"] = "1";
                loginData["step"] = "1";
                loginData["fullName"] = "user";
                api.register(loginData).then((dynamic user) {
                  setLoading(false);

                  if (user is String) {
                    Widgets.showToast(user.toString());
                    if (user != "User Already exist") {
                      Navigator.pushNamed(
                        context,
                        Routes.verifyOtpRoute,
                        arguments: RegisterArguments(
                            _phoneNumberController.text, false),
                      );
                    }
                  } else {
                    if (user['isContactInformationVerified']) {
                      Navigator.pushNamed(
                        context,
                        Routes.registerRoute,
                        arguments: RegisterArguments(
                            _phoneNumberController.text, false),
                      );
                    } else {
                      Widgets.showToast(
                          'A 6-digit verification number has been sent to your phone.');
                      Navigator.pushNamed(
                        context,
                        Routes.verifyOtpRoute,
                        arguments: RegisterArguments(
                            _phoneNumberController.text, false),
                      );
                    }
                  }
                }).futureError((error) {
                  setLoading(false);
                  error.toString().debugLog();
                });
              }
            : null,
        buttonHeight: Dimens.buttonHeight,
      ),
    );

    return formWidget;
  }

  bool isButtonEnable() {
    return _phoneNumberController.text.isEmpty ||
        !_phoneNumberKey.currentState.validate();
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
