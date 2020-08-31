import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/stripe/payment_intent.dart';
import 'package:hutano/screens/stripe/payment_method.dart';
import 'package:hutano/screens/stripe/stripe_payment.dart';
import 'package:hutano/screens/stripe/token.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/mask_input_formatter.dart';
import 'package:hutano/widgets/widgets.dart';

class AddNewCardScreen extends StatefulWidget {
  AddNewCardScreen({Key key}) : super(key: key);

  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  MaskedTextInputFormatter maskFormatter =
      MaskedTextInputFormatter(mask: 'xxxx-xxxx-xxxx-xxxx', separator: '-');

  final GlobalKey<FormFieldState> _cardNumberKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cardNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _expiryDateKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _cvvKey = GlobalKey<FormFieldState>();
  ApiBaseHelper api = ApiBaseHelper();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  Future<dynamic> _profileFuture;
  int count = 0;
  bool isInitialLoad = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _cardController.addListener(() {
      setState(() {});
    });

    _nameController.addListener(() {
      setState(() {});
    });

    _expiryController.addListener(() {
      setState(() {});
    });

    _cvvController.addListener(() {
      setState(() {});
    });

    StripePayment.setOptions(
      StripeOptions(
        publishableKey: kstripePublishKey,
      ),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
          title: "",
          isLoading: _isLoading,
          isAddBack: true,
          addBackButton: false,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Add New Card',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 21.0),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                border: Border.all(color: Colors.grey[300])),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 20.0, 16.0, 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                      key: _cardNameKey,
                                      autovalidate:
                                          _nameController.text.isNotEmpty,
                                      validator: Validations.validateEmpty,
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: "Name On Card",
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      onChanged: (text) {
                                        setState(() {});
                                      }),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                      controller: _cardController,
                                      key: _cardNumberKey,
                                      autovalidate: true,
                                      keyboardType: TextInputType.number,
                                      validator: Validations.validateCardNumber,
                                      inputFormatters: [
                                        maskFormatter,
                                        BlacklistingTextInputFormatter(
                                            RegExp('[\\.]')),
                                        LengthLimitingTextInputFormatter(19),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: "Credit Card Number",
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      onChanged: (text) {
                                        setState(() {});
                                      }),
                                  SizedBox(height: 20.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                            controller: _expiryController,
                                            key: _expiryDateKey,
                                            autovalidate: true,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: false),
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  4),
                                              CardMonthInputFormatter()
                                            ],
                                            validator: Validations.validateDate,
                                            decoration: InputDecoration(
                                              labelText: "Expire Date",
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onChanged: (text) {
                                              setState(() {});
                                            }),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                            controller: _cvvController,
                                            key: _cvvKey,
                                            autovalidate: true,
                                            keyboardType: TextInputType.number,
                                            validator: Validations.validateCVV,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: "CVV",
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onChanged: (text) {
                                              setState(() {});
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FancyButton(
                  buttonHeight: 50,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (disableButton()) {
                      setState(() {
                        _isLoading = true;
                      });

                      FocusScope.of(context).unfocus();
                      CreditCard creditCard = CreditCard();
                      creditCard.name = _nameController.text;
                      creditCard.number =
                          Validations.getCleanedNumber(_cardController.text);
                      creditCard.cvc = _cvvController.text;
                      creditCard.expMonth =
                          int.parse(_expiryController.text.substring(0, 2));
                      creditCard.expYear =
                          int.parse(_expiryController.text.substring(3));

                      SharedPref().getToken().then((token) {
                        api.getSetupIntent(context, token).then((value) {
                          String clientSecret = value['client_secret'];

                          var pmr = PaymentMethodRequest(card: creditCard);
                          var _paymentIntent = PaymentIntent(
                            paymentMethod: pmr,
                            clientSecret: clientSecret,
                          );
                          StripePayment.confirmSetupIntent(_paymentIntent)
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pop(context);
                            // api
                            //     .getCardList(context, token)
                            //     .then((cardList) {
                            //      if(cardList.length>0){
                            //   var map = {};
                            //   map['price'] =
                            //       'price_1HBvKWGZaHJs1pLTPsUEd4XW';
                            //   map['type'] = '2';
                            //   map['quantity'] = count.toString();
                            //   map['default_payment_method'] =
                            //       cardList.first['paymentMethodId'];

                            //   api
                            //       .createStripeSubscription(
                            //           context, token, map)
                            //       .then((value) {
                            //     Widgets.showErrorialog(
                            //         context: context,
                            //         buttonText: 'Ok',
                            //         onPressed: () {
                            //           Navigator.of(context).pushNamed(
                            //               Routes
                            //                   .autoAcceptAppointmentType,
                            //               arguments: false);
                            //         },
                            //         title: '',
                            //         description: 'Subscribed');
                            //   })
                            //         .futureError((error) {
                            //           setState(() {
                            //             _isLoading = false;
                            //           });
                            //           Widgets.showErrorialog(
                            //             context: context,
                            //             description: error.toString(),
                            //           );
                            //           error.toString().debugLog();
                            //         });
                            //       }
                            //       else{
                            //          setState(() {
                            //             _isLoading = false;
                            //           });
                            //          Widgets.showErrorialog(
                            //             context: context,
                            //             description: 'Empty Card List',
                            //           );
                            //       }
                            // });
                          }).futureError((error) {
                            setState(() {
                              _isLoading = false;
                            });
                            Widgets.showErrorialog(
                              context: context,
                              description: error.toString(),
                            );
                            error.toString().debugLog();
                          });
                        }).futureError((error) {
                          setState(() {
                            _isLoading = false;
                          });
                          error.toString().debugLog();
                        });
                      });
                    }
                  },
                  title: 'Add Account',
                ),
              )
            ],
          )
          //   }
          // } else if (snapshot.hasError) {
          //   return Text("${snapshot.error}");
          // } else {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          //},
          // ),
          ),
    );
  }

  bool disableButton() {
    if (_cardController.text.isEmpty) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter the Card number',
      );
      return false;
    } else if (_cardNumberKey.currentState == null ||
        !_cardNumberKey.currentState.validate()) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter a valid card number',
      );
      return false;
    } else if (_nameController.text.isEmpty) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter the Card holder name',
      );
      return false;
    } else if (_cardNameKey.currentState == null ||
        !_cardNameKey.currentState.validate()) {
      Widgets.showErrorialog(
        context: context,
        description: "Card holder name can't be empty",
      );
      return false;
    } else if (_expiryController.text.isEmpty) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter the Card expiry date',
      );
      return false;
    } else if (_expiryDateKey.currentState == null ||
        !_expiryDateKey.currentState.validate()) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter the valid expiry date',
      );
      return false;
    } else if (_cvvController.text.isEmpty) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter the CVV',
      );
      return false;
    } else if (_cvvKey.currentState == null ||
        !_cvvKey.currentState.validate()) {
      Widgets.showErrorialog(
        context: context,
        description: 'Please enter a valid CVV',
      );
      return false;
    } else {
      return true;
    }
  }
}
