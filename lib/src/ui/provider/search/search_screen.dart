import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/extensions.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/no_data_found.dart';
import '../../../widgets/ripple_effect.dart';
import 'item_member_detail.dart';
import 'model/family_member.dart';
import 'model/req_search_number.dart';

class SearchScreen extends StatefulWidget {
  final SearchScreenFrom searchScreen;
  final String number;

  const SearchScreen({Key key, this.searchScreen, this.number})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();
  List<FamilyMember> _memberList = [];
  final int _page = 1;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.searchScreen != null) {
      if (widget.searchScreen == SearchScreenFrom.inviteFamily) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _searchController.text = widget.number;
          _searchUser(widget.number);
        });
      }
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
    final request =
        ReqSearchNumber(limit: dataLimit, page: _page, searchByNumber: s);
    try {
      var res = await ApiManager().searchContact(request);
      ProgressDialogUtils.dismissProgressDialog();
      setState(() {
        _memberList = res.response;
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
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
      padding: EdgeInsets.only(
          top: spacing30, left: spacing15, right: spacing15, bottom: spacing10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: spacing25,
          ),
          Form(
            autovalidate: true,
            key: _key,
            child: _buildSearchField(),
          ),
          SizedBox(
            height: spacing30,
          ),
          Expanded(
            child: (_memberList.length == 0 &&
                    _searchController.text.length > 0)
                ? Center(
                    child: NoDataFound(
                    msg: Localization.of(context).noMemberFound,
                  ))
                : ListView.separated(
                    separatorBuilder: (_, pos) {
                      return Divider(
                        color: colorBorder45,
                        thickness: 0.5,
                        height: 25,
                      );
                    },
                    itemCount: _memberList.length,
                    itemBuilder: (context, pos) {
                      return RippleEffect(
                        onTap: () {
                          if (widget.searchScreen != null &&
                              widget.searchScreen == SearchScreenFrom.addMore) {
                            NavigationUtils.pop(context, args: {
                              ArgumentConstant.member: _memberList[pos]
                            });
                          } else {
                            NavigationUtils.pushReplacement(
                                context, routeAddFamilyMember, arguments: {
                              ArgumentConstant.member: _memberList[pos]
                            });
                          }
                        },
                        child: MemberDetail(
                          member: _memberList[pos],
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
        FocusManager.instance.primaryFocus.unfocus();

        NavigationUtils.pop(context);
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
    return TextFormField(
      controller: _searchController,
      style: TextStyle(color: colorDarkPurple),
      cursorColor: colorDarkPurple,
      maxLength: 10,
      maxLengthEnforced: true,
      onChanged: (s) => _debouncer(() {
        if (_key.currentState.validate()) {
          _onSearch(s);
        } else {
          setState(() {
            _memberList = [];
          });
        }
      }),
      validator: (number) => number.toString().isValidNumber(context),
      textInputAction: TextInputAction.done,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        counterText: "",
        isDense: true,
        fillColor: colorWhiteSmoke44,
        filled: true,
        suffixIconConstraints: BoxConstraints(),
        suffixIcon: InkWell(
          onTap: _onClose,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.cancel,
              color: colorLightBlue,
              size: spacing25,
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
        hoverColor: colorGrey84,
        border: border,
        disabledBorder: border,
        focusedBorder: border,
        hintText: Localization.of(context).search,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
