import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/familynetwork/add_family_member/add_family_member.dart';
import 'package:hutano/screens/familynetwork/familycircle/family_circle.dart';
import 'package:hutano/screens/providercicle/my_provider_network/my_provider_network.dart';
import 'package:hutano/screens/registration/invite_family/invite_family.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class MyCircle extends StatefulWidget {
  @override
  _MyCircleState createState() => _MyCircleState();
}

class _MyCircleState extends State<MyCircle>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    tabs = ['Providers', 'Family'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: Localization.of(context).appointments,
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
                padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
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
        MyProviderNetwrok(
          isOnBoarding: false,
        ),
        FamilyCircle(isOnboarding: false)
        // : _currentIndex == 1
        // ?
        // RequestAppointmentsScreen()
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
                          color: _tabController.index == index
                              ? AppColors.windsor
                              : colorBlack2,
                          fontSize: fontSize14,
                          fontWeight: _tabController.index == index
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
