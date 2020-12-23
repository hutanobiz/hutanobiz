import 'package:flutter/material.dart';
import 'package:hutano/src/widgets/no_data_found.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import 'item_appointments.dart';
import 'model/req_appointment_list.dart';
import 'model/res_appointment_list.dart';

class AppointmentList extends StatefulWidget {
  // final List<ResAppointmentDetail> appointmentList;

  // const AppointmentList({Key key, this.appointmentList}) : super(key: key);
  final Function updateAppointmentCount;

  const AppointmentList({Key key, this.updateAppointmentCount})
      : super(key: key);
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<PresentRequest> _appointmentList = [];
  bool _apiCalled = false;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {_getAppointmentList()});
  }

  Future<void> _getAppointmentList() async {
    final request = ReqAppointmentList(userId: getString(PreferenceKey.id));
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().appointmentList(request);
      ProgressDialogUtils.dismissProgressDialog();
      if (res.response?.presentRequest.length > 0) {
        setState(() {
          _appointmentList = res.response.presentRequest;
        });
        widget.updateAppointmentCount(res.response?.presentRequest.length);
        return;
      } else {
        setState(() {
          _apiCalled = true;
        });
        return;
      }
      
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
      return;
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        _apiCalled = true;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (_apiCalled && _appointmentList.length == 0)
          ? Center(
              child: NoDataFound(
                msg: 'No appointments found.',
              ),
            )
          : RefreshIndicator(
              onRefresh: _getAppointmentList,

              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _appointmentList.length,
                  itemBuilder: (context, pos) {
                    return ItemAppointment(
                      appointment: _appointmentList[pos],
                    );
                  }),
            ),
    );
  }
}
