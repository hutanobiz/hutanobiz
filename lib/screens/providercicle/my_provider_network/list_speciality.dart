import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import '../../../utils/extensions.dart';
import '../provider_search/model/provider_detail_model.dart';
import 'expandable_header.dart';
import 'item_provider_detail.dart';
import 'model/provider_group.dart';
import 'model/res_my_provider_network.dart';

class ListSpeciality extends StatefulWidget {
  final List<ProviderGroupList>? providerGroupList;
  final Function? onShare;
  final Function? onRemove;
  final Function? onMakeAppointment;
  final Function? onGroupDelete;

  const ListSpeciality(
      {Key? key,
      this.providerGroupList,
      this.onShare,
      this.onRemove,
      this.onMakeAppointment,
      this.onGroupDelete})
      : super(key: key);
  @override
  _ListSpecialityState createState() => _ListSpecialityState();
}

class _ListSpecialityState extends State<ListSpeciality> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, pos) {
          return SizedBox(height: spacing15);
        },
        shrinkWrap: true,
        itemCount: widget.providerGroupList!.length,
        itemBuilder: (_, pos) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: spacing10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorGrey,
                width: 0.5,
              ),
            ),
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                  hasIcon: true,
                  iconSize: spacing30,
                  iconColor: colorBlack60,
                  iconPadding: EdgeInsets.only(top: spacing15)),
              header: ExpandableHeader(
                providerGroup: _getProviderGroup(pos),
                onDelete: widget.onGroupDelete,
                pos:pos
              ),
              expanded: Column(
                children: [
                  Divider(
                    color: colorGrey3,
                    thickness: 0.5,
                    indent: 5,
                  ),
                  SizedBox(height: spacing10),
                  ListView.separated(
                      separatorBuilder: (_, pos) {
                        return SizedBox(height: spacing15);
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.providerGroupList![pos].doctor!.length,
                      itemBuilder: (_, position) {
                        return ItemProviderDetail(
                            providerDetail: _getProviderDetail(pos, position),
                            index: pos,
                            subIndex: position,
                            onShare: widget.onShare,
                            onRemove: widget.onRemove,
                            onMakeAppointment: widget.onMakeAppointment);
                      }),
                  SizedBox(height: spacing15),
                ],
              ), collapsed: SizedBox(),
            ),
          );
        });
  }

  _getProviderDetail(index, subIndex) {
    final doctorData = widget.providerGroupList![index].doctor![subIndex];
    final doctorProfessionInfo =
        widget.providerGroupList![index].docInfo![subIndex];

    final avatar = doctorData.avatar ?? "";
    final rating = "4";
    // final occupation = doctorProfessionInfo?.professionalTitle[0]?.title ?? "";
    final occupation = "MD A";
    var name = doctorData.fullName ?? "";
    name = '$name , ${occupation.getInitials()}';

    final experience = doctorProfessionInfo.practicingSince!.getYearCount();

    return ProviderDetail(
        image: avatar,
        rating: rating,
        name: name,
        occupation: occupation,
        experience: experience);
  }

  _getProviderGroup(index) {
    return ProviderGroup(
      count: widget.providerGroupList![index].doctor!.length,
      image: " ",
      groupType: widget.providerGroupList![index].providerNetwork!.groupName,
    );
  }
}
