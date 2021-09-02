import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
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
  final bool isFromTab;

  ProviderSearch(
      {Key key, this.serachText, this.showSkip = true, this.isFromTab = false})
      : super(key: key);
  @override
  _ProviderSearchState createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  final controller = TextEditingController();

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
    // FocusManager.instance.primaryFocus.unfocus();
  }

  _searchProvider(int pageKey) async {
    // FocusManager.instance.primaryFocus.unfocus();

    final locationData = LocationService().getLocationData();
    final param = <String, dynamic>{
      'search': controller.text.toString(),
      'page': pageKey,
      'limit': dataLimit
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
    if (widget.isFromTab)
      return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
          title: "",
          padding: const EdgeInsets.all(0),
          color: AppColors.snow,
          isAddBack: false,
          addHeader: true,
          isBackRequired: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isFromTab)
                  AppHeader(
                      progressSteps: HutanoProgressSteps.four,
                      title: Localization.of(context).addProviders,
                      subTitle: Localization.of(context).addProviderToNetwork,
                      isFromTab: widget.isFromTab,
                      isAppLogoVisible: !widget.isFromTab),
                SizedBox(
                  height: spacing40,
                ),
                SearchBar(controller: controller, onSearch: _onSearch),
                Expanded(
                  child: PagedListView<int, DoctorData>.separated(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<DoctorData>(
                      noItemsFoundIndicatorBuilder: (_) =>
                          Center(child: NoDataFound()),
                      firstPageErrorIndicatorBuilder: (_) => Container(),
                      itemBuilder: (context, item, index) => ItemProviderDetail(
                        providerDetail: item,
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
                if (widget.showSkip)
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      children: [
                        SkipLater(onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.homeMain,
                            (Route<dynamic> route) => false,
                          );
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     Routes.dashboardScreen, (route) => false,arguments: 0);
                        }),
                        Spacer(),
                        HutanoButton(
                          width: 55,
                          height: 55,
                          color: accentColor,
                          iconSize: 20,
                          buttonType: HutanoButtonType.onlyIcon,
                          icon: FileConstants.icForward,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.homeMain,
                              (Route<dynamic> route) => false,
                            );
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     Routes.dashboardScreen, (route) => false,arguments: 0);
                          },
                        ),
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
        ),
      );
    else
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                progressSteps: HutanoProgressSteps.four,
                title: Localization.of(context).addProviders,
                subTitle: Localization.of(context).addProviderToNetwork,
                isFromTab: widget.isFromTab,
              ),
              SizedBox(
                height: spacing40,
              ),
              SearchBar(controller: controller, onSearch: _onSearch),
              Expanded(
                child: PagedListView<int, DoctorData>.separated(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<DoctorData>(
                    noItemsFoundIndicatorBuilder: (_) =>
                        Center(child: NoDataFound()),
                    firstPageErrorIndicatorBuilder: (_) => Container(),
                    itemBuilder: (context, item, index) => ItemProviderDetail(
                      providerDetail: item,
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
              if (widget.showSkip)
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    children: [
                      SkipLater(onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.homeMain,
                          (Route<dynamic> route) => false,
                        );
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     Routes.dashboardScreen, (route) => false,arguments: 0);
                      }),
                      Spacer(),
                      HutanoButton(
                        width: 55,
                        height: 55,
                        color: accentColor,
                        iconSize: 20,
                        buttonType: HutanoButtonType.onlyIcon,
                        icon: FileConstants.icForward,
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.homeMain,
                            (Route<dynamic> route) => false,
                          );
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     Routes.dashboardScreen, (route) => false,arguments: 0);
                        },
                      ),
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
  }
}
