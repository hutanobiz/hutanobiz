import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/ripple_effect.dart';

class BottomOptionList extends StatelessWidget {
  final String? shareMessage;
  final List<Option> optionList = [];

  BottomOptionList({Key? key, this.shareMessage}) : super(key: key);

  Future<void>? _initList(context) {
    optionList.add(Option(
        label: Localization.of(context)!.searchByNetwork,
        icon: FileConstants.icNetworkPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Localization.of(context)!.searchByName,
        icon: FileConstants.icAvatarPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Localization.of(context)!.searchByNumber,
        icon: FileConstants.icCallPurple,
        route: Routes.searchMember));
    optionList.add(Option(
        label: Localization.of(context)!.inviteByPhone,
        icon: FileConstants.icSendPurple,
        route: Routes.routeInviteByText));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initList(context)?.then((value) => value as Object),
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
                    if (pos == 3) {
                      Navigator.of(context)
                          .pushNamed(optionList[pos].route!, arguments: {
                        ArgumentConstant.shareMessage: shareMessage,
                        ArgumentConstant.loadAllData: pos == 0 ? true : false,
                      });
                    } else {
                      Navigator.of(context)
                          .pushNamed(optionList[pos].route!, arguments: {
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
                            optionList[pos].label!,
                            style: TextStyle(
                              fontSize: fontSize15,
                            ),
                          ),
                        ),
                        Image.asset(
                          optionList[pos].icon!,
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
  final String? label;
  final String? icon;
  final String? route;

  Option({
    this.label,
    this.icon,
    this.route,
  });
}
