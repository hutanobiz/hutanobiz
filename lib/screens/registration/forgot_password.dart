import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/register.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormFieldState> _phoneNumberKey = GlobalKey<FormFieldState>();
  final _phoneNumberController = TextEditingController();

  bool isLoading = false;

  final _mobileFormatter = UsNumberTextInputFormatter();

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
      resizeToAvoidBottomInset: false,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
          physics: new ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
              Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
          children: getFormWidget(),
        ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());
    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Forgot Password",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Please enter your phone number address.\nWe will send you link to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.normal),
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
          prefixIcon: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset('images/login_phone.png', height: 16),
              ),
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
        title: "Confirm",
        onPressed: isButtonEnable()
            ? () {
                setLoading(true);

                ApiBaseHelper api = new ApiBaseHelper();
                Map<String, String> loginData = Map();
                String phonenumber = _phoneNumberController.text.substring(1, 4) +
                    "" +
                    _phoneNumberController.text.substring(6, 9) +
                    "" +
                    _phoneNumberController.text.substring(10, 14);
                loginData["phoneNumber"] =
                    phonenumber;
                loginData["step"] = "1";
                api.resetPassword(loginData).then((dynamic user) {
                  setLoading(false);

                  Widgets.showToast(user.toString());

                  Navigator.pushNamed(
                    context,
                    Routes.verifyOtpRoute,
                    arguments: RegisterArguments(
                        phonenumber,
                        
                        true),
                  );
                }).futureError((error) {
                  setLoading(false);
                  error.toString().debugLog();
                });
              }
            : null,
        buttonHeight: Dimens.buttonHeight,
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 13.0));

    formWidget.add(
      FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: AppColors.windsor,
              size: 17.0,
            ),
            SizedBox(width: 5.0),
            Text(
              "Return to Log In.",
              style: TextStyle(color: AppColors.windsor, fontSize: 14.0),
            )
          ],
        ),
      ),
    );

    return formWidget;
  }

  bool isButtonEnable() {
    if (_phoneNumberController.text.isEmpty ||
        !_phoneNumberKey.currentState.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
