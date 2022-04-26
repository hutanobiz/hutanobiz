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
  bool showSkip = true;
  final bool isOnBoarding;

  ProviderSearch({
    Key key,
    this.isOnBoarding,
  }) : super(key: key);
  @override
  _ProviderSearchState createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  final controller = TextEditingController();
  bool isShowNext = false;
  bool isLoading = false;
  // final PagingController<int, DoctorData> _pagingController =
  //     PagingController(firstPageKey: 1);
  int current_page = 1, last_page = 1;
  ScrollController scrollController = ScrollController();
  List<DoctorData> appointmentMedication = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (current_page < last_page) {
          current_page++;
          _searchProvider(current_page);
        }
      }
    });
    _searchProvider(1);
  }

  _searchProvider(int page) async {
    // FocusManager.instance.primaryFocus.unfocus();
    setLoading(true);

    final locationData = LocationService().getLocationData();
    final param = <String, dynamic>{
      'search': controller.text.toString(),
      'page': page,
      'limit': 10
    };
    if (locationData != null) {
      param['lattitude'] = locationData.latitude;
      param['longitude'] = locationData.longitude;
    }
    try {
      var res = await ApiManager().searchProvider(param);
      last_page = (res.response.count / res.response.limit).ceil();
      if (page == 1) {
        appointmentMedication = res.response.doctorData;
      } else {
        appointmentMedication.addAll(res.response.doctorData);
      }
      setLoading(false);
    } on ErrorModel catch (e) {
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      debugPrint(e);
    }
  }

  setLoading(loading) {
    setState(() {
      isLoading = loading;
    });
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
        isBackRequired: widget.isOnBoarding,
        title: "",
        isLoading: isLoading,
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
            SearchBar(
                controller: controller,
                onSearch: () {
                  _searchProvider(1);
                }),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                controller: scrollController,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 10),
                itemCount: appointmentMedication.length,
                itemBuilder: (context, index) {
                  return ItemProviderDetail(
                    providerDetail: appointmentMedication[index],
                    isOnBoarding: widget.isOnBoarding,
                    onAddPressed: () {
                      controller.text = '';
                      final user = appointmentMedication[index].user[0];
                      var occupation = "";
                      if (appointmentMedication[index]?.professionalTitle !=
                              null &&
                          appointmentMedication[index]
                                  .professionalTitle
                                  .length >
                              0) {
                        occupation = appointmentMedication[index]
                                ?.professionalTitle[0]
                                ?.title ??
                            "";
                      }
                      var name = user?.fullName ?? "";
                      if (occupation.isNotEmpty) {
                        name = 'Dr. $name , ${occupation.getInitials()}';
                      }

                      Navigator.of(context)
                          .pushNamed(Routes.providerAddToNetwork, arguments: {
                        ArgumentConstant.doctorId:
                            appointmentMedication[index].userId,
                        ArgumentConstant.doctorName: name,
                        ArgumentConstant.doctorAvatar:
                            appointmentMedication[index].user[0].avatar,
                        'isOnBoarding': widget.isOnBoarding
                      }).then((value) {
                        _searchProvider(1);
                        if (value != null && value) {
                          setState(() {
                            isShowNext = true;
                          });
                        }
                      });
                    },
                  );
                },
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
