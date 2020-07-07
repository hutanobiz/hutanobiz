import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';
import 'package:hutano/widgets/loading_background.dart';

class UpdateMedicalHistory extends StatefulWidget {
  @override
  _UpdateMedicalHistoryState createState() => _UpdateMedicalHistoryState();
}

class _UpdateMedicalHistoryState extends State<UpdateMedicalHistory>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  final List<Widget> _children = [
    MedicalHistoryScreen(isBottomButtonsShow: false),
    UploadImagesScreen(isBottomButtonsShow: false),
    UploadDocumentsScreen(isBottomButtonsShow: false),
  ];

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: _children.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: 'Medical History',
        isAddBack: true,
        addBackButton: false,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
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
            height: 44,
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
                  height: 40,
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
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'Medical Images',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  height: 40,
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
