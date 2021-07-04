import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/widgets/ripple_effect.dart';

class BottomOptionList extends StatelessWidget {
  final String shareMessage;
  final List<Option> optionList = [];

  BottomOptionList({Key key, this.shareMessage}) : super(key: key);

  Future<void> _initList(context) {
    optionList.add(Option(
        label: Strings.searchByNetwork,
        icon: FileConstants.icNetworkPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Strings.searchByName,
        icon: FileConstants.icAvatarPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Strings.searchByNumber,
        icon: FileConstants.icCallPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Strings.inviteByPhone,
        icon: FileConstants.icSendPurple,
        route: Routes.searchMember));
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
                  height: 15,
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
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            optionList[pos].label,
                            style: TextStyle(
                              fontSize: 15,
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
