import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/familynetwork/add_family_member/model/res_relation_list.dart';
import 'package:hutano/screens/familynetwork/my_contacts/my_contacts.dart';
import 'package:hutano/screens/registration/otp_verification/model/verification_model.dart';
import 'package:hutano/screens/registration/register_phone/model/req_register_number.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/list_picker.dart';
import 'package:hutano/widgets/widgets.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/base_checkbox.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_phone_input.dart';

class LinkAccount extends StatefulWidget {
  dynamic userData;
  LinkAccount({Key key, this.userData}) : super(key: key);

  @override
  _LinkAccountState createState() => _LinkAccountState();
}

class _LinkAccountState extends State<LinkAccount> {
  final GlobalKey<FormState> _key = GlobalKey();

  List<Relations> _relationList = [];
  Relations _selectedRelation;
  @override
  void initState() {
    super.initState();
    _getRelation();
  }

  _getRelation() async {
    try {
      var res = await ApiManager().getRelations();
      setState(() {
        _relationList = res.response;
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _onSubmitClick() async {
    ProgressDialogUtils.showProgressDialog(context);
    widget.userData['relation'] = _selectedRelation.relation;
    var request = {
      'phoneNumber': widget.userData['phoneNumber'].toString(),
      'relation': _selectedRelation.relation
    };
    try {
      var res = await ApiManager().sendLinkAccountCode(request);
      ProgressDialogUtils.dismissProgressDialog();
      if (res is String) {
        Widgets.showAppDialog(context: context, description: res);
      } else {
        Navigator.of(context)
            .pushNamed(Routes.linkVerification, arguments: widget.userData);
      }
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    getScreenSize(context);
    return Container(
      color: colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _key,
            child: Container(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      CustomBackButton(),
                    ],
                  ),
                  HutanoHeader(
                    headerInfo: HutanoHeaderInfo(
                      title: 'Show Account',
                      // subTitle:
                      //     '',
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: Colors.grey[100],
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                ApiBaseHelper.imageUrl +
                                    widget.userData['avatar'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userData['fullName'],
                                  style: AppTextStyle.boldStyle(fontSize: 16)),
                              Text('Lorem ipsum Dummy Text',
                                  style:
                                      AppTextStyle.regularStyle(fontSize: 13)),
                            ],
                          ),
                        ],
                      )),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: Colors.grey[100],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_selectedRelation == null
                                  ? 'Select Relation'
                                  : _selectedRelation.relation),
                            ),
                            Icon(Icons.keyboard_arrow_down_outlined)
                          ],
                        )),
                    onTap: () {
                      showDropDownSheet(
                          list: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text("Select Relation",
                                    style: TextStyle(fontSize: 24)),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _relationList.length,
                                  itemBuilder: (context, pos) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedRelation =
                                                _relationList[pos];
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                          title: Center(
                                            child: Text(
                                                _relationList[pos].relation),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                          context: context);
                    },
                  ),
                  _buildSubmitButton()
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return HutanoButton(
      margin: spacing20,
      onPressed: _selectedRelation != null ? _onSubmitClick : null,
      label: Localization.of(context).next,
    );
  }
}
