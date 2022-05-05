import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/account_recover_dialog.dart';
import 'package:hutano/screens/registration/register/model/referral_code.dart';
import 'package:hutano/utils/address_util.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/text_with_image.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_textfield.dart';
import 'date_of_birth.dart';
import 'gender_selector.dart';
import 'model/req_register.dart';
import 'model/req_verify_address.dart';
import 'model/res_google_address_suggetion.dart';
import 'model/res_google_place_detail.dart';
import 'model/res_insurance_list.dart';
import 'model/res_states_list.dart';
import 'state_list.dart';
import 'upload_image.dart';

class RegisterScreen extends StatefulWidget {
  final String number;
  final String countryCode;

  RegisterScreen(this.number, this.countryCode);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class Genders {
  int val;
  String title;
  Genders(this.val, this.title);
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _zipCodeFocus = FocusNode();
  final FocusNode _refCodeFocus = FocusNode();

  String firstNameError;
  String lastNameError;
  String emailError;
  String passwordError;
  String addressError;
  String cityError;
  String zipCodeError;
  String emailSuffixIcon;

  final _dobController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _refCodeController = TextEditingController();
  final _mobileFormatter = NumberTextInputFormatter();
  final GlobalKey<FormState> _key = GlobalKey();

  File _imageFile;
  GenderType _gender;
  List<States> _stateList = [];
  List<Insurance> _insuranceList = [];
  States _selectedState;
  Insurance _selectedInsurance;
  final _registerModel = ReqRegister();
  bool _enableButton = false;
  bool _dialogOpen = false;
  List<Address> _placeList = [];
  List<AddressComponents> _placeDetail = [];
  Geometry geometry;
  bool isSecureField = true;
  String deviceToken;

  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);
  List<Genders> genders = [
    Genders(0, 'Binary'),
    Genders(1, 'Lesbian'),
    Genders(2, 'Gay'),
    Genders(3, 'Bisexual'),
    Genders(4, 'Transgender'),
    Genders(5, 'Queer'),
    Genders(6, 'Other'),
  ];

  Genders genderType;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getInsuranceList());
    WidgetsBinding.instance.addPostFrameCallback((_) => _getStatesList());

    SharedPref().getValue("deviceToken").then((value) {
      deviceToken = value;
    });
    genderType = genders.first;
    _registerModel.genderType = genders.first.val;

    if (_addressFocus != null) {
      _addressFocus.addListener(() {
        setState(() {});
      });
    }

    _registerModel.type = 1;
    _registerModel.step = 3;
    _registerModel.mobileCountryCode = widget.countryCode;
    _registerModel.isAgreeTermsAndCondition = 1;
    _registerModel.phoneNumber = widget.number;

    if (Referral().referralCode.isNotEmpty) {
      _registerModel.referedBy = Referral().referralCode;
      _refCodeController.text = Referral().referralCode;
    }
  }

  _onImagePicked(file) => _imageFile = file;

  void _onDateSelected(String date) {
    print(date);
    _dobController.text = date;
    _passwordFocus.requestFocus();
    _registerModel.dob = date;
    showError(RegisterError.email.index);
  }

  _onGenderChange(GenderType gender) {
    setState(() {
      _gender = gender;
    });
    _registerModel.gender = gender.index;
    showError(RegisterError.zipCode.index);
  }

  _onStateSelected(int index) {
    FocusManager.instance.primaryFocus.unfocus();
    _stateController.text = _stateList[index].title;
    _registerModel.state = _stateList[index].sId;
    _selectedState = _stateList[index];
    showError(RegisterError.city.index);
  }

  _onInsuranceSelected(int index) {
    FocusManager.instance.primaryFocus.unfocus();
    _insuranceController.text = _insuranceList[index].title;
    _registerModel.insuranceId = _insuranceList[index].sId;
    _selectedInsurance = _insuranceList[index];
    showError(RegisterError.zipCode.index);
  }

  _getInsuranceList() async {
    try {
      var res = await ApiManager().insuraceList();
      setState(() {
        _insuranceList = res.response;
      });
    } catch (e) {
      print(e);
    }
  }

  _getStatesList() async {
    try {
      var res = await ApiManager().statesList();
      setState(() {
        _stateList = res.response;
      });
    } catch (e) {
      print(e);
    }
  }

  _callEmailVerifyApi() async {
    if (_dialogOpen) return;

    final request = {'email': _emailController.text};
    try {
      await ApiManager().checkEmailExist(request);
      setState(() {
        emailSuffixIcon = FileConstants.icSuccess;
      });
    } on ErrorModel catch (e) {
      _dialogOpen = true;
      setState(() {
        emailSuffixIcon = FileConstants.icCloseRed;
      });
      showacountRecoverDialog(
        context,
        _emailController.text.toString(),
        onRecover: () {
          _dialogOpen = false;
          Navigator.of(context).pushReplacementNamed(Routes.routeForgotPassword,
              arguments: {
                ArgumentConstant.verificationScreen:
                    VerificationScreen.resetPassword
              });
        },
        onCancel: () {
          _dialogOpen = false;
        },
      );
      // DialogUtils.showOkCancelAlertDialog(
      //     cancelButtonTitle: Localization.of(context).cancel,
      //     okButtonTitle: Localization.of(context).recover,
      //     okButtonAction: () {
      //       _dialogOpen = false;
      //       Navigator.of(context).pushReplacementNamed(routeForgotPassword,
      //           arguments: {
      //             ArgumentConstant.verificationScreen:
      //                 VerificationScreen.resetPassword
      //           });
      //     },
      //     cancelButtonAction: () {
      //       _dialogOpen = false;
      //     },
      //     message: Localization.of(context).errorEmailExists,
      //     context: context);
    } catch (e) {
      print(e);
    }
  }

  _submitData() async {
    FocusManager.instance.primaryFocus.unfocus();
    if (_registerModel.dob == null) {
      DialogUtils.showAlertDialog(context, Localization.of(context).errorDob);
      return;
    }
    if (_registerModel.gender == null) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).errorGender);
      return;
    }
    if (_registerModel.state == null) {
      DialogUtils.showAlertDialog(context, Localization.of(context).errorState);
      return;
    }

    if (_imageFile == null) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).errorSelectProfile);
      return;
    }

    if (_registerModel.haveHealthInsurance == null) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).errorHealthInsurance);
      return;
    }
    _register();
  }

  _verifyAddress() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqVerifyAddress(
        city: _registerModel.city,
        street1: _registerModel.address,
        state: _selectedState.title,
        zip: _registerModel.zipCode);
    try {
      await ApiManager().verifyAddress(request);
      ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  _getPlaceSuggetion(String query) async {
    final params = <String, String>{
      'input': query,
      'types': 'address',
      'components': 'country:us'
    };
    try {
      var res = await ApiManager().getAddressSuggetion(params);
      _placeList = res.predictions.length >= 5
          ? res.predictions.sublist(0, 5)
          : res.predictions;
      return _placeList;
    } on ErrorModel catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  _getPlaceDetail(String placeId) async {
    ProgressDialogUtils.showProgressDialog(context);
    final params = <String, String>{
      'fields': 'geometry,address_components',
      'place_id': placeId
    };

    try {
      var res = await ApiManager().getPlaceDetail(params);
      _placeDetail = res.result.addressComponents;
      geometry = res.result.geometry;
      if (_placeDetail != null && _placeDetail.length > 0) {
        _parseAddress();
      }
      ProgressDialogUtils.dismissProgressDialog();
    } on ErrorModel catch (e) {
      print(e);
      ProgressDialogUtils.dismissProgressDialog();
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  _parseAddress() {
    var _addressParser = AddressUtil();
    _addressParser.parseAddress(_placeDetail);
    debugPrint("{${geometry.location.lat} ${geometry.location.lng}");
    _addressController.text = _addressParser.address;
    _zipCodeController.text = _addressParser.zipCode;
    _cityController.text = _addressParser.city;

    _registerModel.address = _addressController.text;
    _registerModel.city = _cityController.text;
    _registerModel.zipCode = _zipCodeController.text;
    _registerModel.latitude = geometry.location.lat.toString();
    _registerModel.longitude = geometry.location.lng.toString();
    addressError = null;
    zipCodeError = null;
    cityError = null;

    final index = _stateList
        .indexWhere((element) => _addressParser.state == element.title);

    if (index != -1) {
      _stateController.text = _stateList[index].title;
      _registerModel.state = _stateList[index].sId;
      _selectedState = _stateList[index];
    }

    setState(() {});
  }

  _register() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      _registerModel.fullName =
          "${_registerModel.firstName} ${_registerModel.lastName}";
      _registerModel.deviceToken = deviceToken;
      var res = await ApiManager().registerUser(_registerModel, _imageFile);

      //TODO : Verify code
      // SharedPref().setValue(PreferenceKey.id, res.response.sId);
      // SharedPref().setValue(PreferenceKey.email, res.response.email);
      // SharedPref().setValue(PreferenceKey.gender, res.response.gender);
      // setInt(PreferenceKey.gender, res.response.gender);
      // setString(PreferenceKey.tokens, res.response.token);
      // setString('patientSocialHistory',
      //     jsonEncode(res.response.patientSocialHistory));
      // setString('primaryUser', jsonEncode(res.response));
      // SharedPref()
      //     .setValue(PreferenceKey.phone, res.response.phoneNumber.toString());

      setBool(PreferenceKey.perFormedSteps, false);
      setBool(PreferenceKey.isEmailVerified, false);
      setString(PreferenceKey.fullName, res.response.fullName);
      setString(PreferenceKey.id, res.response.sId);
      SharedPref().setValue(PreferenceKey.email, res.response.email);
      setString(PreferenceKey.tokens, res.response.token);
      setString(PreferenceKey.phone, res.response.phoneNumber.toString());
      setInt(PreferenceKey.gender, res.response.gender);
      setString('patientSocialHistory',
          jsonEncode(res.response.patientSocialHistory));
      setString('primaryUser', jsonEncode(res.response));
      setString('primaryUserToken', res.response.token);
      setString('selectedAccount', jsonEncode(res.response));
      setBool(PreferenceKey.intro, true);

      //TODO : Verify code
      SharedPref().saveToken(res.response.token);
      // SharedPref().setValue("fullName", _registerModel.fullName);
      // SharedPref().setValue("complete", "0");

      //TODO:
      //Note : Old register coded added
      // Map _insuranceMap = {};
      // _insuranceMap['isPayment'] = false;
      // _insuranceMap['isFromRegister'] = true;

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   Routes.insuranceListScreen,
      //   (Route<dynamic> route) => false,
      //   arguments: _insuranceMap,
      // );
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.of(context).pushNamed(
        _registerModel.haveHealthInsurance
            ? Routes.addInsurance
            : Routes.welcome,
      );
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     _registerModel.haveHealthInsurance
      //         ? Routes.addInsurance
      //         : Routes.welcome,
      //     (Route<dynamic> route) => false);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      print(e);
    }
  }

  void validateFields() {
    if (_registerModel.address != null &&
        _registerModel.address.isNotEmpty &&
        _registerModel.city != null &&
        _registerModel.city.isNotEmpty &&
        _registerModel.email != null &&
        _registerModel.email.isNotEmpty &&
        _registerModel.firstName != null &&
        _registerModel.firstName.isNotEmpty &&
        _registerModel.lastName != null &&
        _registerModel.lastName.isNotEmpty &&
        _registerModel.password != null &&
        _registerModel.password.isNotEmpty &&
        _registerModel.zipCode != null &&
        _registerModel.zipCode.isNotEmpty) {
      _enableButton = true;
    } else {
      _enableButton = false;
    }
  }

  // validate and show error if user skips field or navigate to next field
  void showError(int index) {
    if (index >= 0) {
      firstNameError = _firstNameController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterFirstName);
    }
    if (index >= 1) {
      lastNameError = _lastNameController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterLastName);
    }
    if (index >= 2) {
      emailError = _emailController.text.toString().isValidEmail(context);
    }

    if (index >= 3) {
      passwordError =
          _passwordController.text.toString().isValidPassword(context);
    }

    if (index >= 4) {
      addressError = _addressController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterAddress);
    }

    if (index >= 5) {
      cityError = _cityController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterCity);
    }

    if (index >= 6) {
      zipCodeError = _zipCodeController.text
          .toString()
          .isBlank(context, Localization.of(context).errorZipCode);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    return Container(
      color: colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        CustomBackButton(),
                      ],
                    ),
                    AppLogo(),
                    Text(
                      Localization.of(context).createAccount,
                      style: TextStyle(
                        color: colorBlack2.withOpacity(0.85),
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: gilroyLight,
                      ),
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    UploadImage(
                      onImagePicked: _onImagePicked,
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getFirstNameTextField(),
                        _getLastNameTextField(),
                      ],
                    ),
                    _getEmailTextField(),
                    DateOfBirth(
                      onDateSelected: _onDateSelected,
                      controller: _dobController,
                      beforeYear: 18,
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildPasswordField(),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildAddressField(),
                    SizedBox(
                      height: spacing20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCityTextField(),
                        StateList(
                            controller: _stateController,
                            stateList: _stateList,
                            onStateSelected: _onStateSelected)
                      ],
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildZipCode(),
                        _buildPhoneInputField(),
                      ],
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    GenderSelector(
                        onGenderChange: _onGenderChange, gender: _gender),

                    SizedBox(
                      height: spacing20,
                    ),
                    DropdownButtonFormField<Genders>(
                      decoration: InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey[300], width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey[300], width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey[300], width: 1)),
                      ),
                      value: genderType,
                      items: genders
                          .map<DropdownMenuItem<Genders>>((Genders value) {
                        return DropdownMenuItem<Genders>(
                          value: value,
                          child: Text(value.title),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _registerModel.genderType = val.val;
                          genderType = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildHealthInsurance(),
                    SizedBox(
                      height: spacing20,
                    ),
                    // InsuranceList(
                    //     controller: _insuranceController,
                    //     insuranceList: _insuranceList,
                    //     onInsuranceSelected: _onInsuranceSelected),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildRefCodeField(),
                    SizedBox(
                      height: spacing40,
                    ),
                    HutanoButton(
                      onPressed: _enableButton ? _submitData : null,
                      label: Localization.of(context).next,
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLastNameTextField() {
    return Container(
        width: SizeConfig.screenWidth / 2.4,
        child: HutanoTextField(
          focusNode: _lastNameFocus,
          focusedBorderColor: colorBlack20,
          onValueChanged: (value) {
            _registerModel.lastName = value;
            setState(() {
              lastNameError = value.toString().isBlank(
                  context, Localization.of(context).errorEnterLastName);
            });
          },
          onFieldTap: () {
            showError(RegisterError.firstName.index);
          },
          labelTextStyle: labelStyle,
          errorText: lastNameError,
          controller: _lastNameController,
          labelText: Localization.of(context).lastName,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
          ],
          onFieldSubmitted: (s) {
            FocusScope.of(context).requestFocus(_emailFocus);
            showError(RegisterError.lastName.index);
          },
        ));
  }

  Widget _getFirstNameTextField() {
    return HutanoTextField(
        width: SizeConfig.screenWidth / 2.4,
        onValueChanged: (value) {
          _registerModel.firstName = value;
          setState(() {
            firstNameError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: firstNameError,
        focusNode: _firstNameFocus,
        controller: _firstNameController,
        labelText: Localization.of(context).firstName,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_lastNameFocus);
          showError(RegisterError.firstName.index);
        },
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.next);
  }

  Widget _getEmailTextField() {
    return Container(
        margin: EdgeInsets.only(top: spacing15),
        child: HutanoTextField(
            labelTextStyle: labelStyle,
            focusNode: _emailFocus,
            controller: _emailController,
            onValueChanged: (value) {
              _registerModel.email = value;
              final isValidEmail = value.toString().isValidEmail(context);
              setState(() {
                emailError = isValidEmail;
              });
              if (isValidEmail == null) {
                _callEmailVerifyApi();
              } else {
                emailSuffixIcon = null;
              }
            },
            onFieldTap: () {
              showError(RegisterError.lastName.index);
            },
            suffixIcon: emailSuffixIcon,
            suffixheight: 22,
            suffixwidth: 22,
            errorText: emailError,
            focusedBorderColor: colorBlack20,
            labelText: Localization.of(context).email,
            textInputType: TextInputType.emailAddress,
            onFieldSubmitted: (s) {
              FocusScope.of(context).requestFocus(_passwordFocus);
              showError(RegisterError.email.index);
            },
            textInputAction: TextInputAction.next));
  }

  Widget _buildPasswordField() {
    return Container(
        child: HutanoTextField(
            labelTextStyle: labelStyle,
            focusNode: _passwordFocus,
            controller: _passwordController,
            onValueChanged: (value) {
              _registerModel.password = value;
              setState(() {
                passwordError = value.toString().isValidPassword(context);
              });
            },
            onFieldTap: () {
              showError(RegisterError.email.index);
            },
            focusedBorderColor: colorBlack20,
            errorText: passwordError,
            labelText: Localization.of(context).password,
            textInputType: TextInputType.visiblePassword,
            onFieldSubmitted: (s) {
              FocusScope.of(context).requestFocus(_addressFocus);
              showError(RegisterError.password.index);
            },
            passwordTap: () {
              setState(() {
                isSecureField = !isSecureField;
              });
            },
            isSecureField: isSecureField,
            isPasswordField: true,
            textInputAction: TextInputAction.next));
  }

  Widget _buildPhoneInputField() {
    return Container(
        child: HutanoTextField(
            textInputFormatter: <TextInputFormatter>[_mobileFormatter],
            isNumberField: true,
            width: SizeConfig.screenWidth / 2.4,
            focusNode: _mobileFocus,
            controller: _phoneNoController
              ..text =
                  '${widget.countryCode} ${widget.number.getUsFormatNumber()}',
            isFieldEnable: false,
            focusedBorderColor: colorBlack20,
            labelText: Localization.of(context).phoneNo,
            textInputType: TextInputType.number,
            onFieldSubmitted: (s) {},
            textInputAction: TextInputAction.next));
  }

  Widget _buildAddressField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: _addressController,
          focusNode: _addressFocus,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          onTap: () {
            showError(RegisterError.password.index);
          },
          onChanged: (value) {
            _registerModel.address = value;
            setState(() {
              addressError = value
                  .toString()
                  .isBlank(context, Localization.of(context).errorEnterAddress);
            });
          },
          decoration: InputDecoration(
              errorText: addressError,
              suffixIconConstraints: BoxConstraints(),
              suffixIcon: GestureDetector(
                onTap: () {
                  _registerModel.address = "";
                  _addressController.text = "";
                },
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Image.asset(
                    FileConstants.icClose,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              labelText: Localization.of(context).address,
              hintText: "",
              isDense: true,
              hintStyle: TextStyle(color: colorBlack60, fontSize: fontSize14),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorBlack20, width: 1)),
              labelStyle: labelStyle)),
      suggestionsCallback: (pattern) async {
        return pattern.length > 3 ? await _getPlaceSuggetion(pattern) : [];
      },
      keepSuggestionsOnLoading: false,
      loadingBuilder: (context) => CustomLoader(),
      errorBuilder: (_, object) {
        return Container();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.description),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        _addressController.text = suggestion.structuredFormatting.mainText;
        _getPlaceDetail(suggestion.placeId);
      },
      hideOnError: true,
      hideSuggestionsOnKeyboardHide: true,
      hideOnEmpty: true,
    );
  }

  Widget _buildCityTextField() {
    return Container(
        width: SizeConfig.screenWidth / 2.4,
        child: HutanoTextField(
          labelTextStyle: labelStyle,
          focusNode: _cityFocus,
          controller: _cityController,
          onValueChanged: (value) {
            _registerModel.city = value;
            setState(() {
              cityError = value
                  .toString()
                  .isBlank(context, Localization.of(context).errorEnterCity);
            });
          },
          onFieldTap: () {
            showError(RegisterError.address.index);
          },
          errorText: cityError,
          labelText: Localization.of(context).city,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (s) {
            FocusScope.of(context).requestFocus(_zipCodeFocus);
            showError(RegisterError.city.index);
          },
        ));
  }

  Widget _buildRefCodeField() {
    return Container(
        child: HutanoTextField(
            focusedBorderColor: colorBlack20,
            labelTextStyle: labelStyle,
            focusNode: _refCodeFocus,
            onValueChanged: (value) {
              _registerModel.referedBy = value;
            },
            isFieldEnable: Referral().referralCode.isEmpty,
            onFieldTap: () {
              showError(RegisterError.zipCode.index);
            },
            controller: _refCodeController,
            labelText: Localization.of(context).refCode,
            textInputAction: TextInputAction.done));
  }

  Widget _buildZipCode() {
    return HutanoTextField(
        labelTextStyle: labelStyle,
        width: SizeConfig.screenWidth / 2.4,
        focusedBorderColor: colorBlack20,
        controller: _zipCodeController,
        focusNode: _zipCodeFocus,
        textInputType: TextInputType.number,
        maxLength: 6,
        onFieldTap: () {
          showError(RegisterError.city.index);
        },
        onValueChanged: (value) {
          _registerModel.zipCode = value;
          setState(() {
            zipCodeError = value
                .toString()
                .isBlank(context, Localization.of(context).errorZipCode);
          });
        },
        errorText: zipCodeError,
        textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
        labelText: Localization.of(context).zipcode,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_mobileFocus);
          showError(RegisterError.zipCode.index);
        },
        textInputAction: TextInputAction.done);
  }

  _buildHealthInsurance() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: colorGrey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextWithImage(
              size: spacing30,
              textStyle: const TextStyle(
                fontSize: fontSize16,
                color: colorBlack2,
                fontFamily: gilroyMedium,
                fontStyle: FontStyle.normal,
              ),
              label: Localization.of(context).labelHealthInsurance,
              image: FileConstants.icInsuranceBlue),
          SizedBox(
            height: 14,
          ),
          Text(
            Localization.of(context).healthInsurance,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: fontSize14,
              color: colorBlack2,
              fontFamily: gilroyRegular,
            ),
          ),
          SizedBox(
            height: 17,
          ),
          Row(
            children: [
              HutanoButton(
                label: 'Yes',
                onPressed: () {
                  _registerModel.haveHealthInsurance = true;
                  setState(() {});
                },
                buttonType: HutanoButtonType.onlyLabel,
                width: 80,
                labelColor: (_registerModel.haveHealthInsurance != null &&
                        _registerModel.haveHealthInsurance)
                    ? colorWhite
                    : colorBlack,
                color: (_registerModel.haveHealthInsurance != null &&
                        _registerModel.haveHealthInsurance)
                    ? colorPurple
                    : Colors.white,
                height: 40,
              ),
              SizedBox(
                width: 15,
              ),
              HutanoButton(
                borderColor: colorGrey,
                label: 'No',
                onPressed: () {
                  _registerModel.haveHealthInsurance = false;
                  setState(() {});
                },
                buttonType: HutanoButtonType.onlyLabel,
                width: 80,
                labelColor: (_registerModel.haveHealthInsurance != null &&
                        !_registerModel.haveHealthInsurance)
                    ? colorWhite
                    : colorBlack,
                color: (_registerModel.haveHealthInsurance != null &&
                        !_registerModel.haveHealthInsurance)
                    ? colorPurple
                    : colorWhite,
                borderWidth: 1,
                height: 40,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_addressFocus != null) {
      _addressFocus.dispose();
    }
    super.dispose();
  }
}
