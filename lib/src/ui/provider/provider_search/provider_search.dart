import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/no_data_found.dart';
import 'item_provider_detail.dart';
import 'location_service.dart';
import 'model/doctor_data_model.dart';
import 'search_bar.dart';

class ProviderSearch extends StatefulWidget {
  final String serachText;

  const ProviderSearch({Key key, this.serachText}) : super(key: key);
  @override
  _ProviderSearchState createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch>
    with AutomaticKeepAliveClientMixin<ProviderSearch> {
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
    FocusManager.instance.primaryFocus.unfocus();
  }

  _searchProvider(int pageKey) async {
    FocusManager.instance.primaryFocus.unfocus();

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
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 0, right: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localization.of(context).searchResults,
              style: TextStyle(
                  fontSize: fontSize18,
                  color: colorDarkPurple,
                  fontWeight: fontWeightSemiBold),
            ),
            SizedBox(
              height: spacing25,
            ),
            SearchBar(controller: controller, onSearch: _onSearch),
            SizedBox(
              height: spacing30,
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
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}