import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/all_appointments/all_appointments.dart';
import 'package:hutano/screens/chat/all_chats.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/dashboard/setting.dart';
import 'package:hutano/screens/providercicle/my_provider_groups.dart';
import 'package:hutano/screens/providercicle/my_provider_network/my_provider_network.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/bottom_bar/fancy_bottom_navigation.dart';
import 'package:hutano/widgets/coming_soon.dart';
import 'package:hutano/widgets/fancy_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.currentIndex = 0}) : super(key: key);
  int currentIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<dynamic> linkedAccounts = [];
  dynamic selectedAccount;

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
    MyProviderNetwrok(
      isOnBoarding: false,
    ),
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
    linkedAccounts = await ApiManager().getLinkAccount();
    linkedAccounts.insert(0, json.decode(getString('primaryUser')));
    linkedAccounts.add('Add');
    selectedAccount = json.decode(getString('selectedAccount'));
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
        border: Border.all(width: 0.5, color: Colors.grey[300]),
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
                    bottomNavigationKey.currentState;
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
                    bottomNavigationKey.currentState;
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
                    bottomNavigationKey.currentState;
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
                    bottomNavigationKey.currentState;
                fState.setPage(3);
                setState(() {});
              },
              // iconData: Icons.home,
              title: "Chat"),
          TabData(
              icon: GestureDetector(
                onLongPress: () {
                  return showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.snow,
                      isScrollControlled: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (ctx) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 6,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: colorGrey,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(height: 17),
                                padding: EdgeInsets.only(top: 20),
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: linkedAccounts.length,
                                itemBuilder: (context, index) {
                                  return index == linkedAccounts.length - 1
                                      ? GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.add_circle,
                                                        color:
                                                            AppColors.windsor,
                                                        size: 60),
                                                    SizedBox(width: 16),
                                                    Text('Add User',
                                                        style: AppTextStyle
                                                            .mediumStyle(
                                                                fontSize: 16,
                                                                color: AppColors
                                                                    .windsor)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            // Navigator.pop(context);
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor: AppColors.snow,
                                                isScrollControlled: false,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                builder: (ctx) => Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          height: 6,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              color: colorGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: FancyButton(
                                                              title:
                                                                  'Add Account',
                                                              onPressed: () {
                                                                return Navigator
                                                                    .pushNamed(
                                                                        context,
                                                                        Routes
                                                                            .addNewUserType);
                                                              }),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20.0),
                                                            child: FancyButton(
                                                              title:
                                                                  'Link Account',
                                                              buttonColor:
                                                                  Colors.white,
                                                              textColor:
                                                                  AppColors
                                                                      .windsor,
                                                              onPressed: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    Routes
                                                                        .linkNumber);
                                                              },
                                                            ))
                                                      ],
                                                    ));
                                          },
                                        )
                                      : GestureDetector(
                                          child: Row(
                                          children: [
                                            SizedBox(width: 16),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image.network(
                                                  ApiBaseHelper.imageUrl +
                                                      (index == 0
                                                          ? linkedAccounts[
                                                              index]['avatar']
                                                          : linkedAccounts[
                                                                      index][
                                                                  'linkToAccount']
                                                              ['avatar']),
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                  (index == 0
                                                      ? linkedAccounts[index]
                                                          ['fullName']
                                                      : linkedAccounts[index]
                                                              ['linkToAccount']
                                                          ['fullName']),
                                                  style:
                                                      AppTextStyle.mediumStyle(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .windsor)),
                                            ),
                                            (index == 0
                                                        ? linkedAccounts[index]
                                                            ['_id']
                                                        : linkedAccounts[index][
                                                                'linkToAccount']
                                                            ['_id']) ==
                                                    selectedAccount['_id']
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      color: AppColors.windsor,
                                                      size: 24,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ));
                                },
                              ),
                            ],
                          ));
                  // print('aaa');
                },
                child: Padding(
                    padding: EdgeInsets.all(_currentIndex != 4 ? 0 : 2.0),
                    // child: Image.asset(
                    //   _currentIndex != 4
                    //       ? FileConstants.icUserGrey
                    //       : FileConstants.icUserWhite,
                    //   height: imageSize,
                    //   width: imageSize,
                    // ),
                    child: selectedAccount == null
                        ? Image.asset(
                            _currentIndex != 4
                                ? FileConstants.icUserGrey
                                : FileConstants.icUserWhite,
                            height: imageSize,
                            width: imageSize,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                                _currentIndex != 4 ? 15 : 20),
                            child: Image.network(
                              ApiBaseHelper.imageUrl +
                                  selectedAccount['avatar'],
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          )),
              ),
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
