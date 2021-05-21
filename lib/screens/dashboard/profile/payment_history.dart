import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:intl/intl.dart';

class PaymentHistory extends StatefulWidget {
  PaymentHistory({Key key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;

  Future<List<dynamic>> paymentFuture;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      setState(() {
        paymentFuture = api.getStripeStatements(context, token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackground(
        title: "Payment History",
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        isAddBack: true,
        isAddAppBar: true,
        addBottomArrows: false,
        isLoading: isLoading,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder<List<dynamic>>(
      future: paymentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null ||
              snapshot.data.isEmpty ||
              snapshot.data is String) {
            return Center(
              child: Text('No payment history.'),
            );
          }

          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 16,
                  ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return paymentHistory(snapshot.data[index]);
              });
        } else if (snapshot.hasError) {
          return Text('No address.');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container paymentHistory(dynamic payment) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(14.0),
          ),
          border: Border.all(color: Colors.grey[300]),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    payment['appointmentType'] == 1
                        ? 'images/office_appointment.png'
                        : payment['appointmentType'] == 2
                            ? 'images/video_chat_appointment.png'
                            : 'images/onsite_appointment.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(payment['appointmentType'] == 1
                      ? 'Office Appointment'
                      : payment['appointmentType'] == 2
                          ? 'Video Appointment'
                          : 'Onsite Appointment'),
                ),
                Text('\$ ${payment['amount']}')
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Image.asset(
                  'images/ic_appointments.png',
                  height: 14,
                ),
                SizedBox(width: 4),
                Text(
                  DateFormat('MMM, dd yyyy').format(dateTime(payment)),
                ),
                Spacer(),
                Image.asset('images/ic_appointment_time.png', height: 14),
                SizedBox(width: 4),
                Text(
                  DateFormat('hh:mm a').format(dateTime(payment)),
                ),
              ],
            )
          ],
        ));
  }
}

dateTime(response) {
  DateTime date = DateTime.utc(
          DateTime.parse(response['createdAt']).year,
          DateTime.parse(response['createdAt']).month,
          DateTime.parse(response['createdAt']).day,
          DateTime.parse(response['createdAt']).hour,
          DateTime.parse(response['createdAt']).minute)
      .toLocal();
  return date;
}
