import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/pharmacy/model/preferred_pharmacy.dart';
import 'package:hutano/screens/pharmacy/model/res_google_place_detail_pharmacy.dart';
import 'package:hutano/screens/registration/register/model/res_google_address_suggetion.dart';
import 'package:hutano/screens/registration/register/model/res_google_place_detail.dart';
import 'package:hutano/screens/registration/register/model/res_states_list.dart';
import 'package:hutano/screens/registration/register/state_list.dart';
import 'package:hutano/utils/address_util.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/size_config.dart';
// import 'package:hutano/widgets/controller.dart';

import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'model/places.dart';
import 'model/res_preferred_pharmacy_list.dart';

class AddPharmacy extends StatefulWidget {
  AddPharmacy({Key key, this.args}) : super(key: key);
  dynamic args;
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
  final _nameController = TextEditingController();

  String addressError;
  String cityError;
  String zipCodeError;
  String phoneNoError;
  String pharmacyError;

  final GlobalKey<FormState> _pharmacyKey = GlobalKey();
  bool _autoValidate = false;
  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);
  List<Address> _placeList = [];
  List<States> _stateList = [];
  bool _enableButton = false;
  String token;
  bool isIndicatorLoading = false;
  List<Pharmacy> pharmacyList = [];
  Pharmacy selectedPharmacy;
  bool _isLoading = false;
  bool isAdding = false;
  ApiBaseHelper api = ApiBaseHelper();
  Pharmacy defaultPharmacy;
  List<AddressComponents> _placeDetail = [];
  Geometry geometry;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    api.getStates().then((value) {
      _stateList = List<States>.from(value.map((i) => States.fromJson(i)));
    });
    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
      });
      getMypharmacyList();
    });
  }

  getMypharmacyList() async {
    setState(() {
      isIndicatorLoading = true;
    });
    await ApiManager().getMyPharmacies().then((result) {
      if (result is PreferredPharmacyData) {
        setLoading(false);
        setState(() {
          isIndicatorLoading = false;
        });
        if (result.response.preferredPharmacy != null) {
          setState(() {
            pharmacyList = result.response.preferredPharmacy;
            if (defaultPharmacy == null) {
              if (widget.args['isEdit']) {
                for (Pharmacy parmacy in result.response.preferredPharmacy) {
                  if (widget.args['preferredPharmacy'] != null &&
                      widget.args['preferredPharmacy']['name'] != null) {
                    if (parmacy.name ==
                        widget.args['preferredPharmacy']['name']) {
                      defaultPharmacy = parmacy;
                      break;
                    }
                  }
                }
              } else {
                if (result.response.preferredPharmacy.isNotEmpty) {
                  defaultPharmacy = result.response.preferredPharmacy[0];
                }
              }
            }
          });
        }
      }
    }).catchError((dynamic e) {
      setState(() {
        isIndicatorLoading = false;
      });
      if (e is ErrorModel) {
        setLoading(false);
        e.toString().debugLog();
      }
    });
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  void _removePharmacy(BuildContext context, Pharmacy pharmacy) {
    setLoading(true);
    api.deletePharmacy(token, pharmacy.sId).then((value) {
      setLoading(false);
      setState(() {
        if (pharmacyList.contains(pharmacy)) {
          pharmacyList.remove(pharmacy);
        }
        if (pharmacy.name == defaultPharmacy.name) {
          if (pharmacyList.isNotEmpty) {
            defaultPharmacy = pharmacyList.first;
          } else {
            defaultPharmacy = null;
          }
        }
      });
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
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
        isLoading: _isLoading,
        padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom == 0 ? spacing70 : 0),
        onForwardTap: defaultPharmacy != null
            ? () {
                if (widget.args['isEdit']) {
                  PreferredPharmacy preferredPharmacy =
                      PreferredPharmacy(pharmacyId: defaultPharmacy.sId);
                  Map<String, dynamic> model = {};
                  model['preferredPharmacy'] = preferredPharmacy;
                  model['appointmentId'] = widget.args['appointmentId'];
                  setLoading(true);
                  ApiManager().updateAppointmentData(model).then((value) {
                    setLoading(false);
                    Navigator.pop(context);
                  });
                } else {
                  PreferredPharmacy preferredPharmacy =
                      PreferredPharmacy(pharmacyId: defaultPharmacy.sId);
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .updatePharmacy(preferredPharmacy);
                  Navigator.of(context).pushNamed(Routes.routeVitalReviews,
                      arguments: {'isEdit': false});
                }
              }
            : () {
                Widgets.showToast("Please add pharmacy details");
              },
        addBottomArrows: MediaQuery.of(context).viewInsets.bottom == 0,
        isSkipLater: !widget.args['isEdit'],
        onSkipForTap: () {
          Provider.of<HealthConditionProvider>(context, listen: false)
              .updatePharmacy(PreferredPharmacy(pharmacyId: ""));
          Navigator.of(context).pushNamed(Routes.routeVitalReviews,
              arguments: {'isEdit': false});
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
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        _pharmacyFieldWidget(context),
                        SizedBox(height: spacing20),
                        isAdding
                            ? Column(
                                // shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                children: [
                                  _nameFieldWidget(context),
                                  SizedBox(height: spacing20),
                                  _addressFieldWidget(context),
                                  SizedBox(height: spacing20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _zipCodeFieldWidget(context),
                                      _phoneFieldWidget(context),
                                    ],
                                  ),
                                  SizedBox(height: spacing20),
                                  Row(
                                    children: [
                                      Spacer(),
                                      OutlinedButton(
                                          onPressed: () {
                                            isAdding = false;
                                            _pharmacyController.text = "";
                                            setState(() {});
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          )),
                                      SizedBox(width: 20),
                                      OutlinedButton(
                                          style: ButtonStyle(backgroundColor:
                                              MaterialStateProperty.resolveWith<
                                                  Color>((states) {
                                            return AppColors.goldenTainoi;
                                          })),
                                          onPressed: _enableButton
                                              ? () async {
                                                  Pharmacy reqAddPharmacyModel =
                                                      Pharmacy(
                                                          name: _nameController
                                                              .text,
                                                          // .name,
                                                          // sId: selectedPharmacy.sId,
                                                          address: AddressPharmacy(
                                                              address:
                                                                  _addressController
                                                                      .text,
                                                              city:
                                                                  _cityController
                                                                      .text,
                                                              state:
                                                                  _stateController
                                                                      .text,
                                                              zipCode:
                                                                  _zipCodeController
                                                                      .text,
                                                              phone:
                                                                  _phoneNoController
                                                                      .text));
                                                  setLoading(true);
                                                  await ApiManager()
                                                      .addPreferredPharmacy(
                                                          reqAddPharmacyModel)
                                                      .then((result) {
                                                    _addressController.text =
                                                        '';
                                                    _cityController.text = '';
                                                    _stateController.text = '';
                                                    _zipCodeController.text =
                                                        '';
                                                    _phoneNoController.text =
                                                        '';
                                                    _nameController.text = '';
                                                    setLoading(false);
                                                    getMypharmacyList();
                                                  }).catchError((dynamic e) {
                                                    setLoading(false);
                                                    if (e is ErrorModel) {
                                                      setLoading(false);
                                                      e.toString().debugLog();
                                                    }
                                                  });
                                                  selectedPharmacy = null;
                                                  isAdding = false;
                                                  _pharmacyController.text = "";
                                                  setState(() {});
                                                }
                                              : () {
                                                  Widgets.showToast(
                                                      "Please add pharmacy details");
                                                },
                                          child: Text(
                                            'Save',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: spacing20),
                                ],
                              )
                            : SizedBox(),
                        isIndicatorLoading
                            ? Center(
                                child: CustomLoader(),
                              )
                            : pharmacyList == null ||
                                    (pharmacyList == null ||
                                            pharmacyList.isEmpty) &&
                                        !isIndicatorLoading
                                ? Text(
                                    'No pharmacy found',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: colorBlack2,
                                        fontWeight: fontWeightSemiBold),
                                  )
                                : ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(height: 10),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: pharmacyList.length,
                                    itemBuilder: (context, index) {
                                      return PopupMenuButton(
                                        offset: Offset(300, 50),
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          defaultPharmacy.sId ==
                                                  pharmacyList[index].sId
                                              ? null
                                              : _popMenuCommonItem(
                                                  context,
                                                  'set as default',
                                                  FileConstants.icEdit),
                                          _popMenuCommonItem(
                                              context,
                                              Localization.of(context).remove,
                                              FileConstants.icRemoveBlack)
                                        ],
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          'Name: ' +
                                                              pharmacyList[
                                                                      index]
                                                                  .name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      defaultPharmacy.sId ==
                                                              pharmacyList[
                                                                      index]
                                                                  .sId
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: AppColors
                                                                  .goldenTainoi,
                                                              size: 20,
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                                  Text('Address: ' +
                                                      pharmacyList[index]
                                                          .address
                                                          .address +
                                                      ', ' +
                                                      pharmacyList[index]
                                                          .address
                                                          .city +
                                                      ', ' +
                                                      pharmacyList[index]
                                                          .address
                                                          .state +
                                                      ', ' +
                                                      pharmacyList[index]
                                                          .address
                                                          .zipCode +
                                                      ', '),
                                                  Text(
                                                    'Phone no.: ' +
                                                        pharmacyList[index]
                                                            .address
                                                            .phone,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.more_vert)
                                          ],
                                        ),
                                        onSelected: (value) {
                                          if (value == 'set as default') {
                                            defaultPharmacy =
                                                pharmacyList[index];
                                            setState(() {});
                                          } else {
                                            Widgets.showConfirmationDialog(
                                              context: context,
                                              description:
                                                  "Are you sure to delete this pharmacy?",
                                              onLeftPressed: () =>
                                                  _removePharmacy(context,
                                                      pharmacyList[index]),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
        value: value,
        textStyle: const TextStyle(
            color: colorBlack2,
            fontWeight: fontWeightRegular,
            fontSize: spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: spacing5,
            ),
            Text(value)
          ],
        ),
      );

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

  Widget _pharmacyFieldWidget(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 40,
      decoration: BoxDecoration(
          color: colorBlack2.withOpacity(0.06),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _pharmacyController,
            focusNode: _pharmacyFocusNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            onTap: () {},
            onChanged: (value) {},
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints(),
              prefixIcon: GestureDetector(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.all(spacing8),
                      child: Image.asset(FileConstants.icSearchBlack,
                          color: colorBlack2, width: 20, height: 20))),
              hintText: 'Pharmacy Name',
              isDense: true,
              hintStyle: TextStyle(
                  color: colorBlack2,
                  fontSize: fontSize13,
                  fontWeight: fontWeightRegular),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            )),
        suggestionsCallback: (pattern) async {
          return pattern.length > 0 ? await _getPharmacySuggetion(pattern) : [];
        },
        keepSuggestionsOnLoading: false,
        loadingBuilder: (context) => CustomLoader(),
        errorBuilder: (_, object) {
          return Container();
        },
        itemBuilder: (context, suggestion) {
          // String addressData = '';
          // if (suggestion.address != null) {
          //   if (suggestion.address.address != null) {
          //     addressData = suggestion.address.address + ', ';
          //   }
          //   if (suggestion.address.city != null) {
          //     addressData += suggestion.address.city + ', ';
          //   }
          //   if (suggestion.address.state != null) {
          //     addressData += suggestion.address.state + ', ';
          //   }
          //   if (suggestion.address.zipCode != null) {
          //     addressData += suggestion.address.zipCode + ', ';
          //   }
          //   if (suggestion.address.phone != null) {
          //     addressData += suggestion.address.phone;
          //   }
          // }
          return ListTile(
              title: Text(suggestion.name),
              subtitle: Text(suggestion.formattedAddress));
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          // isAdding = true;
          // selectedPharmacy = suggestion;
          _nameController.text = suggestion.name;
          _pharmacyController.text = suggestion.name;
          // if (suggestion.address != null) {
          //   _addressController.text = suggestion.address.address;
          //   _cityController.text = suggestion.address.city;
          //   _stateController.text = suggestion.address.state;
          //   _zipCodeController.text = suggestion.address.zipCode;
          //   _phoneNoController.text = suggestion.address.phone;
          // }

          // setState(() {});
          _getPlaceDetail(suggestion.placeId);
        },
        hideOnError: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
      ));

  Widget _addressFieldWidget(BuildContext context) => TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _addressController,
            // focusNode: _addressFocusNode,
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
                // suffixIconConstraints: BoxConstraints(),
                // suffixIcon: GestureDetector(
                //   onTap: () {
                //     _addressController.text = "";
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.all(spacing14),
                //     child: Image.asset(
                //       FileConstants.icClose,
                //       width: 30,
                //       height: 30,
                //     ),
                //   ),
                // ),
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
          return
              // pattern.length > 3 ? await _getPlaceSuggetion(pattern) :
              [];
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
          _getPlaceDetail(suggestion.placeId);
        },
        hideOnError: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
      );

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

    isAdding = true;
    // selectedPharmacy = suggestion;
    // _nameController.text = suggestion.name;
    // _pharmacyController.text = suggestion.name;
    // if (suggestion.address != null) {
    //   _addressController.text = suggestion.address.address;
    //   _cityController.text = suggestion.address.city;
    //   _stateController.text = suggestion.address.state;
    //   _zipCodeController.text = suggestion.address.zipCode;
    //   _phoneNoController.text = suggestion.address.phone;
    // }

    // setState(() {});

    _addressParser.parseAddress(_placeDetail);
    debugPrint("{${geometry.location.lat} ${geometry.location.lng}");
    _addressController.text = _addressParser.address;
    _zipCodeController.text = _addressParser.zipCode;
    _stateController.text = _addressParser.state;
    _cityController.text = _addressParser.city;
    // _phoneNoController.text = _addressParser.p.phone
    addressError = null;
    zipCodeError = null;
    cityError = null;

    // final index = _stateList
    //     .indexWhere((element) => _addressParser.state == element.title);

    // if (index != -1) {
    //   _stateController.text = _stateList[index].title;
    // }

    setState(() {});
  }

  Widget _nameFieldWidget(BuildContext context) => Container(
      width: screenSize.width,
      child: HutanoTextField(
        labelTextStyle: labelStyle,
        // focusNode: _cityFocusNode,
        isFieldEnable: false,
        controller: _nameController,
        onValueChanged: (value) {
          setState(() {
            cityError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterCity);
          });
        },
        labelText: Localization.of(context).name,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_addressFocusNode);
          showError(RegisterError.address.index);
        },
      ));
  Widget _cityFieldWidget(BuildContext context) => Container(
      width: screenSize.width / 2.4,
      child: HutanoTextField(
        labelTextStyle: labelStyle,
        // focusNode: _cityFocusNode,
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
      // focusNode: _zipCodeFocusNode,
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
      // focusNode: _phoneNumberFocusNode,
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

  _getPharmacySuggetion(String query) async {
    final params = <String, String>{
      'query': query,
      'type': 'pharmacy',
      'region': 'us'
    };
    try {
      var res = await ApiManager().getPlaceSuggetions(params);
      return res.results.length >= 5 ? res.results.sublist(0, 5) : res.results;
    } on ErrorModel catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  void _onStateSelected(int index) {
    FocusManager.instance.primaryFocus.unfocus();
    _stateController.text = _stateList[index].title;
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
}
