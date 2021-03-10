import 'package:flutter/material.dart';
import 'package:hutano/src/apis/api_constants.dart';
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/ui/registration_steps/payment/provider/credit_card_provider.dart';
import 'package:hutano/src/ui/registration_steps/payment/utils/card_utils.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/utils/progress_dialog.dart';
import 'package:hutano/src/widgets/app_logo.dart';
import 'package:hutano/src/widgets/hutano_button.dart';
import 'package:hutano/src/widgets/hutano_header_info.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';
import 'package:hutano/src/widgets/round_success.dart';
import 'package:hutano/src/widgets/text_with_image.dart';

class AddCardComplete extends StatefulWidget {
  @override
  _AddCardCompleteState createState() => _AddCardCompleteState();
}

class _AddCardCompleteState extends State<AddCardComplete> {
  List<CreditCard> cardList = [];

  @override
  void initState() {
    super.initState();
    // _getCard();
    cardList.add(CreditCard(
        cardNumber: "**** **** **** 4234",
        cvv: "234",
        customer: "TEST",
        expiryDate: "11/22",
        nameOnCard: "asd",
        type: CardType.AmericanExpress));
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
          cardList = list;
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
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
                    subTitle: Localization.of(context).creditCardAdded,
                    subTitleFontSize: fontSize15,
                  ),
                  SizedBox(
                    height: spacing10,
                  ),
                  RoundSuccess(),
                  SizedBox(
                    height: spacing50,
                  ),
                  TextWithImage(
                      size: spacing30,
                      imageSpacing: 13,
                      textStyle: TextStyle(
                          fontSize: fontSize15, fontWeight: fontWeightBold),
                      label: Localization.of(context).creditCard,
                      image: FileConstants.icCreditCard),
                  SizedBox(
                    height: spacing10,
                  ),
                  _buildCardListDetails(),
                  SizedBox(
                    height: spacing20,
                  ),
                  TextWithImage(
                      size: spacing30,
                      imageSpacing: 13,
                      textStyle: TextStyle(
                          fontSize: fontSize15, fontWeight: fontWeightBold),
                      label: Localization.of(context).labelHealthInsurance,
                      image: FileConstants.icInsuranceBlue),
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

  Widget _buildCardListDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cardList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCardIcon(cardList[index].type),
                    SizedBox(width: spacing25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            cardList[index].cardNumber,
                            style: TextStyle(
                                fontSize: fontSize14,
                                color: colorBorder2,
                                fontWeight: fontWeightSemiBold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Text(
                            cardList[index].customer,
                            style: TextStyle(
                                fontSize: fontSize14,
                                color: colorBorder2,
                                fontWeight: fontWeightSemiBold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Expires ${cardList[index].expiryDate}',
                            style: TextStyle(
                                fontSize: fontSize12,
                                color: colorBorder2,
                                fontWeight: fontWeightRegular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: spacing5),
                padding: EdgeInsets.all(spacing15),
                width: double.infinity,
                height: 120,
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
      );
}
