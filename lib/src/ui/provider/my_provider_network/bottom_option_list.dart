import 'package:flutter/material.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../widgets/ripple_effect.dart';

class BottomOptionList extends StatelessWidget {
  final String shareMessage;
  final List<Option> optionList = [];

  BottomOptionList({Key key, this.shareMessage}) : super(key: key);

  Future<void> _initList(context) {
    optionList.add(Option(
        label: Localization.of(context).searchByNetwork,
        icon: FileConstants.icNetworkPurple,
        route: routeSearchMember));
    optionList.add(Option(
        label: Localization.of(context).searchByName,
        icon: FileConstants.icAvatarPurple,
        route: routeSearchMember));
    optionList.add(Option(
        label: Localization.of(context).searchByNumber,
        icon: FileConstants.icCallPurple,
        route: routeSearchMember));
    optionList.add(Option(
        label: Localization.of(context).inviteByPhone,
        icon: FileConstants.icSendPurple,
        route: routeInviteByText));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initList(context),
        builder: (context, snapshot) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: optionList.length,
              separatorBuilder: (_, pos) {
                return SizedBox(
                  height: spacing15,
                );
              },
              itemBuilder: (_, pos) {
                return RippleEffect(
                  onTap: () {
                    if(pos == 3){
                    Navigator.of(context).pushNamed( optionList[pos].route,
                        arguments: {
                          ArgumentConstant.shareMessage: shareMessage,
                          ArgumentConstant.loadAllData: pos == 0 ? true : false,
                        });
                    }else{
                      Navigator.of(context).pushNamed( optionList[pos].route,
                        arguments: {
                          ArgumentConstant.shareMessage: shareMessage,
                        });
                    }
                  },
                  child: Container(
                    height: 42,
                    padding: EdgeInsets.symmetric(horizontal: spacing12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            optionList[pos].label,
                            style: TextStyle(
                              fontSize: fontSize15,
                            ),
                          ),
                        ),
                        Image.asset(
                          optionList[pos].icon,
                          height: 15,
                          width: 15,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                  ),
                );
              });
        });
  }
}

class Option {
  final String label;
  final String icon;
  final String route;

  Option({
    this.label,
    this.icon,
    this.route,
  });
}
