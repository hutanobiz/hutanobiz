import 'package:hutano/colors.dart';
import 'package:hutano/screens/registration/otp_verification/model/verification_model.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/widgets/base_checkbox.dart';
import 'package:hutano/widgets/country_code_picker.dart';
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
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterEmail extends StatefulWidget {
  RegisterEmail({Key key}) : super(key: key);

  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final GlobalKey<FormFieldState> _phoneNumberKey = GlobalKey<FormFieldState>();
  final _phoneNumberController = TextEditingController();

  final _mobileFormatter = UsNumberTextInputFormatter();
  bool isLoading = false;
  String countryCode = '+1';
  bool isTermChecked = false;

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
          "Please enter your mobile number.\nTo verify your mobile number, a 6 digit, one-time password will be sent by text.",
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
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CountryCodePicker(
                        onChanged: ((country) {
                          countryCode = country.dialCode;
                        }),
                        hideMainText: true,
                        showFlagMain: true,
                        initialSelection: 'US',
                        favorite: ['+1', 'US'],
                        showCountryOnly: false,
                        alignLeft: true,
                      ),
                    ),
                    Positioned(
                        right: 4,
                        top: 19,
                        child: Image.asset('images/arrow_bottom_down.png',
                            height: 12))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              key: _phoneNumberKey,
              controller: _phoneNumberController,
              autocorrect: true,
              validator: Validations.validatePhone,
              autovalidate: true,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                _mobileFormatter,
              ],
              maxLength: 14,
              decoration: InputDecoration(
                  isDense: true,
                  counterText: "",
                  labelText: "Phone Number",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(12.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0))),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 20.0));
    formWidget.add(Row(
      children: [
        Expanded(
          child: Wrap(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              Text('I agree to Hutano '),
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ).onClick(onTap: () async {
                var url = 'https://staging.hutano.com/terms-and-conditions';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }),
              //   ],
              // ),
              Text(
                '& Privacy Policy',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ).onClick(onTap: () async {
                var url = 'https://staging.hutano.com/privacy-policy';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              })
            ],
          ),
        ),
        BaseCheckBox(
            activeColor: AppColors.colorYellow,
            value: isTermChecked,
            onChanged: (val) {
              setState(() {
                isTermChecked = !isTermChecked;
              });
            })
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(
      HutanoButton(
        label: "Next",
        onPressed: !isButtonEnable()
            ? () {
                setLoading(true);

                ApiBaseHelper api = new ApiBaseHelper();

                Map<String, String> loginData = Map();
                loginData["phoneNumber"] = Validations.getCleanedNumber(
                    _phoneNumberController.text.toString());
                loginData["type"] = "1";
                api.sendPhoneOtp(context, loginData).then((dynamic user) {
                  setLoading(false);

                  if (user is String) {
                    Widgets.showToast(user.toString());
                    if (user != "user already register with the system") {
                      final args = {
                        ArgumentConstant.verificationModel: VerificationModel(
                            verificationType: VerificationType.phone,
                            email: null,
                            phone: Validations.getCleanedNumber(
                                _phoneNumberController.text.toString()),
                            countryCode: countryCode,
                            verificationScreen:
                                VerificationScreen.registration),
                      };
                      Navigator.of(context).pushNamed(
                          Routes.routePinVerification,
                          arguments: args);
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.verifyOtpRoute,
                      //   arguments: RegisterArguments(
                      //       _phoneNumberController.text, false),
                      // );
                    }
                  } else {
                    if (user['message'] != null) {
                      Widgets.showToast(
                          'A 6-digit verification number has been sent to your phone.');

                      final args = {
                        ArgumentConstant.verificationModel: VerificationModel(
                            verificationType: VerificationType.phone,
                            email: null,
                            phone: Validations.getCleanedNumber(
                                _phoneNumberController.text.toString()),
                            countryCode: countryCode,
                            verificationScreen:
                                VerificationScreen.registration),
                      };
                      Navigator.of(context).pushNamed(
                          Routes.routePinVerification,
                          arguments: args);

                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.verifyOtpRoute,
                      //   arguments: RegisterArguments(
                      //       _phoneNumberController.text, false),
                      // );
                    } else {
                      Navigator.pushReplacementNamed(
                          context, Routes.registerRoute,
                          arguments: RegisterArguments(
                              _phoneNumberController.text, false));
                    }
                  }
                }).futureError((error) {
                  setLoading(false);
                  error.toString().debugLog();
                });
              }
            : null,
        height: Dimens.buttonHeight,
      ),
    );
    formWidget.add(Widgets.sizedBox(height: 42.0));
    formWidget.add(Center(
        child: Text('Help Signing in?').onClick(onTap: () async {
      var url = 'https://staging.hutano.com/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    })));
    formWidget.add(Widgets.sizedBox(height: 16.0));
    formWidget.add(Center(
        child: Text('Hutano data security statement').onClick(onTap: () async {
      var url = 'https://staging.hutano.com/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    })));

    return formWidget;
  }

  bool isButtonEnable() {
    if (!isTermChecked) {
      return true;
    }
    return _phoneNumberController.text.isEmpty ||
        !_phoneNumberKey.currentState.validate();
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
