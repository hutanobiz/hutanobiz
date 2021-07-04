import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/payment/card_utils.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';
import 'package:hutano/widgets/text_with_image.dart';

class MyCreditCard {
  String nameOnCard;
  String cardNumber;
  String expiryDate;
  String cvv;
  CardType type;
  String id;
  String customer;

  MyCreditCard({
    this.nameOnCard = "",
    this.cardNumber = "",
    this.expiryDate,
    this.cvv,
    this.type = CardType.Others,
    this.customer = "",
    this.id = "",
  });
}

class AddCardComplete extends StatefulWidget {
  @override
  _AddCardCompleteState createState() => _AddCardCompleteState();
}

class _AddCardCompleteState extends State<AddCardComplete> {
  List<MyCreditCard> cardList = [];
  ApiBaseHelper api = ApiBaseHelper();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCard();
    });
  }

  _getCard() {
    SharedPref().getToken().then((token) {
      setState(() {
        ProgressDialogUtils.showProgressDialog(context);
        api.getCard(context, token).then((value) {
          if (value.status == 'success') {
            ProgressDialogUtils.dismissProgressDialog();
            var response = value.response;
            List<MyCreditCard> list = [];
            for (var i = 0; i < value.response.data.length; i++) {
              list.add(MyCreditCard(
                  nameOnCard: response.data[i].billingDetails.name ?? '',
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
      });
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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(children: [
                  AppHeader(
                    progressSteps: HutanoProgressSteps.two,
                    title: Strings.paymentOptions,
                    subTitle: Strings.creditCardAdded,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundSuccess(),
                  SizedBox(
                    height: 50,
                  ),
                  TextWithImage(
                      size: 30,
                      imageSpacing: 13,
                      textStyle: AppTextStyle.boldStyle(
                        fontSize: 15,
                      ),
                      label: Strings.creditCard,
                      image: FileConstants.icCreditCard),
                  SizedBox(
                    height: 10,
                  ),
                  _buildCardListDetails(),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: HutanoButton(
                      width: 55,
                      height: 55,
                      color: AppColors.accentColor,
                      iconSize: 20,
                      buttonType: HutanoButtonType.onlyIcon,
                      icon: FileConstants.icForward,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.inviteFamilyMember);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
                    SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            cardList[index].cardNumber,
                            style: AppTextStyle.semiBoldStyle(
                              fontSize: 14,
                              color: AppColors.colorBorder2,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Text(
                            cardList[index].nameOnCard,
                            style: AppTextStyle.semiBoldStyle(
                              fontSize: 14,
                              color: AppColors.colorBorder2,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Expires ${cardList[index].expiryDate}',
                            style: AppTextStyle.regularStyle(
                              fontSize: 12,
                              color: AppColors.colorBorder2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 30,
                      color: AppColors.colorLightGrey.withOpacity(0.2),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
}
