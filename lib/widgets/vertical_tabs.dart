import 'package:flutter/material.dart';

class VerticalTabs extends StatefulWidget {
  final Key key;
  final double tabsWidth;
  final List<Tab> tabs;
  final List<Widget> contents;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color tabBackgroundColor;
  final TextStyle selectedTabTextStyle;
  final TextStyle tabTextStyle;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Function(int tabIndex) onSelect;

  VerticalTabs({
    this.key,
    @required this.tabs,
    @required this.contents,
    this.tabsWidth = 0,
    this.disabledChangePageFromContentView = false,
    this.contentScrollAxis = Axis.horizontal,
    this.tabBackgroundColor = const Color(0xfff8f8f8),
    this.selectedTabTextStyle = const TextStyle(color: Colors.black),
    this.tabTextStyle = const TextStyle(color: Colors.black38),
    this.changePageCurve = Curves.easeInOut,
    this.changePageDuration = const Duration(milliseconds: 300),
    this.onSelect,
  })  : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex;
  bool _changePageByTapView;

  AnimationController animationController;
  Animation<double> animation;
  Animation<RelativeRect> rectAnimation;

  PageController pageController = PageController();

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    _selectedIndex = 0;
    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }
    _selectTab(0);

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF3F2F8).withOpacity(0.50),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22.0),
              ),
            ),
            width: widget.tabsWidth,
            child: ListView.builder(
              itemCount: widget.tabs.length,
              itemBuilder: (context, index) {
                Tab tab = widget.tabs[index];

                Alignment alignment = Alignment.centerLeft;

                Color itemBGColor = widget.tabBackgroundColor;
                if (_selectedIndex == index) itemBGColor = Colors.white;

                return Stack(
                  children: <Widget>[
                    ScaleTransition(
                      scale: Tween(begin: 0.0, end: 1.0).animate(
                        new CurvedAnimation(
                          parent: animationControllers[index],
                          curve: Curves.elasticOut,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _changePageByTapView = true;
                        setState(() {
                          _selectTab(index);
                        });

                        pageController.animateToPage(index,
                            duration: widget.changePageDuration,
                            curve: widget.changePageCurve);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: itemBGColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(22.0),
                            topRight: const Radius.circular(22.0),
                          ),
                        ),
                        alignment: alignment,
                        padding: EdgeInsets.all(5),
                        child: tab,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            scrollDirection: widget.contentScrollAxis,
            physics: pageScrollPhysics,
            onPageChanged: (index) {
              if (_changePageByTapView == false ||
                  _changePageByTapView == null) {
                _selectTab(index);
              }
              if (_selectedIndex == index) {
                _changePageByTapView = null;
              }
              setState(() {});
            },
            controller: pageController,
            itemCount: widget.contents.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.contents[index];
            },
          ),
        ),
      ],
    );
  }

  void _selectTab(index) {
    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();

    if (widget.onSelect != null) {
      widget.onSelect(_selectedIndex);
    }
  }
}
