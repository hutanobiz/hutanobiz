import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hutano/src/widgets/app_logo.dart';

import '../../../apis/api_constants.dart';
import '../../../apis/api_manager.dart';
import '../../../apis/api_service_stripe.dart';
import '../../../apis/error_model.dart';
import '../../../apis/error_model_stripe.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/hutano_steps_header.dart';
import '../../../widgets/hutano_textfield.dart';
import 'model/req_add_card.dart';
import 'model/req_create_card_token.dart';
import 'provider/credit_card_provider.dart';
import 'utils/card_utils.dart';
import 'utils/input_formatters.dart';

class AddPaymentScreen extends StatefulWidget {
  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  var _paymentCard = CreditCard();

  List<CreditCard> mainList = [];
  List<CreditCard> addList = [];

  CardNumberInputFormatter maskFormatter = CardNumberInputFormatter();

  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();

  final GlobalKey<FormState> _keyCVV = GlobalKey();
  final GlobalKey<FormState> _keyExpiary = GlobalKey();
  final GlobalKey<FormState> _keyName = GlobalKey();
  final GlobalKey<FormState> _keyNumber = GlobalKey();

  var _enableButton = true;
  var _addCardVisible = false;
  var _saveCardVisible = true;
  var _isPaymentComplete = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_getCardTypeFrmNumber);
    addList.add(CreditCard());
    // _getCard();
  }

  void _getCardTypeFrmNumber() {
    String input = getCleanedNumber(_cardNumberController.text);
    CardType cardType = getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(children: [
                  AppLogo(),
                  SizedBox(
                    height: spacing10,
                  ),
                  HutanoProgressBar(progressSteps: HutanoProgressSteps.two),
                  SizedBox(
                    height: spacing15,
                  ),
                  HutanoHeaderInfo(
                    title: Localization.of(context).paymentOptions,
                    subTitle: _isPaymentComplete
                        ? Localization.of(context).complete
                        : Localization.of(context).addCreditCard,
                    subTitleFontSize: fontSize15,
                  ),
                  SizedBox(
                    height: spacing10,
                  ),
                  _buildCard(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: _getCreditCardField(),
                  ),
                  SizedBox(
                    height: spacing50,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: HutanoButton(
                      width: 55,
                      height: 55,
                      color: accentColor,
                      iconSize: 20,
                      buttonType: HutanoButtonType.onlyIcon,
                      icon: FileConstants.icForward,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

  _buildCard() {
    return Stack(
      children: [
        Image.asset(FileConstants.icCardBackground),
        Positioned(
          child: Text(
            _nameController.text,
            style: const TextStyle(color: colorBrown, fontSize: 12),
          ),
          bottom: 75,
          left: 30,
        ),
        Positioned(
          child: const Text(
            "Valid Thru",
            style: const TextStyle(color: colorBrown, fontSize: 12),
          ),
          bottom: 75,
          right: 40,
        ),
        Positioned(
          child: Text(
            _cardNumberController.text,
            style: const TextStyle(color: colorBrown, fontSize: 12),
          ),
          bottom: 50,
          left: 30,
        ),
        Positioned(
          child: Text(
            _expiryController.text,
            style: const TextStyle(color: colorBrown, fontSize: 12),
          ),
          bottom: 50,
          right: 50,
        ),
      ],
    );
  }

  _skipTaskNow() {
    Navigator.of(context).pushReplacementNamed(routeInviteFamilyMember);
  }

  Widget _getCreditCardField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _getCardList(),
        _addCardList(),
        SizedBox(
          height: spacing20,
        ),
        _getSaveCreditCardButton(),
      ],
    );
  }

  Widget _getCardList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: mainList.length,
        itemBuilder: (context, index) {
          return _buildDisplayCard(index);
        });
  }

  Widget _addCardList() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: addList.length,
        itemBuilder: (context, index) {
          return _buildAddCard();
        });
  }

  Widget _buildDisplayCard(int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 5, right: 10, top: spacing10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: spacing5, left: spacing5),
            child: getCardIcon(mainList[index].type),
          ),
          Column(
            children: [
              _displayNameOnCardTextField(index),
              SizedBox(
                height: spacing10,
              ),
              _displayTextFieldCardNumber(index),
              SizedBox(
                height: spacing10,
              ),
              _displayExpiary(index),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: spacing10, top: spacing10),
            child: Image.asset(
              FileConstants.icCardCheck,
              width: 16,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCard() {
    return Container(
        padding:
            EdgeInsets.only(bottom: 5, right: 10, top: spacing10, left: 10),
        child: Column(
          children: [
            _getNameOnCardTextField(),
            SizedBox(
              height: spacing15,
            ),
            _getTextFieldCardNumber(),
            SizedBox(
              height: spacing15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getExpirationDateTextField(),
                _getCVVTextField(),
              ],
            ),
          ],
        ));
  }

  Widget _getNameOnCardTextField() {
    return Form(
      autovalidate: true,
      key: _keyName,
      child: Container(
          child: HutanoTextField(
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next,
        controller: _nameController,
        textSize: fontSize12,
        floatingBehaviour: FloatingLabelBehavior.always,
        focusedBorderColor: colorGrey20,
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        labelText: Localization.of(context).nameOnCard,
        contentPadding: EdgeInsets.all(10),
      )),
    );
  }

  Widget _displayNameOnCardTextField(int index) {
    return Container(
        child: HutanoTextField(
      textInputType: TextInputType.text,
      textSize: fontSize12,
      isFieldEnable: false,
      controller: TextEditingController()..text = mainList[index].nameOnCard,
      floatingBehaviour: FloatingLabelBehavior.always,
      focusedBorderColor: colorGrey20,
      labelText: Localization.of(context).nameOnCard,
      contentPadding: EdgeInsets.all(10),
    ));
  }

  Widget _getTextFieldCardNumber() {
    return Form(
      autovalidate: true,
      key: _keyNumber,
      child: Container(
          child: HutanoTextField(
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.number,
        floatingBehaviour: FloatingLabelBehavior.always,
        focusedBorderColor: colorGrey20,
        controller: _cardNumberController,
        textInputFormatter: [
          maskFormatter,
          BlacklistingTextInputFormatter(RegExp('[\\.]')),
          LengthLimitingTextInputFormatter(19),
        ],
        labelText: Localization.of(context).cardNumber,
        contentPadding: EdgeInsets.all(10),
        validationMethod: (number) {
          return validateCardNumber(number, context);
        },
      )),
    );
  }

  Widget _displayTextFieldCardNumber(int index) {
    return Container(
        child: HutanoTextField(
      controller: TextEditingController()..text = mainList[index].cardNumber,
      textInputAction: TextInputAction.next,
      isFieldEnable: false,
      textInputType: TextInputType.number,
      floatingBehaviour: FloatingLabelBehavior.always,
      focusedBorderColor: colorGrey20,
      labelText: Localization.of(context).cardNumber,
      contentPadding: EdgeInsets.all(10),
    ));
  }

  Widget _getCVVTextField() {
    return Form(
      autovalidate: true,
      key: _keyCVV,
      child: HutanoTextField(
        width: SizeConfig.screenWidth / 2.6,
        controller: _cvvController,
        textInputType: TextInputType.number,
        textInputAction: TextInputAction.next,
        floatingBehaviour: FloatingLabelBehavior.always,
        focusedBorderColor: colorGrey20,
        textInputFormatter: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        validationMethod: (number) {
          return validateCVV(number, context);
        },
        labelText: Localization.of(context).cvv,
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _displayCVVTextField(int index) {
    return Form(
      autovalidate: true,
      child: Container(
          width: 100,
          padding: const EdgeInsets.only(
            left: spacing20,
          ),
          child: HutanoTextField(
            controller: TextEditingController()..text = mainList[index].cvv,
            floatingBehaviour: FloatingLabelBehavior.always,
            focusedBorderColor: colorGrey20,
            labelText: Localization.of(context).cvv,
            contentPadding: EdgeInsets.all(10),
          )),
    );
  }

  Widget _displayExpiary(int index) {
    return Container(
        width: SizeConfig.screenWidth / 1.8,
        child: HutanoTextField(
          isFieldEnable: false,
          controller: TextEditingController()
            ..text = mainList[index].expiryDate,
          floatingBehaviour: FloatingLabelBehavior.always,
          focusedBorderColor: colorGrey20,
          labelText: Localization.of(context).expiaryDate,
          contentPadding: EdgeInsets.all(10),
        ));
  }

  Widget _getPaymentAndTcTextField() {
    return Container(
      padding: const EdgeInsets.only(
        left: spacing20,
      ),
      child: RichText(
          text: TextSpan(
              text: Localization.of(context).paymentTermsAndCondition,
              style: TextStyle(
                  color: colorBlack85,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // open desired screen
                })),
    );
  }

  Widget _getExpirationDateTextField() {
    return Form(
      autovalidate: true,
      key: _keyExpiary,
      child: Container(
          width: SizeConfig.screenWidth / 2.6,
          child: HutanoTextField(
            controller: _expiryController,
            textInputAction: TextInputAction.next,
            floatingBehaviour: FloatingLabelBehavior.always,
            focusedBorderColor: colorGrey20,
            labelText: Localization.of(context).expiaryDate,
            contentPadding: EdgeInsets.all(10),
            hintText: "mm/yy",
            textInputFormatter: [
              WhitelistingTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              CardMonthInputFormatter()
            ],
            validationMethod: (value) {
              return validateDate(value, context);
            },
          )),
    );
  }

  _getSaveCreditCardButton() => Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: HutanoButton(
        icon: FileConstants.icNext,
        color: colorPurple100,
        iconSize: 20,
        label: Localization.of(context).addCard.toUpperCase(),
        onPressed: () => setState(() {
          _saveCard();
        }),
      ));

  _nextClick() {
    if (mainList.length > 0) {
      Navigator.of(context).pushReplacementNamed(routeInviteFamilyMember);
    } else {
      DialogUtils.showAlertDialog(
          context, Localization.of(context).addCardDetails.toUpperCase());
    }
  }

  _getCard() {
    ApiManager().getCard().then((value) {
      if (value.status == success) {
        ProgressDialogUtils.dismissProgressDialog();
        var response = value.response;
        List<CreditCard> list = [];
        for (var i = 0; i < value.response.data.length; i++) {
          list.add(CreditCard(
              nameOnCard: response.data[i].billingDetails.name,
              cardNumber: "**** **** ****" + response.data[i].card.last4,
              expiryDate: response.data[i].card.expMonth.toString() +
                  "/" +
                  response.data[i].card.expYear.toString(),
              cvv: "",
              type: getBrandType(response.data[i].card.brand)));
        }
        setState(() {
          mainList = list;
          addList.clear();
          _saveCardVisible = false;
          _addCardVisible = true;
          resetFilds();
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        if (e.response != null) {
          ProgressDialogUtils.dismissProgressDialog();
          DialogUtils.showAlertDialog(context, e.response);
        }
      }
    });
  }

  void _saveCard() {
    FocusManager.instance.primaryFocus.unfocus();

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
            if (value.status == success) {
              _isPaymentComplete = true;
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

  void resetFilds() {
    _cardNumberController.clear();
    _nameController.clear();
    _cvvController.clear();
    _expiryController.clear();
  }
}
