import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/src/utils/size_config.dart';

import '../../apis/api_constants.dart';
import '../../apis/api_manager.dart';
import '../../apis/api_service_stripe.dart';
import '../../apis/error_model.dart';
import '../../apis/error_model_stripe.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_textfield.dart';
import '../../widgets/ripple_effect.dart';
import '../../widgets/text_with_image.dart';
import '../auth/register/model/res_insurance_list.dart';
import '../registration_steps/payment/model/req_add_card.dart';
import '../registration_steps/payment/model/req_create_card_token.dart';
import '../registration_steps/payment/provider/credit_card_provider.dart';
import '../registration_steps/payment/utils/card_utils.dart';
import '../registration_steps/payment/utils/input_formatters.dart';
import 'model/req_add_my_insurace.dart';

class PaymentMethods extends StatefulWidget {
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  List<CreditCard> list = [];
  int _selectedCardIndex;
  int _selectedInsuranceIndex;
  bool _initialApiCalled = false;
  bool _enableSaveButton = false;

  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();

  final GlobalKey<FormState> _keyCVV = GlobalKey();
  final GlobalKey<FormState> _keyExpiary = GlobalKey();
  final GlobalKey<FormState> _keyName = GlobalKey();
  final GlobalKey<FormState> _keyNumber = GlobalKey();
  CardNumberInputFormatter maskFormatter = CardNumberInputFormatter();

  List<Insurance> _myInsuranceList = [];
  Insurance _selectedInsurance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCard();
      _getInsurance();
    });
  }

  _getCard() async {
    ProgressDialogUtils.dismissProgressDialog();
    ProgressDialogUtils.showProgressDialog(context);
    ApiManager().getCard().then((value) {
      if (value.status == success) {
        ProgressDialogUtils.dismissProgressDialog();
        var response = value.response;

        if (response.data.length > 0) {
          _enableSaveButton = false;
        } else {
          setState(() {
            _enableSaveButton = true;
          });
        }
        for (var i = 0; i < value.response.data.length; i++) {
          list.add(CreditCard(
              nameOnCard: response.data[i].billingDetails.name,
              cardNumber: "**** **** ****" + response.data[i].card.last4,
              expiryDate: response.data[i].card.expMonth.toString() +
                  "/" +
                  response.data[i].card.expYear.toString(),
              cvv: "",
              customer: response.data[i].customer,
              id: response.data[i].id,
              type: getBrandType(response.data[i].card.brand)));
        }
        _initialApiCalled = true;
        setState(() {});
      }
    }).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      _initialApiCalled = true;
      setState(() {});
      if (e is ErrorModel) {
        if (e.response != null) {
          DialogUtils.showAlertDialog(context, e.response);
        }
      }
    });
  }

  _getInsurance() {
    Map req = <String, dynamic>{};
    req['userId'] = getString(PreferenceKey.id);
    ApiManager().myInsuranceList(req).then(
      (value) {
        setState(() {
          _myInsuranceList = value.response;
        });
      },
      onError: (e) {
        DialogUtils.showAlertDialog(context, "error getting insurance list");
      },
    );
  }

  void _saveCard() {
    ProgressDialogUtils.dismissProgressDialog();
    FocusManager.instance.primaryFocus.unfocus();

    if (_cvvController.text.length == 0 ||
        _nameController.text.length == 0 ||
        _expiryController.text.length == 0 ||
        _cardNumberController.text.length == 0) {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).addCardErrorMsg);

      return;
    }

    if (_keyExpiary.currentState.validate() &&
        _keyName.currentState.validate() &&
        _keyNumber.currentState.validate() &&
        _keyCVV.currentState.validate()) {
      ProgressDialogUtils.showProgressDialog(context);
      var _apiService = ApiServiceStripe();
      ReqCreateCardToken card;
      card = ReqCreateCardToken(
          card_exp_month: _expiryController.text.substring(0, 2),
          card_exp_year: _expiryController.text.substring(3),
          card_cvc: _cvvController.text,
          card_number: getCleanedNumber(_cardNumberController.text),
          card_name: _nameController.text);

      _apiService.sendCardDetails(card).then((value) {
        if (value.id != null) {
          ApiManager().addCard(ReqAddCard(token: value.id)).then((value) {
            ProgressDialogUtils.dismissProgressDialog();
            if (value.status == success) {
              _getCard();
            }
          }).catchError((dynamic e) {
            ProgressDialogUtils.dismissProgressDialog();
            if (e is ErrorModel) {
              if (e.response != null) {
                ProgressDialogUtils.dismissProgressDialog();
                DialogUtils.showAlertDialog(context, e.response);
              }
            }
          });
        }
      }).catchError((dynamic e) {
        ProgressDialogUtils.dismissProgressDialog();
        if (e is ErrorModelStripe) {
          if (e.error != null) {
            ProgressDialogUtils.dismissProgressDialog();
            DialogUtils.showAlertDialog(context, e.error.message);
          }
        }
      });
    } else {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, Localization.of(context).addCardErrorMsg);
    }
  }

  _onAddInsurance() async {
    var res = await NavigationUtils.push(context, routeInsuranceList);
    if (res != null) {
      if (res[ArgumentConstant.member] != null) {
        if (res[ArgumentConstant.member] is Insurance) {
          var insurance = res[ArgumentConstant.member] as Insurance;
          var req = ReqAddMyInsurance(
            insuranceId: insurance.sId,
            userId: getString(PreferenceKey.id),
          );
          ProgressDialogUtils.showProgressDialog(context);
          ApiManager().addInsurance(req).then(
            (value) {
              ProgressDialogUtils.dismissProgressDialog();
              DialogUtils.showOkCancelAlertDialog(
                context: context,
                message: "insurance added successfully",
                okButtonAction: () {
                  _getInsurance();
                },
                okButtonTitle: Localization.of(context).ok,
                isCancelEnable: false,
              );
            },
            onError: (e) {
              ProgressDialogUtils.dismissProgressDialog();
              DialogUtils.showAlertDialog(context, "unable to add insurance");
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppLogo(),
              Text(
                "Payment Methods",
                style: TextStyle(
                  fontSize: fontSize13,
                  fontWeight: fontWeightSemiBold,
                ),
              ),
              SizedBox(height: spacing15),
              Container(
                margin: EdgeInsets.only(left: spacing15),
                width: double.infinity,
                child: Text(
                  "Credit Card Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize18,
                    fontWeight: fontWeightSemiBold,
                  ),
                ),
              ),
              if (list.length > 0) _buildCardListDetails(),
              if (_initialApiCalled && _enableSaveButton) _buildCardDetails(),
              _buildAddCardRow(),
              SizedBox(height: spacing30),
              if(_initialApiCalled) _buildInsuranceDetails(),
              SizedBox(height: spacing15),
              _buildAddInsurance(),
              SizedBox(height: spacing15),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardListDetails() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getCardIcon(list[index].type),
                      SizedBox(width: spacing25),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              list[index].cardNumber,
                              style: TextStyle(
                                  fontSize: fontSize14,
                                  fontWeight: fontWeightSemiBold),
                            ),
                            Text(
                              list[index].expiryDate,
                              style: TextStyle(
                                  fontSize: fontSize12,
                                  fontWeight: fontWeightRegular),
                            ),
                          ],
                        ),
                      ),
                      Radio(
                          value: index,
                          groupValue: _selectedCardIndex,
                          onChanged: (newvalue) {
                            setState(() {
                              _selectedCardIndex = newvalue;
                            });
                          })
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: spacing5),
                  padding: EdgeInsets.all(spacing15),
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 30,
                        color: colorLightGrey.withOpacity(0.2),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );

  Widget _buildCardDetails() => Container(
        margin: EdgeInsets.symmetric(horizontal: spacing15, vertical: 10),
        padding: EdgeInsets.all(spacing20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 30,
              color: colorLightGrey.withOpacity(0.2),
            )
          ],
        ),
        child: Column(
          children: [
            Form(
              autovalidate: true,
              key: _keyName,
              child: HutanoTextField(
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: FocusNode(),
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
                ],
                labelText: "Name on Card",
                controller: _nameController,
              ),
            ),
            SizedBox(height: 20),
            Form(
              autovalidate: true,
              key: _keyNumber,
              child: HutanoTextField(
                focusNode: FocusNode(),
                labelText: "Card Number",
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                controller: _cardNumberController,
                suffixIcon: FileConstants.icVisaCard,
                textInputFormatter: [
                  maskFormatter,
                  BlacklistingTextInputFormatter(RegExp('[\\.]')),
                  LengthLimitingTextInputFormatter(19),
                ],
                validationMethod: (number) {
                  return validateCardNumber(number, context);
                },
                suffixheight: 42,
                suffixwidth: 42,
              ),
            ),
            SizedBox(height: 20),
            Form(
              autovalidate: true,
              key: _keyExpiary,
              child: HutanoTextField(
                controller: _expiryController,
                textInputAction: TextInputAction.next,
                hintText: "mm/yy",
                textInputFormatter: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardMonthInputFormatter()
                ],
                validationMethod: (value) {
                  return validateDate(value, context);
                },
                focusNode: FocusNode(),
                labelText: "Expiration Date",
                suffixIcon: FileConstants.icDob,
              ),
            ),
            SizedBox(height: 20),
            Form(
              autovalidate: true,
              key: _keyCVV,
              child: HutanoTextField(
                focusNode: FocusNode(),
                controller: _cvvController,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validationMethod: (number) {
                  return validateCVV(number, context);
                },
                labelText: "CCV",
              ),
            )
          ],
        ),
      );

  Widget _buildAddCardRow() => Padding(
        padding: const EdgeInsets.only(left: spacing15),
        child: Row(
          children: [
            Image.asset(FileConstants.icAdd),
            SizedBox(width: spacing15),
            !_enableSaveButton
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _enableSaveButton = true;
                      });
                    },
                    child: Text(
                      "Additional Payment Methods",
                      style: TextStyle(
                        fontSize: fontSize14,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _saveCard,
                    child: Text(
                      "Save Card",
                      style: TextStyle(
                        fontSize: fontSize14,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                  )
          ],
        ),
      );

  Widget _buildInsuranceDetails() => Container(
        margin: EdgeInsets.symmetric(horizontal: spacing15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Your Insurance",
                  style: TextStyle(
                    fontSize: fontSize14,
                    fontWeight: fontWeightMedium,
                  ),
                ),
                Spacer(),
                Flexible(
                  child: Visibility(
                    visible: _myInsuranceList.length > 0 ? false : true,
                    child: RippleEffect(
                      onTap: _onAddInsurance,
                      child: TextWithImage(
                        image: FileConstants.icAdd,
                        label: 'Add Insurance',
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: spacing8),
            if (_myInsuranceList.length == 0)
              Container(
                height: 70,
                width: SizeConfig.screenWidth,
                child: Center(
                  child: Text(
                    "No insurance added",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize14,
                      fontWeight: fontWeightMedium,
                    ),
                  ),
                ),
              ),
            if (_myInsuranceList.length != 0)
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _myInsuranceList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      padding: EdgeInsets.all(spacing8),
                      margin: EdgeInsets.symmetric(vertical: spacing5),
                      child: Row(
                        children: [
                          Image.asset(
                            FileConstants.icInsuranceShield,
                            height: 64,
                            width: 64,
                          ),
                          SizedBox(width: spacing15),
                          Expanded(
                            child: Text(
                              _myInsuranceList[index].title ?? "",
                              style: TextStyle(
                                fontSize: fontSize14,
                                fontWeight: fontWeightMedium,
                              ),
                            ),
                          ),
                          Radio(
                              value: index,
                              groupValue: _selectedInsuranceIndex,
                              onChanged: (newvalue) {
                                setState(() {
                                  _selectedInsuranceIndex = newvalue;
                                  _selectedInsurance = _myInsuranceList[index];
                                });
                              }),
                          SizedBox(width: spacing10),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 30,
                            color: colorLightGrey.withOpacity(0.2),
                          )
                        ],
                      ),
                    );
                  }),
          ],
        ),
      );

  Widget _buildAddInsurance() => InkWell(
        onTap: () {
          if (_selectedInsurance != null) {
            NavigationUtils.push(context, routeUploadInsuranceImage,
                arguments: {
                  ArgumentConstant.insuranceId: _selectedInsurance?.sId ?? ""
                });
          } else {
            DialogUtils.showAlertDialog(context, "Please select insurance");
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: spacing15),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                FileConstants.icupload,
                color: accentColor,
                width: 17,
              ),
              SizedBox(width: spacing15),
              Text(
                "Upload Insurance Card",
                style: TextStyle(
                  fontSize: fontSize14,
                  fontWeight: fontWeightMedium,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.only(
          left: spacing15,
          right: spacing15,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          children: [
            HutanoButton(
              width: 55,
              height: 55,
              color: accentColor,
              iconSize: 20,
              buttonType: HutanoButtonType.onlyIcon,
              icon: FileConstants.icBackArrow,
              onPressed: () {
                NavigationUtils.pop(context);
              },
            ),
            Spacer(),
            HutanoButton(
              width: 140,
              label: Localization.of(context).next,
              onPressed: () {
                if (_selectedCardIndex == null || _selectedCardIndex == -1) {
                  DialogUtils.showAlertDialog(
                      context, Localization.of(context).selectCreditCard);
                  return;
                }
                NavigationUtils.push(context, routeCheckout, arguments: {
                  ArgumentConstant.card: list[_selectedCardIndex]
                });
              },
            ),
          ],
        ),
      );
}
