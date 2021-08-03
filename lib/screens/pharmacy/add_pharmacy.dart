import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/pharmacy/model/res_google_place_detail_pharmacy.dart';
import 'package:hutano/screens/registration/register/model/res_states_list.dart';
import 'package:hutano/screens/registration/register/state_list.dart';
import 'package:hutano/utils/address_util.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';
import 'model/places.dart';
import 'model/res_preferred_pharmacy_list.dart';

class AddPharmacy extends StatefulWidget {
  @override
  _AddPharmacyState createState() => _AddPharmacyState();
}

class _AddPharmacyState extends State<AddPharmacy> {
  final FocusNode _pharmacyFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _zipCodeFocusNode = FocusNode();
  final _pharmacyController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneNoController = TextEditingController();

  String addressError;
  String cityError;
  String zipCodeError;
  String phoneNoError;
  String pharmacyError;

  final GlobalKey<FormState> _pharmacyKey = GlobalKey();
  bool _autoValidate = false;
  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);
  List<AddressPharmacy> _placeList = [];
  List<AddressComponentsDetail> _placeDetail = [];
  GeometryDetail geometry;
  List<States> _stateList = [];
  States _selectedState;
  bool _enableButton = false;
  List<Place> _pharmacyList = [];
  List<Pharmacy> _pharmacyNewList = [];
  LatLng currentLatLng;
  String _addedPharmacyId = "";

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validateFields();
    getScreenSize(context);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        padding: EdgeInsets.only(bottom: 70),
        onForwardTap: _enableButton
            ? () {
                PreferredPharmacy preferredPharmacy =
                    PreferredPharmacy(pharmacyId: _addedPharmacyId);
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .updatePharmacy(preferredPharmacy);
                Navigator.of(context).pushNamed(Routes.routeVitalReviews);
              }
            : () {
                Widgets.showToast("Please add pharmacy details");
              },
        addBottomArrows: true,
        isSkipLater: true,
        onSkipForTap: () {
          Provider.of<HealthConditionProvider>(context, listen: false)
              .updatePharmacy(PreferredPharmacy());
          Navigator.of(context).pushNamed(Routes.routeVitalReviews);
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _healthMonitoringHeader(context),
              SizedBox(height: spacing10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing20),
                child: Form(
                    key: _pharmacyKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: [
                        _pharmacyFieldWidget(context),
                        SizedBox(height: spacing20),
                        _addressFieldWidget(context),
                        SizedBox(height: spacing20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cityFieldWidget(context),
                            StateList(
                                controller: _stateController,
                                stateList: _stateList,
                                onStateSelected: _onStateSelected)
                          ],
                        ),
                        SizedBox(height: spacing20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _zipCodeFieldWidget(context),
                            _phoneFieldWidget(context),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateFields() {
    if (_addressController.text.trim() != null &&
        _addressController.text.trim().isNotEmpty &&
        _cityController.text.trim() != null &&
        _cityController.text.trim().isNotEmpty &&
        _zipCodeController.text.trim() != null &&
        _zipCodeController.text.trim().isNotEmpty &&
        _phoneNoController.text.trim() != null &&
        _phoneNoController.text.trim().isNotEmpty) {
      _enableButton = true;
    } else {
      _enableButton = false;
    }
  }

  Widget _healthMonitoringHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: spacing5),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: spacing20, vertical: spacing10),
            child: Text(
              Localization.of(context).addPharmacyLabel,
              style: TextStyle(
                  fontSize: fontSize16,
                  fontWeight: fontWeightBold,
                  color: Color(0xff0e1c2a)),
            ),
          ),
        ),
      );

  Widget _pharmacyFieldWidget(BuildContext context) => TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _pharmacyController,
            focusNode: _pharmacyFocusNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            onTap: () {},
            onChanged: (value) {
              setState(() {
                pharmacyError =
                    value.toString().isBlank(context, "Please enter pharamcy");
              });
              _getPreferredPharmacy(context, value ?? "");
            },
            decoration: InputDecoration(
                errorText: pharmacyError,
                suffixIconConstraints: BoxConstraints(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _pharmacyController.text = "";
                  },
                  child: Padding(
                    padding: EdgeInsets.all(spacing14),
                    child: Image.asset(
                      FileConstants.icClose,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                labelText: "Pharmacy Name",
                hintText: "",
                isDense: true,
                hintStyle: TextStyle(color: colorBlack60, fontSize: fontSize14),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                labelStyle: labelStyle)),
        suggestionsCallback: (pattern) async {
          return pattern.length > 0 ? await _getFilteredBodyPartList() : [];
        },
        errorBuilder: (_, object) {
          return Container();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.name),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _pharmacyController.text = suggestion.name;
          setState(() {
            _addedPharmacyId = suggestion.sId;
            _placeList = suggestion.address;
          });
        },
        hideOnError: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
      );

  Widget _addressFieldWidget(BuildContext context) => TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _addressController,
            focusNode: _addressFocusNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            onTap: () {
              showError(RegisterError.password.index);
            },
            onChanged: (value) {
              setState(() {
                addressError = value.toString().isBlank(
                    context, Localization.of(context).errorEnterAddress);
              });
            },
            decoration: InputDecoration(
                errorText: addressError,
                suffixIconConstraints: BoxConstraints(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _addressController.text = "";
                  },
                  child: Padding(
                    padding: EdgeInsets.all(spacing14),
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
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(spacing12),
                    borderSide: BorderSide(color: colorBlack20, width: 1)),
                labelStyle: labelStyle)),
        suggestionsCallback: (pattern) async {
          return pattern.length > 3 ? await _getPlaceSuggestion(pattern) : [];
        },
        errorBuilder: (_, object) {
          return Container();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.address),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _addressController.text = suggestion.address;
          _cityController.text = suggestion.city;
          _stateController.text = suggestion.state;
          _zipCodeController.text = suggestion.zipCode;
          _phoneNoController.text = suggestion.phone;
        },
        hideOnError: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
      );

  Widget _cityFieldWidget(BuildContext context) => Container(
      width: screenSize.width / 2.4,
      child: HutanoTextField(
        labelTextStyle: labelStyle,
        focusNode: _cityFocusNode,
        controller: _cityController,
        onValueChanged: (value) {
          setState(() {
            cityError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterCity);
          });
        },
        errorText: cityError,
        onFieldTap: () {
          showError(RegisterError.address.index);
        },
        labelText: Localization.of(context).city,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_zipCodeFocusNode);
          showError(RegisterError.city.index);
        },
      ));

  Widget _zipCodeFieldWidget(BuildContext context) => HutanoTextField(
      labelTextStyle: labelStyle,
      width: screenSize.width / 2.4,
      focusedBorderColor: colorBlack20,
      controller: _zipCodeController,
      focusNode: _zipCodeFocusNode,
      textInputType: TextInputType.number,
      maxLength: 6,
      onFieldTap: () {
        showError(RegisterError.city.index);
      },
      onValueChanged: (value) {
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
        FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
        showError(RegisterError.zipCode.index);
      },
      textInputAction: TextInputAction.next);

  Widget _phoneFieldWidget(BuildContext context) => HutanoTextField(
      labelTextStyle: labelStyle,
      isNumberField: true,
      maxLength: 10,
      width: screenSize.width / 2.4,
      focusNode: _phoneNumberFocusNode,
      controller: _phoneNoController,
      isFieldEnable: true,
      focusedBorderColor: colorBlack20,
      labelText: Localization.of(context).phoneNo,
      textInputType: TextInputType.number,
      onValueChanged: (value) {
        setState(() {
          phoneNoError = value
              .toString()
              .isBlank(context, Localization.of(context).errorPhoneNo);
        });
      },
      errorText: phoneNoError,
      onFieldSubmitted: (s) {
        FocusScope.of(context).requestFocus(FocusNode());
        showError(RegisterError.phoneNo.index);
      },
      onFieldTap: () {
        showError(RegisterError.zipCode.index);
      },
      textInputAction: TextInputAction.done);

  _getFilteredBodyPartList() {
    return _pharmacyNewList.where((element) => element.name
        .toLowerCase()
        .contains(_pharmacyController.text.toLowerCase()));
  }

  _getPlaceSuggestion(String query) {
    return _placeList.where((element) => element.address
        .toLowerCase()
        .contains(_addressController.text.toLowerCase()));
  }

  void _parseAddress() {
    var _addressParser = AddressUtil();
    debugPrint("Parse Detail $_placeDetail");
    _addressParser.parsePharmacyAddress(_placeDetail);
    _addressController.text = _addressParser.address ?? "";
    _zipCodeController.text = _addressParser.zipCode ?? "";
    _cityController.text = _addressParser.city ?? "";
    addressError = null;
    zipCodeError = null;
    cityError = null;
    phoneNoError = null;
    final index = _stateList
        .indexWhere((element) => _addressParser.state == element.title);
    if (index != -1) {
      _stateController.text = _stateList[index].title;
      _selectedState = _stateList[index];
    }
    setState(() {});
  }

  void _onStateSelected(int index) {
    FocusManager.instance.primaryFocus.unfocus();
    _stateController.text = _stateList[index].title;
    _selectedState = _stateList[index];
    showError(RegisterError.city.index);
  }

  void showError(int index) {
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

    if (index >= 7) {
      phoneNoError = _phoneNoController.text
          .toString()
          .isBlank(context, Localization.of(context).errorPhoneNo);
    }

    setState(() {});
  }

  void _getPreferredPharmacy(BuildContext context, String input) async {
    await ApiManager().getPreferredPharmacyList(input).then((result) {
      if (result is ResPreferredPharmacyList) {
        setState(() {
          _pharmacyNewList = result.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
