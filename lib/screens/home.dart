import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/all_appointments/all_appointments.dart';
import 'package:hutano/screens/chat/all_chats.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/dashboard/setting.dart';
import 'package:hutano/screens/my_circle.dart';
import 'package:hutano/screens/providercicle/my_provider_groups.dart';
import 'package:hutano/screens/providercicle/my_provider_network/my_provider_network.dart';
import 'package:hutano/screens/users/linked_account_provider.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/bottom_bar/fancy_bottom_navigation.dart';
import 'package:hutano/widgets/coming_soon.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.currentIndex = 0}) : super(key: key);
  int currentIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<dynamic>? linkedAccounts = [];
  dynamic selectedAccount;
  ApiBaseHelper api = ApiBaseHelper();

  // final List<Widget> _children = [
  //   DashboardScreen(),
  //   AppointmentsScreen(),
  //   RequestAppointmentsScreen(),
  //   SettingScreen(),
  // ];

  final List<Widget> _children = [
    DashboardScreen(),
    AllAppointments(),
    // AppointmentsScreen(),
    // RequestAppointmentsScreen(),
    MyCircle(),
    
    // BreathingIssue(
    //     breathing: false,
    //     stomach: false,
    //     healthChest: true,
    //     isAntiAging: false),
    // ComingSoon(isBackRequired: false, isFromUpload: false),
    // AbnormalSensation(
    //     abnormal: false,
    //     maleHealth: false,
    //     femaleHealth: false,
    //     woundSkin: true,
    //     dentalCare: false),
    // ChatScreen(),
    ChatMain(),
    // ComingSoon(isBackRequired: false, isFromUpload: false),
    SettingScreen(),
  ];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    getLinkedAccount();
    super.initState();
  }

  getLinkedAccount() async {
    linkedAccounts = await api.getLinkAccount(
        'Bearer ${getString('primaryUserToken')}');
    linkedAccounts!.insert(0, json.decode(getString('primaryUser')));
    linkedAccounts!.add('Add');
    selectedAccount = json.decode(getString('selectedAccount'));
    Provider.of<LinkedAccountProvider>(context, listen: false)
        .add(linkedAccounts);
    setState(() {});
  }

  GlobalKey bottomNavigationKey = GlobalKey();
  PageController _pageController = new PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: bottomnavigationBar(),
    );
  }

  final double imageSize = 24;
  Widget bottomnavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        border: Border.all(width: 0.5, color: Colors.grey[300]!),
      ),
      child: FancyBottomNavigation(
        key: bottomNavigationKey,
        inactiveIconSize: 24,
        activeIconColor: Colors.white,
        circleHeight: 50,
        arcHeight: 60,
        shadowAllowance: 25,
        titleStyle: TextStyle(color: colorYellow100),
        shadowColor: Colors.transparent,
        shadowBlur: 20,
        inactiveIconColor: Colors.grey,
        initialSelection: _currentIndex,
        tabs: [
          TabData(
              icon: Padding(
                padding: EdgeInsets.all(_currentIndex != 0 ? 0 : 8.0),
                child: Image.asset(
                  _currentIndex != 0
                      ? FileConstants.icHomeGrey
                      : FileConstants.icHomeWhite,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState as FancyBottomNavigationState;
                fState.setPage(0);
                _pageController.jumpToPage(0);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "Home"),
          TabData(
              icon: Padding(
                padding: EdgeInsets.all(_currentIndex != 1 ? 0 : 8.0),
                child: Image.asset(
                  _currentIndex != 1
                      ? FileConstants.icCalendarGrey
                      : FileConstants.icCalendarWhite,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState as FancyBottomNavigationState;
                fState.setPage(1);
                _pageController.jumpToPage(1);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "Appointments"),
          TabData(
              icon: Padding(
                padding: EdgeInsets.all(_currentIndex != 2 ? 0 : 8.0),
                child: Image.asset(
                  _currentIndex != 2
                      ? FileConstants.icTeamGrey
                      : FileConstants.icTeamWhite,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState as FancyBottomNavigationState;
                fState.setPage(2);
                _pageController.jumpToPage(2);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "My Team"),
          TabData(
              icon: Padding(
                padding: EdgeInsets.all(_currentIndex != 3 ? 0 : 8.0),
                child: Image.asset(
                  _currentIndex != 3
                      ? FileConstants.icChatGrey
                      : FileConstants.icChatWhite,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState as FancyBottomNavigationState;
                fState.setPage(3);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "Chat"),
          TabData(
              icon: Padding(
                padding: EdgeInsets.all(_currentIndex != 4 ? 0 : 8.0),
                child: Image.asset(
                  _currentIndex != 4
                      ? FileConstants.icUserGrey
                      : FileConstants.icUserWhite,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState as FancyBottomNavigationState;
                fState.setPage(4);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "Settings"),
        ],
        onTabChangedListener: (position) {
          setState(() {});
          onTabTapped(position);
        },
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   shape: BoxShape.rectangle,
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(14.0),
      //     topLeft: Radius.circular(14.0),
      //   ),
      //   border: Border.all(width: 0.5, color: Colors.grey[300]),
      // ),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(14.0),
      //     topLeft: Radius.circular(14.0),
      //   ),
      //   child: BottomNavigationBar(
      //     onTap: onTabTapped,
      //     backgroundColor: Colors.white,
      //     showUnselectedLabels: true,
      //     showSelectedLabels: true,
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: AppColors.persian_indigo,
      //     unselectedItemColor: Colors.grey[400],
      //     currentIndex: _currentIndex,
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: ImageIcon(
      //           AssetImage("images/ic_home.png"),
      //         ),
      //         activeIcon: ImageIcon(
      //           AssetImage("images/ic_active_home.png"),
      //         ),
      //         title: Text('Home'),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: ImageIcon(
      //           AssetImage("images/ic_appointments.png"),
      //         ),
      //         activeIcon: ImageIcon(
      //           AssetImage("images/ic_active_appointments.png"),
      //         ),
      //         title: Text('Appointments'),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.receipt),
      //         title: Text('Requests'),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: ImageIcon(
      //           AssetImage("images/ic_settings.png"),
      //         ),
      //         activeIcon: ImageIcon(
      //           AssetImage("images/ic_active_settings.png"),
      //         ),
      //         title: Text('Settings'),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  updateUser(dynamic value) async {
    ProgressDialogUtils.showProgressDialog(context);
    var a = await api.switchAccount(
        'Bearer ${getString('primaryUserToken')}',
        {'_id': value['_id']});

    setBool(PreferenceKey.perFormedSteps, true);
    setBool(PreferenceKey.isEmailVerified, a['isEmailVerified']);
    setString(PreferenceKey.fullName, a['fullName']);
    setString(PreferenceKey.id, a['_id']);
    setString(PreferenceKey.tokens, a['token']);
    setString(PreferenceKey.phone, a['phoneNumber'].toString());
    setInt(PreferenceKey.gender, a['gender']);
    setString('patientSocialHistory', jsonEncode(a['patientSocialHistory']));
    setString('selectedAccount', jsonEncode(a));
    setBool(PreferenceKey.intro, true);
    SharedPref().saveToken(a['token']);
    ProgressDialogUtils.dismissProgressDialog();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homeMain,
      (Route<dynamic> route) => false,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
