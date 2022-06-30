import 'package:flutter/material.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/add_insurance/add_insruance.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class PaymentMethodScreen extends StatefulWidget {
  final dynamic
      args; //0 , 1- normal payment, 2-change payment, 3-reschedule pay

  PaymentMethodScreen({Key? key, this.args}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int? _radioValue;
  int? _listRadioValue;
  int? _cardListRadioValue;
  dynamic selectedCard;
  Future<dynamic>? _insuranceFuture, _cardFuture;
  ApiBaseHelper _api = ApiBaseHelper();
  late InheritedContainerState _container;
  String? insuranceId, insuranceImage, insuranceName;

  bool _isLoading = false;
  Map? providerMap;
  String? name, avatar, cashPayment = "0";
  double? totalFee = 0.0;

  Map<String, dynamic>? _profileMap = {};

  List? _providerInsuranceList = [];

  List? _insuranceList = [];

  int? isPayment = 0;

  bool insuranceAdded = false;
  int? hutanoCash = 0;
  int _huntaoCashRadioValue = 1;
  int _huntaoCashRadioGrupValue = 0;

  @override
  void initState() {
    super.initState();
    _getHutanoCash();
  }

  _getHutanoCash() {
    ApiManager().getHutanoCash().then((value) {
      if (value.status == success) {
        setState(() {
          hutanoCash = value.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        if (e.response != null) {
          DialogUtils.showAlertDialog(context, e.response!);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (widget.args['paymentType'] != null) {
      isPayment = widget.args['paymentType'];
    }

    if (isPayment != 0) {
      Map _providerData = _container.getProviderData();
      Map _servicesMap = _container.selectServiceMap;

      if (_providerData["providerData"]["data"] != null) {
        _providerData["providerData"]["data"].map((f) {
          _profileMap!.addAll(f);
        }).toList();
      } else {
        _profileMap = _providerData["providerData"];
      }

      if (_servicesMap["status"].toString() == "1") {
        if (_servicesMap["services"] != null) {
          List<Services> _servicesList = _servicesMap["services"];

          totalFee = _servicesList.fold(
              0, ((sum, item) => sum + double.parse(item.amount.toString())) as double? Function(double?, Services));
        }
      } else if (_servicesMap["status"].toString() == "2") {
      } else {
        List _consultaceList = _servicesMap["consultaceFee"];

        totalFee = _consultaceList[0]["fee"].toDouble();
      }

      if (_profileMap!["paymentMethod"] != null) {
        cashPayment =
            _profileMap!["paymentMethod"]["cashPayment"]?.toString() ?? "0";
      }

      if (_profileMap!["insuranceId"] != null) {
        _providerInsuranceList = _profileMap!["insuranceId"];
        _container.setProviderInsuranceMap(_providerInsuranceList);
      }
    }

    SharedPref().getToken().then((token) {
      setState(() {
        _insuranceFuture = _api.getUserDetails(token).futureError(
              (error) => error.toString().debugLog(),
            );
        _cardFuture = _api.getPatientCard(token).futureError(
              (error) => error.toString().debugLog(),
            );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        addHeader: true,
        isLoading: _isLoading,
        title: isPayment != 0 ? "Select Payment Methods" : "Payment Methods",
        isAddBack: isPayment == 0,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: isPayment != 0 ? 60.0 : 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _widgetList(),
                ),
              ),
            ),
            isPayment == 0
                ? Container()
                : Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width - 76.0,
                      padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                      child: FancyButton(
                        title: "Continue",
                        onPressed: () {
                          Map _paymentMap = new Map();

                          if (_radioValue != null) {
                            if (isPayment == 2 || isPayment == 3) {
                              Map<String, dynamic> map = {};
                              map['appointmentId'] =
                                  widget.args['appointmentId'];
                              map['paymentMethod'] = '3';
                              map['paymentMethodId'] = null;
                              updatePaymentMethod(map);
                            } else {
                              _paymentMap["paymentType"] = "3";

                              _container.setConsentToTreatData(
                                  "paymentMap", _paymentMap);

                              Navigator.of(context)
                                  .pushNamed(Routes.appointmentConfirmation);
                            }
                          } else if (_cardListRadioValue != null) {
                            if (isPayment == 2 || isPayment == 3) {
                              Map<String, dynamic> map = {};
                              map['appointmentId'] =
                                  widget.args['appointmentId'];
                              map['paymentMethod'] = '1';
                              map['paymentMethodId'] = selectedCard;
                              updatePaymentMethod(map);
                            } else {
                              _paymentMap["paymentType"] = "1";
                              _paymentMap["selectedCard"] = selectedCard;

                              _container.setConsentToTreatData(
                                  "paymentMap", _paymentMap);
                              Navigator.of(context)
                                  .pushNamed(Routes.appointmentConfirmation);
                            }
                          } else if (_listRadioValue != null) {
                            if (isPayment == 2 || isPayment == 3) {
                              Map<String, dynamic> map = {};
                              map['appointmentId'] =
                                  widget.args['appointmentId'];
                              map['paymentMethod'] = '2';
                              map['paymentMethodId'] = insuranceId;
                              updatePaymentMethod(map);
                            } else {
                              _paymentMap["paymentType"] = "2";
                              _paymentMap["insuranceId"] = insuranceId;
                              _paymentMap["insuranceName"] = insuranceName;
                              _paymentMap["insuranceImage"] = insuranceImage;

                              _container.setConsentToTreatData(
                                  "paymentMap", _paymentMap);

                              Navigator.of(context)
                                  .pushNamed(Routes.appointmentConfirmation);
                            }
                          } else {
                            Widgets.showToast("Please select a payment method");
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  updatePaymentMethod(Map<String, dynamic> map) {
    setState(() {
      _isLoading = true;
    });

    ApiManager().updatePaymentMethod(map).then(((result) {
      setState(() {
        _isLoading = false;
      });
      if (isPayment == 3) {
        Navigator.pop(context);
      }
      Navigator.pop(context);
    })).catchError((dynamic e) {
      setState(() {
        _isLoading = false;
      });
      if (e is ErrorModel) {
        Widgets.showErrorialog(
          context: context,
          description: e.response,
        );
        e.toString().debugLog();
      }
    });
  }

  List<Widget> _widgetList() {
    List<Widget> _widgetList = [];

    _widgetList.add(
      Text(
        "Saved Cards",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.93),
        ),
      ),
    );

    _widgetList.add(SizedBox(height: 12.0));

    _widgetList.add(_cardFutureWidget());

    _widgetList.add(SizedBox(height: 22.0));

    _widgetList.add(addCard("ic_add_card", "Add New Card"));

    _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(Text(
      isPayment == 0 &&
              (_providerInsuranceList == null || _providerInsuranceList!.isEmpty)
          ? 'Insurance'
          : "Your Insurance",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.93),
      ),
    ));

    _widgetList.add(SizedBox(height: 8.0));

    _widgetList.add(isPayment != 0 &&
            (_providerInsuranceList == null || _providerInsuranceList!.isEmpty)
        ? Container()
        : _insuranceFutureWidget());

    _widgetList.add(isPayment != 0 &&
            (_providerInsuranceList == null || _providerInsuranceList!.isEmpty)
        ? Container()
        : SizedBox(height: 10.0));

    _widgetList.add(isPayment != 0 &&
            (_providerInsuranceList == null || _providerInsuranceList!.isEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "Your providers does not accept your insurance. Please select your saved credit or add a new credit card for payment.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : addCard("ic_upload_insurance", "Upload Insurance Card"));

    _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(paymentCard(
      "ic_cash_payment",
      "Cash/Check",
      2,
    ));

    var hutanoCashTitle = 'Hutano Cash (\$${hutanoCash.toString()})';
    _widgetList.add(hutanoCashWidget(
      "ic_cash_payment",
      hutanoCashTitle,
      0,
    ));

    return _widgetList;
  }

  Widget _cardFutureWidget() {
    return FutureBuilder<dynamic>(
      future: _cardFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("NO data available");
            break;
          case ConnectionState.waiting:
            return Center(
              child: CustomLoader(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text("NO saved insurance available"),
                );
              }
              List? _cardList = snapshot.data['data'];

              if (_cardList == null || _cardList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text("NO saved Card available"),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 17),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _cardList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Row(
                        children: <Widget>[
                          'ic_dummy_card'.imageIcon(width: 70, height: 70),
                          SizedBox(width: 17.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "**** ***** **** ${_cardList[index]['card']['last4']}",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "Expires ${_cardList[index]['card']['exp_month']}/${_cardList[index]['card']['exp_year']}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isPayment == 0
                              ? Icon(Icons.delete, color: AppColors.windsor)
                                  .onClick(onTap: () {
                                  Widgets.showConfirmationDialog(
                                      context: context,
                                      title: "Delete Card",
                                      description:
                                          "Are you sure you want to delete the Card?",
                                      onLeftPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        SharedPref().getToken().then((token) {
                                          _api
                                              .deleteStripeCard(
                                                  token, _cardList[index]['id'])
                                              .then((value) {
                                            setState(() {
                                              _isLoading = false;
                                              _cardFuture = _api
                                                  .getPatientCard(token)
                                                  .timeout(
                                                      Duration(seconds: 10));
                                            });
                                          });
                                        });
                                      });
                                })
                              : Radio(
                                  activeColor: AppColors.windsor,
                                  value: index,
                                  groupValue: _cardListRadioValue,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _radioValue = null;
                                      _listRadioValue = null;
                                      _cardListRadioValue = value;
                                    });

                                    selectedCard = _cardList[index];
                                  },
                                )
                        ],
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              snapshot.error.toString().debugLog();
              return Center(
                child: Text("NO data available"),
              );
            }

            break;
        }
        return Container();
      },
    );
  }

  Widget _insuranceFutureWidget() {
    Map _insuranceViewMap = {};
    _insuranceViewMap['isPayment'] = isPayment != 0;
    _insuranceViewMap['isViewDetail'] = true;

    return FutureBuilder<dynamic>(
      future: _insuranceFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("NO data available");
            break;
          case ConnectionState.waiting:
            return Center(
              child: CustomLoader(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text("NO saved insurance available"),
                );
              }
              _insuranceList = snapshot.data['insuranceData'];

              if (_insuranceList == null || _insuranceList!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text("NO saved insurance available"),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 17),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _insuranceList!.length,
                  itemBuilder: (context, index) {
                    if (insuranceAdded) {
                      _radioValue = null;
                      _cardListRadioValue = null;
                      _listRadioValue = _insuranceList!.length - 1;

                      insuranceId = _insuranceList![_insuranceList!.length - 1]
                          ["insuranceId"];
                      insuranceName = _insuranceList![_insuranceList!.length - 1]
                          ["insuranceName"];
                      insuranceImage = _insuranceList![_insuranceList!.length - 1]
                          ["insuranceDocumentFront"];
                    }

                    insuranceAdded = false;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        isPayment == 0
                            ? Container()
                            : !_providerInsuranceList!.contains(
                                    _insuranceList![index]["insuranceId"]
                                        .toString())
                                ? Text(
                                    "Insurance not accepted by the provider",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Container(),
                        isPayment == 0
                            ? Container()
                            : _providerInsuranceList!.contains(
                                    _insuranceList![index]["insuranceId"]
                                        .toString())
                                ? Container()
                                : SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0)),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  _insuranceList![index]
                                              ["insuranceDocumentFront"] !=
                                          null
                                      ? ApiBaseHelper.imageUrl +
                                          _insuranceList![index]
                                              ["insuranceDocumentFront"]
                                      : ApiBaseHelper.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 17.0),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _insuranceList![index]["insuranceName"]
                                          ?.toString() ??
                                      '---',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: isPayment == 0
                                      ? PopupMenuButton<String>(
                                          onSelected: ((val) {
                                            handleClick(
                                                val, _insuranceList![index]);
                                          }),
                                          itemBuilder: (BuildContext context) {
                                            return {'Remove'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                        )
                                      // Icon(
                                      //     Icons.arrow_forward_ios,
                                      //     color: Colors.grey,
                                      //     size: 16,
                                      //   )
                                      : (!_providerInsuranceList!.contains(
                                              _insuranceList![index]
                                                      ["insuranceId"]
                                                  .toString())
                                          ? Container()
                                          : Radio(
                                              activeColor: AppColors.windsor,
                                              value: index,
                                              groupValue: _listRadioValue,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onChanged: (int? value) {
                                                setState(() {
                                                  _radioValue = null;
                                                  _cardListRadioValue = null;
                                                  _listRadioValue = value;
                                                });

                                                insuranceId =
                                                    _insuranceList![index]
                                                        ["insuranceId"];
                                                insuranceName =
                                                    _insuranceList![index]
                                                        ["insuranceName"];
                                                insuranceImage = _insuranceList![
                                                        index]
                                                    ["insuranceDocumentFront"];
                                              },
                                            )),
                                ),
                              )
                            ],
                          ).onClick(
                            onTap: isPayment == 0
                                ? null
                                : () {
                                    _insuranceViewMap['insurance'] =
                                        _insuranceList![index];

                                    if (_container.insuranceDataMap != null) {
                                      _container.insuranceDataMap.clear();
                                    }

                                    Navigator.of(context)
                                        .pushNamed(
                                      Routes.uploadInsuranceImagesScreen,
                                      arguments: _insuranceViewMap,
                                    )
                                        .whenComplete(() {
                                      SharedPref().getToken().then((token) {
                                        setState(() {
                                          _insuranceFuture = _api
                                              .getUserDetails(token)
                                              .timeout(Duration(seconds: 10));
                                        });
                                      });
                                    });
                                  },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              snapshot.error.toString().debugLog();
              return Center(
                child: Text("NO data available"),
              );
            }

            break;
        }
        return Container();
      },
    );
  }

  void handleClick(String value, dynamic _insurance) {
    switch (value) {
      // case 'Edit':
      //   Map _insuranceViewMap = {};
      //   _insuranceViewMap['isPayment'] = isPayment != 0;
      //   _insuranceViewMap['isViewDetail'] = true;
      //   _insuranceViewMap['insurance'] = _insurance;

      //   if (_container.insuranceDataMap != null) {
      //     _container.insuranceDataMap.clear();
      //   }

      //   Navigator.of(context)
      //       .pushNamed(
      //     Routes.uploadInsuranceImagesScreen,
      //     arguments: _insuranceViewMap,
      //   )
      //       .whenComplete(() {
      //     SharedPref().getToken().then((token) {
      //       setState(() {
      //         _insuranceFuture =
      //             _api.getUserDetails(token).timeout(Duration(seconds: 10));
      //       });
      //     });
      //   });
      //   break;
      case 'Remove':
        Widgets.showConfirmationDialog(
          context: context,
          title: 'Delete Insurance',
          description: "Are you sure you want to delete the insurance?",
          onLeftPressed: () {
            setState(() {
              _isLoading = true;
            });

            SharedPref().getToken().then((token) {
              _api.insuranceRemove(token, _insurance['_id']).then((value) {
                setState(() {
                  _isLoading = false;
                  _insuranceFuture =
                      _api.getUserDetails(token).timeout(Duration(seconds: 10));
                });
              });
            });
          },
        );
        break;
    }
  }

  Widget paymentCard(String imageIcon, String title, int value,
      {String? cardExpiryDate}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: <Widget>[
          imageIcon.imageIcon(width: 70, height: 70),
          SizedBox(width: 17.0),
          title.toLowerCase().contains("cash")
              ? Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      cardExpiryDate!,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
          isPayment == 0
              ? Container()
              : Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Radio(
                        activeColor: AppColors.windsor,
                        value: value,
                        groupValue: _radioValue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (title.toLowerCase().contains("cash") &&
                                cashPayment == "1")
                            ? _handleRadioValueChange
                            : null),
                  ),
                )
        ],
      ),
    );
  }

  Widget addCard(String icon, String title) {
    return FlatButton.icon(
      onPressed: () {
        Map _insuranceMap = {};
        _insuranceMap['isPayment'] = isPayment != 0;
        _insuranceMap['insuranceList'] = _insuranceList;

        title.toLowerCase().contains("insurance")
            ? Navigator.of(context).pushNamed(Routes.addInsurance, arguments: {
                ArgumentConstant.argsinsuranceType: InsuranceType.secondary,
                ArgumentConstant.isFromSetting: true
              }).whenComplete(
                () => SharedPref().getToken().then(
                  (token) {
                    setState(() {
                      _listRadioValue = null;
                      _radioValue = null;
                      _cardListRadioValue = null;

                      _insuranceFuture = _api
                          .getUserDetails(token)
                          .timeout(Duration(seconds: 20));

                      insuranceAdded = true;
                    });
                  },
                ),
              )
            : Navigator.of(context)
                .pushNamed(Routes.addNewCardScreen)
                .whenComplete(
                () {
                  SharedPref().getToken().then(
                    (token) {
                      setState(() {
                        _listRadioValue = null;
                        _radioValue = null;
                        _cardListRadioValue = null;
                        _cardFuture = _api
                            .getPatientCard(token)
                            .timeout(Duration(seconds: 20));
                      });
                    },
                  );
                },
              );
      },
      icon: icon.imageIcon(
        width: 20.0,
        height: 20.0,
      ),
      label: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.93),
        ),
      ),
    );
  }

  void showThankDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                "ic_feedback_done".imageIcon(
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 15),
                Text(
                  "Payment Completed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "\$$totalFee Paid on " +
                      DateFormat("dd").format(DateTime.now()) +
                      "th " +
                      DateFormat("MMMM").format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 26),
                ClipOval(
                  child: avatar == null
                      ? "profile_user".imageIcon(
                          height: 38,
                          width: 38,
                        )
                      : Image.network(
                          ApiBaseHelper.imageUrl + avatar!,
                          height: 38,
                          width: 38,
                        ),
                ),
                SizedBox(height: 6),
                Text(
                  name!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 26),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: AppColors.goldenTainoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRadioValueChange(int? value) => setState(() {
        _radioValue = value;
        _listRadioValue = null;
        _cardListRadioValue = null;
      });

  Widget hutanoCashWidget(String imageIcon, String title, int value) {
    return GestureDetector(
      onTap: () {
        if (isPayment == 0) {
        } else {
          if (hutanoCash == 0) {
            _container.setConsentToTreatData("hutanoCashApplied", false);
            Widgets.showErrorDialog(
                context: context, description: 'Insufficient Points');
            return;
          }
          var value = (_huntaoCashRadioGrupValue == 0) ? 1 : 0;
          setState(() {
            _huntaoCashRadioGrupValue = value;
          });
          _container.setConsentToTreatData("hutanoCashApplied", value);
          _container.setConsentToTreatData("hutanoCash", hutanoCash);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: <Widget>[
            imageIcon.imageIcon(width: 70, height: 70),
            SizedBox(width: 17.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            isPayment == 0
                ? Container()
                : Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Radio(
                          activeColor: AppColors.windsor,
                          value: _huntaoCashRadioValue,
                          groupValue: _huntaoCashRadioGrupValue,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (dynamic val) {}),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
