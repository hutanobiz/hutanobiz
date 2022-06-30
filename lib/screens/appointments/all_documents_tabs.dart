import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/appointments/upload_documents.dart';
import 'package:hutano/screens/appointments/view_all_documents_images.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/widgets/coming_soon.dart';
import 'package:hutano/widgets/loading_background_new.dart';

import '../../colors.dart';

class AllDocumentsTabs extends StatefulWidget {
  @override
  _AllDocumentsTabsState createState() => _AllDocumentsTabsState();
}

class _AllDocumentsTabsState extends State<AllDocumentsTabs>
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
    tabs = ['Recent', 'Archive', 'View all'];
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
        isAddAppBar: false,
        addHeader: true,
        title: "Images",
        isSkipLater: false,
        addBottomArrows: false,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
              child: _tabsContent(),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabsContent() => _currentIndex == 0
      ? UploadDocumentsScreen()
      : _currentIndex == 1
          ? ComingSoon(isFromUpload: true, isBackRequired: false)
          : ViewAllDocumentImages(isForImage: false);

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
