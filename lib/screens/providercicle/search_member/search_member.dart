import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_scaffold.dart';
import 'package:hutano/widgets/no_data_found.dart';
import 'package:hutano/widgets/ripple_effect.dart';

import '../../../utils/debouncer.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../familynetwork/add_family_member/model/res_add_member.dart';
import '../../familynetwork/familycircle/model/req_family_network.dart';
import '../search/item_member_detail.dart';
import '../search/model/family_member.dart';

class SearchMember extends StatefulWidget {
  final String message;
  final bool loadAllData;

  const SearchMember({Key key, this.message, this.loadAllData})
      : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchMember> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();
  List<FamilyNetwork> _memberList = [];
  final int _page = 1;
  String token;
  ApiBaseHelper api = ApiBaseHelper();

  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((value) {
      token = value;
    });
    if (widget.loadAllData) {
      WidgetsBinding.instance.addPostFrameCallback((_) => {_searchUser('')});
    }
  }

  _onSearch(String s) {
    if (s.isEmpty) {
      setState(() {
        _memberList = [];
      });
      return;
    }
    _searchUser(s);
  }

  _searchUser(s) async {
    ProgressDialogUtils.showProgressDialog(context);
    SharedPref().getValue('id').then((value) async {
      final request =
          ReqFamilyNetwork(id: value, limit: 20, page: _page, search: s);

      try {
        var res = await api.getFamilyNetowrk(context, token, request);
        ProgressDialogUtils.dismissProgressDialog();
        setState(() {
          _memberList = res.response.familyNetwork;
        });
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
      }
    });
  }

  _onClose() {
    _searchController.clear();
    setState(() {
      _memberList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          _buildSearchField(),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child:
                (_memberList.length == 0 && _searchController.text.length > 0)
                    ? Center(child: NoDataFound())
                    : ListView.separated(
                        separatorBuilder: (_, pos) {
                          return Divider(
                            color: AppColors.colorBorder45,
                            thickness: 0.5,
                            height: 25,
                          );
                        },
                        itemCount: _memberList.length,
                        itemBuilder: (context, pos) {
                          return RippleEffect(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.memberMessage, arguments: {
                                ArgumentConstant.member: _memberList[pos],
                                ArgumentConstant.shareMessage: widget.message,
                                ArgumentConstant.shareMessage: widget.message,
                              });
                            },
                            child: MemberDetail(
                              member: FamilyMember(
                                  avatar: _memberList[pos].avatar,
                                  fullName: _memberList[pos].fullName,
                                  relation: _memberList[pos].relation),
                              titleStyle: AppTextStyle.semiBoldStyle(
                                  color: AppColors.colorBlack, fontSize: 14),
                              subTitleStyle: TextStyle(
                                  color: AppColors.colorBlack70, fontSize: 12),
                            ),
                          );
                        }),
          ),
          _buildButton()
        ],
      ),
    );
  }

  Widget _buildButton() {
    return HutanoButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: FileConstants.icBack,
      buttonType: HutanoButtonType.onlyIcon,
    );
  }

  _buildSearchField() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
    return TextField(
      controller: _searchController,
      style: TextStyle(color: AppColors.colorDarkPurple),
      cursorColor: AppColors.colorDarkPurple,
      onChanged: (s) => _debouncer(() {
        _onSearch(s);
      }),
      textInputAction: TextInputAction.done,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        isDense: true,
        fillColor: AppColors.colorWhiteSmoke44,
        filled: true,
        suffixIconConstraints: BoxConstraints(),
        suffixIcon: InkWell(
          onTap: _onClose,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.cancel,
              color: AppColors.colorLightBlue,
              size: 25,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
          child: Image.asset(
            FileConstants.icSearchPurple,
            height: 20,
            width: 20,
          ),
        ),
        hoverColor: AppColors.colorGrey84,
        border: border,
        disabledBorder: border,
        focusedBorder: border,
        hintText: Strings.search,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
