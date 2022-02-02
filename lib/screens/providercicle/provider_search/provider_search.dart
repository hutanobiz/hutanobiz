import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/no_data_found.dart';
import 'package:hutano/widgets/skip_later.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/dialog_utils.dart';
import 'item_provider_detail.dart';
import 'location_service.dart';
import 'model/doctor_data_model.dart';
import 'search_bar.dart';

class ProviderSearch extends StatefulWidget {
  final String serachText;
  bool showSkip = true;
  final bool isOnBoarding;

  ProviderSearch({
    Key key,
    this.serachText,
    this.isOnBoarding,
  }) : super(key: key);
  @override
  _ProviderSearchState createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  final controller = TextEditingController();
  bool isShowNext = false;
  final PagingController<int, DoctorData> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    controller.text = widget.serachText ?? "";
    _pagingController.addPageRequestListener(_searchProvider);
  }

  _fetchLocationData(int pageKey) async {
    try {
      if (LocationService().getLocationData() == null) {
        await LocationService().checkLocation();
        _searchProvider(pageKey);
      } else {
        _searchProvider(pageKey);
      }
    } catch (e) {
      _searchProvider(pageKey);
    }
  }

  _onSearch() {
    _pagingController.refresh();
  }

  _searchProvider(int pageKey) async {
    // FocusManager.instance.primaryFocus.unfocus();

    final locationData = LocationService().getLocationData();
    final param = <String, dynamic>{
      'search': controller.text.toString(),
      'page': pageKey,
      'limit': 10
    };
    if (locationData != null) {
      param['lattitude'] = locationData.latitude;
      param['longitude'] = locationData.longitude;
    }
    try {
      var res = await ApiManager().searchProvider(param);
      var _totalPage = (res.response.count / res.response.limit).ceil();
      if (pageKey < _totalPage) {
        _pagingController.appendPage(res.response.doctorData, pageKey + 1);
      } else {
        _pagingController.appendLastPage(res.response.doctorData);
      }
    } on ErrorModel catch (e) {
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          widget.isOnBoarding ? AppColors.snow : AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        isAddBack: widget.isOnBoarding,
        addHeader: !widget.isOnBoarding,
        isBackRequired: !widget.isOnBoarding,
        title: "",
        isAddAppBar: !widget.isOnBoarding,
        addBottomArrows: false,
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isOnBoarding)
              AppHeader(
                  progressSteps: HutanoProgressSteps.four,
                  title: Localization.of(context).addProviders,
                  subTitle: Localization.of(context).addProviderToNetwork,
                  isFromTab: !widget.isOnBoarding,
                  isAppLogoVisible: widget.isOnBoarding),
            SizedBox(
              height: widget.isOnBoarding ? 10 : 10,
            ),
            SearchBar(controller: controller, onSearch: _onSearch),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: PagedListView<int, DoctorData>.separated(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<DoctorData>(
                  noItemsFoundIndicatorBuilder: (_) =>
                      Center(child: NoDataFound()),
                  firstPageErrorIndicatorBuilder: (_) => Container(),
                  itemBuilder: (context, item, index) => ItemProviderDetail(
                    providerDetail: item,
                    isOnBoarding: widget.isOnBoarding,
                    onAddPressed: () {
                      final user = item.user[0];
                      var occupation = "";
                      if (item?.professionalTitle != null &&
                          item.professionalTitle.length > 0) {
                        occupation = item?.professionalTitle[0]?.title ?? "";
                      }
                      var name = user?.fullName ?? "";
                      if (occupation.isNotEmpty) {
                        name = 'Dr. $name , ${occupation.getInitials()}';
                      }

                      Navigator.of(context)
                          .pushNamed(Routes.providerAddToNetwork, arguments: {
                        ArgumentConstant.doctorId: item.userId,
                        ArgumentConstant.doctorName: name,
                        ArgumentConstant.doctorAvatar: item.user[0].avatar,
                        'isOnBoarding': widget.isOnBoarding
                      }).then((value) {
                        if (value != null && value) {
                          setState(() {
                            isShowNext = true;
                          });
                        }
                      });
                    },
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
            if (widget.isOnBoarding)
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    SkipLater(onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.homeMain,
                        (Route<dynamic> route) => false,
                      );
                    }),
                    Spacer(),
                    isShowNext
                        ? HutanoButton(
                            width: 55,
                            height: 55,
                            color: accentColor,
                            iconSize: 20,
                            buttonType: HutanoButtonType.onlyIcon,
                            icon: FileConstants.icForward,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                Routes.addProviderSuccess,
                              );
                            },
                          )
                        : SizedBox(),
                  ],
                ),
              )
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.only(bottom: 5),
            //   child: SkipLater(
            //     onTap: () {
            //       Navigator.of(context).pushNamedAndRemoveUntil(
            //           Routes.dashboardScreen, (route) => false);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
    // else
    //   return Scaffold(
    //     body: LoadingBackgroundNew(
    //       title: "",
    //       isAddAppBar: false,
    //       addBottomArrows:
    //           widget.showSkip && MediaQuery.of(context).viewInsets.bottom == 0,
    //       padding:
    //           (widget.showSkip && MediaQuery.of(context).viewInsets.bottom == 0)
    //               ? const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 70)
    //               : EdgeInsets.zero,
    //       onForwardTap: () {
    //         Navigator.of(context).pushNamed(
    //           Routes.addProviderSuccess,
    //         );
    //       },
    //       isSkipLater:
    //           widget.showSkip && MediaQuery.of(context).viewInsets.bottom == 0,
    //       onSkipForTap: () {
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //           Routes.homeMain,
    //           (Route<dynamic> route) => false,
    //         );
    //       },
    //       child: SingleChildScrollView(
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 15),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               AppHeader(
    //                 progressSteps: HutanoProgressSteps.four,
    //                 title: Localization.of(context).addProviders,
    //                 subTitle: Localization.of(context).addProviderToNetwork,
    //                 isFromTab: widget.isFromTab,
    //               ),
    //               SizedBox(
    //                 height: spacing40,
    //               ),
    //               SearchBar(controller: controller, onSearch: _onSearch),
    //               PagedListView<int, DoctorData>.separated(
    //                 shrinkWrap: true,
    //                 physics: NeverScrollableScrollPhysics(),
    //                 pagingController: _pagingController,
    //                 builderDelegate: PagedChildBuilderDelegate<DoctorData>(
    //                   noItemsFoundIndicatorBuilder: (_) =>
    //                       Center(child: NoDataFound()),
    //                   firstPageErrorIndicatorBuilder: (_) => Container(),
    //                   itemBuilder: (context, item, index) => ItemProviderDetail(
    //                     providerDetail: item,
    //                   ),
    //                 ),
    //                 separatorBuilder: (context, index) => const Divider(),
    //               ),
    //               // if (widget.showSkip)
    //               //   Padding(
    //               //     padding: const EdgeInsets.all(7),
    //               //     child: Row(
    //               //       children: [
    //               //         SkipLater(onTap: () {
    //               //           Navigator.of(context).pushNamedAndRemoveUntil(
    //               //               Routes.dashboardScreen, (route) => false);
    //               //         }),
    //               //         Spacer(),
    //               //         HutanoButton(
    //               //           width: 55,
    //               //           height: 55,
    //               //           color: accentColor,
    //               //           iconSize: 20,
    //               //           buttonType: HutanoButtonType.onlyIcon,
    //               //           icon: FileConstants.icForward,
    //               //           onPressed: () {
    //               //             Navigator.of(context).pushNamedAndRemoveUntil(
    //               //                 Routes.dashboardScreen, (route) => false);
    //               //           },
    //               //         ),
    //               //       ],
    //               //     ),
    //               //   )
    //               // Container(
    //               //   alignment: Alignment.center,
    //               //   padding: const EdgeInsets.only(bottom: 5),
    //               //   child: SkipLater(
    //               //     onTap: () {
    //               //       Navigator.of(context).pushNamedAndRemoveUntil(
    //               //           Routes.dashboardScreen, (route) => false);
    //               //     },
    //               //   ),
    //               // )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}
