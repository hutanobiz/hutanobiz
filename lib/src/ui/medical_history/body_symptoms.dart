import 'package:flutter/material.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import 'human_body/human_body.dart';
import 'provider/appoinment_provider.dart';

class BodySymptoms extends StatefulWidget {
  @override
  _BodySymptomsState createState() => _BodySymptomsState();
}

class _BodySymptomsState extends State<BodySymptoms> {
  GlobalKey silderKey = GlobalKey();
  String _selectedBodyPart;
  bool resetState = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomsInfoProvider>(builder: (context, _, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing10),
                child: HTProgressBar(totalSteps: 5, currentSteps: 2),
              ),
              SizedBox(height: spacing10),
              _buildHeader(),
              _buildBody(),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15, top: 10),
              //   child: Text(
              //     'Select body side',
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //       color: primaryColor,
              //       fontSize: fontSize15,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  Localization.of(context).selectBodyPart,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorBlack85,
                    fontSize: fontSize12,
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBody() => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: spacing15),
          child: Center(
            child: HumanBody(
              bodyImage:
                  Provider.of<SymptomsInfoProvider>(context, listen: false)
                      .bodySide,
              isClickable: true,
              resetStae: resetState,
              bodyPartSelected: (bodyPart) {
                setState(() {
                  _selectedBodyPart = bodyPart;
                });
              },
            ),
          ),
        ),
      );

  Widget _buildBottomButtons() => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing20),
            child: Row(
              children: [
                _buildBodyTypeButton(0, Localization.of(context).back),
                SizedBox(width: spacing15),
                _buildBodyTypeButton(1, Localization.of(context).front),
                SizedBox(width: spacing15),
                _buildBodyTypeButton(2, Localization.of(context).side),
                SizedBox(width: spacing15),
                _buildBodyTypeButton(3, Localization.of(context).allOver),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacing20),
            child: Row(
              children: [
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context).skip,
                    color: primaryColor,
                    onPressed: () {
                      NavigationUtils.push(context, routeMedicineInformation);
                    },
                  ),
                ),
                SizedBox(width: spacing70),
                Expanded(
                  child: HutanoButton(
                    label: Localization.of(context).next,
                    onPressed: () {
                      if (_selectedBodyPart == null) {
                        DialogUtils.showAlertDialog(context,
                            Localization.of(context).errorBodyPartSelect);
                        return;
                      }
                      var symtomsType = Provider.of<SymptomsInfoProvider>(
                              context,
                              listen: false)
                          .symtomsType;
                      var bodySide = Provider.of<SymptomsInfoProvider>(context,
                              listen: false)
                          .bodySide;
                      if (symtomsType == 0) {
                        NavigationUtils.push(context, routePainSymptoms,
                            arguments: {
                              ArgumentConstant.argselectedBodyType: bodySide,
                              ArgumentConstant.argsselectBodyPart:
                                  _selectedBodyPart,
                            });
                      } else if (symtomsType == 1) {
                        NavigationUtils.push(
                            context, routeGeneralizedPainSymptoms);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildBodyTypeButton(int index, String title) => Expanded(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Provider.of<SymptomsInfoProvider>(context, listen: false)
                .setBodySide(index);
            var symtomsType =
                Provider.of<SymptomsInfoProvider>(context, listen: false)
                    .symtomsType;
            var bodySide =
                Provider.of<SymptomsInfoProvider>(context, listen: false)
                    .bodySide;

            setState(() {
              resetState = true;
              _selectedBodyPart = null;
            });
            Future.delayed(Duration(seconds: 1), () {
              resetState = false;
            });
            // if (symtomsType == 0) {
            //   NavigationUtils.push(context, routePainSymptoms, arguments: {
            //     ArgumentConstant.argselectedBodyType: bodySide,
            //   });
            // } else if (symtomsType == 1) {
            //   NavigationUtils.push(context, routeGeneralizedPainSymptoms);
            // }
          },
          child: Container(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                  color:
                      Provider.of<SymptomsInfoProvider>(context, listen: false)
                                  .bodySide ==
                              index
                          ? Colors.black
                          : primaryColor,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium),
            ),
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
              color: Provider.of<SymptomsInfoProvider>(context, listen: false)
                          .bodySide ==
                      index
                  ? colorGrey2
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  width: 0.5,
                  color:
                      Provider.of<SymptomsInfoProvider>(context, listen: false)
                                  .bodySide ==
                              index
                          ? primaryColor
                          : colorGrey),
            ),
          ),
        ),
      );

  Widget _buildHeader() => Container(
        height: 74,
        decoration: BoxDecoration(
            color: colorGreyBackground,
            borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            _buildHeaderButton(0, FileConstants.icCreateFolder,
                Localization.of(context).painSymptoms),
            Container(
              width: 0.5,
              margin: EdgeInsets.symmetric(vertical: 20),
              height: double.maxFinite,
              color: Colors.black,
            ),
            _buildHeaderButton(1, FileConstants.icSadFace,
                Localization.of(context).generalizedSymptoms)
          ],
        ),
      );

  Widget _buildHeaderButton(int index, String iconName, String title) =>
      Expanded(
        child: InkWell(
          onTap: () {
            Provider.of<SymptomsInfoProvider>(context, listen: false)
                .setSypmtomsType(index);
          },
          child: Row(
            children: [
              SizedBox(width: spacing15),
              Image.asset(
                iconName,
                height: 20,
                width: 20,
              ),
              SizedBox(width: spacing5),
              Text(
                title,
                style: TextStyle(
                    color: index == 0 ? accentColor : colorGreen,
                    fontSize: fontSize12,
                    fontWeight: fontWeightMedium,
                    decoration: Provider.of<SymptomsInfoProvider>(context,
                                    listen: false)
                                .symtomsType ==
                            index
                        ? TextDecoration.underline
                        : TextDecoration.none),
              )
            ],
          ),
        ),
      );
}
