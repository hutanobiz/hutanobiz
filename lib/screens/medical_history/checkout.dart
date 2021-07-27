import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/payment/provider/credit_card_provider.dart';
import 'package:hutano/screens/registration/payment/utils/card_utils.dart';
import 'package:provider/provider.dart';

import '../../apis/api_constants.dart';
import '../../apis/api_manager.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/localization/localization.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/hutano_button.dart';
import 'model/req_pay_appointment.dart';
import 'provider/appoinment_provider.dart';

class Checkout extends StatefulWidget {
  final MyCreditCard card;

  const Checkout({Key key, this.card}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int _selectedCardIndex;
  List<MyCreditCard> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      list.add(widget.card);
      _selectedCardIndex = 0;
      setState(() {});
    });
  }

  _payAmount() async {
    if (_selectedCardIndex == null || _selectedCardIndex == -1) {
      return;
    }

    final appointmentId =
        Provider.of<SymptomsInfoProvider>(context, listen: false).appoinmentId;
    final request = ReqPayAppointmnet(
        amount: '80',
        appointmentId: appointmentId,
        customer: list[_selectedCardIndex].customer,
        token: list[_selectedCardIndex].id);

    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().payAppointment(request);
      ProgressDialogUtils.dismissProgressDialog();
      if (res.response != null) {
        DialogUtils.showOkCancelAlertDialog(
            context: context,
            message: Localization.of(context).appointmentSuccess,
            isCancelEnable: false,
            okButtonTitle: Localization.of(context).ok,
            okButtonAction: () {
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardScreen,(route) => false);
            });
      }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _getCard() async {
    ApiManager().getCard().then((value) {
      if (value.status == success) {
        ProgressDialogUtils.dismissProgressDialog();
        var response = value.response;
        for (var i = 0; i < value.response.data.length; i++) {
          list.add(MyCreditCard(
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
        setState(() {});
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // _buildheader(),
                    _buildCardListDetails(),
                    _buildCheckoutDetails(),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildheader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacing20),
        child: Row(
          children: [
            Image.asset(
              FileConstants.icLocationPin,
              height: 19,
            ),
            SizedBox(width: spacing5),
            Expanded(
              child: Text(
                "1380, N Jones Dr. Las Vegas, 89119",
                style: TextStyle(
                  fontSize: fontSize15,
                  fontWeight: fontWeightSemiBold,
                ),
              ),
            ),
            Image.asset(
              FileConstants.icDropDown,
              width: 20,
            ),
            SizedBox(width: spacing20),
            InkWell(
              onTap: () {},
              child: Image.asset(
                FileConstants.icNotification,
                height: 20,
                // width: 20,
              ),
            )
          ],
        ),
      );

  Widget _buildCardListDetails() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing20,
          vertical: spacing40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Confirm Payment",
              style: TextStyle(
                  fontSize: fontSize18,
                  fontWeight: fontWeightSemiBold,
                  color: colorDarkPurple),
            ),
            SizedBox(height: spacing25),
            Text(
              "Payment Via",
              style: TextStyle(
                fontSize: fontSize14,
                fontWeight: fontWeightMedium,
              ),
            ),
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

  Widget _buildCheckoutDetails() => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Checkout",
              style: TextStyle(
                fontSize: fontSize14,
                fontWeight: fontWeightMedium,
              ),
            ),
            SizedBox(height: spacing10),
            Container(
              child: Column(
                children: [
                  _buildCheckoutRow(
                      "General Medicine Video Consult", "\$90.00"),
                  Divider(thickness: 0.5),
                  _buildCheckoutRow("Total", "\$90.00"),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: spacing5),
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
            )
          ],
        ),
      );

  Widget _buildCheckoutRow(String title, String amount) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing10,
          horizontal: spacing15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize16,
                  fontWeight: fontWeightMedium,
                ),
              ),
            ),
            SizedBox(width: spacing10),
            Text(
              amount,
              style: TextStyle(
                fontSize: fontSize16,
                fontWeight: fontWeightBold,
              ),
            ),
          ],
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
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 100 * 0.2),
            Expanded(
              child: HutanoButton(
                label: "Pay \$90.00",
                onPressed: _payAmount,
              ),
            ),
          ],
        ),
      );
}
