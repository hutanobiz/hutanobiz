import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/current_medical_history.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class ViewMedicalHistoryScreen extends StatefulWidget {
  ViewMedicalHistoryScreen({Key key, this.isBottomButtonsShow})
      : super(key: key);

  final Map isBottomButtonsShow;

  @override
  _ViewMedicalHistoryScreenState createState() =>
      _ViewMedicalHistoryScreenState();
}

class _ViewMedicalHistoryScreenState extends State<ViewMedicalHistoryScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Map _map = {};

  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();

    if (widget.isBottomButtonsShow != null) {
      _map = widget.isBottomButtonsShow;
    } else {
      _map['isBottomButtonsShow'] = false;
    }

    _children = [
      CurrentAppointmentMedicalHistory(isBottomButtonsShow: _map),
      UploadImagesScreen(isBottomButtonsShow: _map),
      UploadDocumentsScreen(isBottomButtonsShow: _map),
    ];

    _controller = TabController(length: _children.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        padding: const EdgeInsets.only(top: 0),
        isAddBack: false,
        addHeader: true,
        isBackRequired: true,
        child: tabBarWidget(),
      ),
    );
  }

  Widget tabBarWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Container(
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: Colors.grey[300])),
            child: TabBar(
              controller: _controller,
              labelPadding: EdgeInsets.all(0),
              unselectedLabelColor: AppColors.windsor,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.windsor,
              ),
              tabs: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Medical History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Medical Images',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Medical Documents',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: _children,
          ),
        ),
      ],
    );
  }
}
