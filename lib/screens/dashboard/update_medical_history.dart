import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/upload_images.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            InkWell(
              customBorder: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15.0,
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(width: 10),
            Text(
              'Medical History',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black.withOpacity(0.4),
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: 10.0),
            borderSide: BorderSide(
              color: AppColors.windsor,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          tabs: [
            Tab(
              child: Text(
                'Medical History',
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                'Medical Images',
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                'Medical Documents',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _children,
      ),
    );
  }
}
