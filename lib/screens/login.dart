
// import 'package:hutano/text_style.dart';
// import 'package:hutano/utils/argument_const.dart';
// import 'package:hutano/utils/color_utils.dart';
// import 'package:hutano/utils/enum_utils.dart';
// import 'package:hutano/widgets/country_code_picker.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hutano/apis/api_helper.dart';
// import 'package:hutano/colors.dart';
// import 'package:hutano/routes.dart';
// import 'package:hutano/screens/registration/register.dart';
// import 'package:hutano/strings.dart';
// import 'package:hutano/utils/dimens.dart';
// import 'package:hutano/utils/extensions.dart';
// import 'package:hutano/utils/shared_prefrences.dart';
// import 'package:hutano/utils/validations.dart';
// import 'package:hutano/widgets/app_logo.dart';
// import 'package:hutano/widgets/hutano_button.dart';
// import 'package:hutano/widgets/loading_widget.dart';
// import 'package:hutano/widgets/password_widget.dart';
// import 'package:hutano/widgets/widgets.dart';

// class LoginScreen extends StatefulWidget {
//   LoginScreen({Key key, this.isBack = false}) : super(key: key);
//   final bool isBack;
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<LoginScreen> {
//   Map<String, String> _loginDataMap = Map();

//   final GlobalKey<FormFieldState> _phoneNumberKey = GlobalKey<FormFieldState>();
//   final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();

//   final _mobileFormatter = UsNumberTextInputFormatter();
//   String countryCode = '+1';
//   bool checked = false;
//   bool _obscureText = true;
//   bool isLoading = false;

//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     _passwordController.dispose();

//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//     _firebaseMessaging.getToken().then((String token) {
//       SharedPref().setValue("deviceToken", token);
//       print(token);
//     });

//     _phoneNumberController.addListener(() {
//       setState(() {});
//     });

//     _passwordController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: LoadingView(
//         isLoading: isLoading,
//         child: ListView(
//           physics: new ClampingScrollPhysics(),
//           padding: const EdgeInsets.fromLTRB(
//               Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
//           children: widgetList(),
//         ),
//       ),
//     );
//   }

//   Widget _getSignInTextField() => Container(
//         padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//         child: Text(Strings.signInTitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: colorBlack85,
//             )),
//       );

//   List<Widget> widgetList() {
//     List<Widget> formWidget = new List();

//     formWidget.add(
//       AppLogo(),
//     );
//     formWidget.add(
//       _getSignInTextField(),
//     );
//     formWidget.add(SizedBox(height: 50));

//     formWidget.add(
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 50,
//                 width: 60,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   border: Border.all(
//                     color: Colors.grey[300],
//                     width: 1.0,
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: CountryCodePicker(
//                         onChanged: ((country) {
//                           countryCode = country.dialCode;
//                         }),

//                         hideMainText: true,
//                         showFlagMain: true,
//                         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                         initialSelection: 'US',
//                         favorite: ['+1', 'US'],

//                         // optional. Shows only country name and flag
//                         showCountryOnly: false,
//                         // optional. Shows only country name and flag when popup is closed.
//                         //  showOnlyCountryWhenClosed: false,

//                         // optional. aligns the flag and the Text left
//                         alignLeft: true,
//                       ),
//                     ),
//                     Positioned(
//                         right: 4,
//                         top: 19,
//                         child: Image.asset('images/arrow_bottom_down.png',
//                             height: 12))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: TextFormField(
//               key: _phoneNumberKey,
//               controller: _phoneNumberController,
//               autocorrect: true,
//               validator: Validations.validatePhone,
//               autovalidateMode: AutovalidateMode.always,
//               inputFormatters: [
//                 WhitelistingTextInputFormatter.digitsOnly,
//                 _mobileFormatter,
//               ],
//               maxLength: 14,
//               decoration: InputDecoration(
//                   isDense: true,
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Image.asset('images/login_phone.png', height: 16),
//                   ),
//                   counterText: "",
//                   //  prefixText: countryCode,
//                   labelText: "Phone Number",
//                   labelStyle: AppTextStyle.regularStyle(
//                     fontSize: 14,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey[300]),
//                       borderRadius: BorderRadius.circular(12.0)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0))),
//               keyboardType: TextInputType.phone,
//             ),
//           ),
//         ],
//       ),
//     );
//     formWidget.add(Widgets.sizedBox(height: 30.0));
//     formWidget.add(PasswordTextField(
//       isDense: true,
//       passwordKey: _passwordKey,
//       validator: Validations.validateLoginPassword,
//       obscureText: _obscureText,
//       labelText: Strings.passwordText,
//       passwordController: _passwordController,
//       style: AppTextStyle.regularStyle(fontSize: 14),
//       prefixIcon: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Image.asset('images/lock.png', height: 12),
//       ),
//       suffixIcon: GestureDetector(
//         dragStartBehavior: DragStartBehavior.down,
//         onTap: () {
//           setState(() {
//             _obscureText = !_obscureText;
//           });
//         },
//         child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
//             color: Colors.grey),
//       ),
//     ));
//     formWidget.add(Widgets.sizedBox(height: 5.0));

//     formWidget.add(Align(
//       alignment: Alignment.centerRight,
//       child: FlatButton(
//           onPressed: () => Navigator.pushNamed(
//                   context, Routes.routeForgotPassword, arguments: {
//                 ArgumentConstant.verificationScreen:
//                     VerificationScreen.resetPassword
//               }),
//           child: Text(
//             "Forgot Password?",
//             style: AppTextStyle.regularStyle(
//                 color: AppColors.windsor, fontSize: 12.0),
//           )),
//     ));

//     formWidget.add(Widgets.sizedBox(height: 16.0));
//     formWidget.add(HutanoButton(
//       height: Dimens.buttonHeight,
//       label: Strings.logIn,
//       onPressed: isButtonEnable()
//           ? () {
//               SharedPref().getValue("deviceToken").then((value) {
//                 String phonenumber =
//                     _phoneNumberController.text.substring(1, 4) +
//                         "" +
//                         _phoneNumberController.text.substring(6, 9) +
//                         "" +
//                         _phoneNumberController.text.substring(10, 14);
//                 _loginDataMap["phoneNumber"] = phonenumber;
//                 _loginDataMap["deviceToken"] = value;
//                 _loginDataMap["password"] = _passwordController.text.toString();
//                 _loginDataMap["type"] = "1";

//                 onLoginApi();
//               });
//             }
//           : null,
//     ));

//     formWidget.add(Widgets.sizedBox(height: 13.0));

//     formWidget.add(
//       FlatButton(
//         onPressed: () {
//           Navigator.pushNamed(context, Routes.registerEmailRoute);
//         },
//         child: Wrap(
//           runAlignment: WrapAlignment.center,
//           children: <Widget>[
//             Text(
//               "Don't have an account?",
//               style: AppTextStyle.regularStyle(
//                   fontWeight: FontWeight.normal,
//                   color: Colors.black,
//                   fontSize: 14.0),
//             ),
//             SizedBox(width: 2.0),
//             Text(
//               "Register",
//               style: AppTextStyle.regularStyle(
//                   fontWeight: FontWeight.normal,
//                   color: AppColors.sunglow,
//                   fontSize: 14.0),
//             )
//           ],
//         ),
//       ),
//     );

//     formWidget.add(Widgets.sizedBox(height: 42.0));

//     return formWidget;
//   }

//   void onLoginApi() {
//     ApiBaseHelper api = ApiBaseHelper();

//     setLoading(true);

//     api.login(_loginDataMap).then((dynamic response) {
//       Widgets.showToast(Strings.loggedIn);

//       SharedPref().saveToken(response["token"].toString());
//       SharedPref().setValue("fullName", response["fullName"].toString());
//       SharedPref().setValue("id", response["_id"]);
//       SharedPref().setValue("isEmailVerified", response["isEmailVerified"]);
//       SharedPref().setValue("phoneNumber", response["phoneNumber"].toString());
//       setLoading(false);
//       if (widget.isBack) {
//         Navigator.pop(context);
//         Navigator.pop(context);
//       } else {
//         Navigator.of(context).pushNamedAndRemoveUntil(
//             Routes.homeMain, (Route<dynamic> route) => false);
//       }
//     }).futureError((error) {
//       setLoading(false);
//       error.toString().debugLog();
//     });
//   }

//   void setLoading(bool value) {
//     setState(() {
//       isLoading = value;
//     });
//   }

//   bool isButtonEnable() {
//     if (_phoneNumberController.text.isEmpty ||
//         !_phoneNumberKey.currentState.validate()) {
//       return false;
//     } else if (_passwordController.text.isEmpty ||
//         !_passwordKey.currentState.validate()) {
//       return false;
//     } else {
//       return true;
//     }
//   }
// }
