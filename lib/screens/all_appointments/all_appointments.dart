import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/requests_appointments_screen.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/coming_soon.dart';
import 'package:hutano/widgets/loading_background_new.dart';

import '../../colors.dart';

class AllAppointments extends StatefulWidget {
  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late List tabs;
  int _currentIndex = 0;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    tabs = ['Appointments', 'Requests'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController!.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: Localization.of(context)!.appointments,
        isAddBack: false,
        padding: EdgeInsets.all(0),
        addHeader: true,
        isBackRequired: false,
        centerTitle: true,
        addTitle: true,
        child: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.windsor,
              controller: _tabController,
              tabs: _tabsHeader(),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: spacing15, right: spacing15, top: spacing20),
                child: _tabsContent(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabsContent() =>
      TabBarView(controller: _tabController, children: //_currentIndex == 0
          // ?
          [
        AppointmentsScreen(),
        // : _currentIndex == 1
        // ?
        RequestAppointmentsScreen()
      ]);
  // : ComingSoon(isBackRequired: false, isFromUpload: false);

  List<Widget> _tabsHeader() {
    return tabs
        .asMap()
        .map((index, text) => MapEntry(
              index,
              Container(
                height: 50,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _tabController!.index == index
                              ? AppColors.windsor
                              : colorBlack2,
                          fontSize: fontSize14,
                          fontWeight: _tabController!.index == index
                              ? fontWeightMedium
                              : fontWeightRegular),
                    )
                  ],
                ),
              ),
            ))
        .values
        .toList();
  }
}
