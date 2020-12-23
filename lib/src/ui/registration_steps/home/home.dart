import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/localization/localization.dart';
import '../../appointments/my_appointments/my_appointments.dart';
import '../../provider/provider_search/provider_search.dart';
import '../../settings/settings.dart';

class Home extends StatefulWidget {
  final String searchText;

  const Home({Key key, this.searchText}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  final widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    widgetOptions.addAll([
      ProviderSearch(
        serachText: widget.searchText ?? "",
      ),
      MyAppointments(),
      Settings()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: IndexedStack(
      //   children: widgetOptions,
      //   index: selectedIndex,
      //   // child: widgetOptions.elementAt(selectedIndex),
      // ),
      body: Container(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorWhite,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: BottomIcon(
                icon: FileConstants.icHome,
              ),
              activeIcon: BottomIcon(
                icon: FileConstants.icHome,
                isActive: true,
              ),
              title: Label(Localization.of(context).home)),
          BottomNavigationBarItem(
              icon: BottomIcon(
                icon: FileConstants.icDob,
              ),
              activeIcon: BottomIcon(
                icon: FileConstants.icDob,
                isActive: true,
              ),
              title: Label(Localization.of(context).appointments)),
          BottomNavigationBarItem(
            icon: BottomIcon(
              icon: FileConstants.icSetting,
            ),
            activeIcon: BottomIcon(
              icon: FileConstants.icSetting,
              isActive: true,
            ),
            title: Label(Localization.of(context).setting),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: colorPurple100,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;

  const Label(this.label, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Text(label)
      ],
    );
  }
}

class BottomIcon extends StatelessWidget {
  final String icon;
  final bool isActive;

  const BottomIcon({Key key, this.icon, this.isActive = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(icon,
        width: 20, height: 20, color: isActive ? colorPurple100 : colorGrey);
  }
}
