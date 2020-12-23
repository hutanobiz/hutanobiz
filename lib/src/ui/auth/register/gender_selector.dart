import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/size_config.dart';

class GenderSelector extends StatefulWidget {
  final Function onGenderChange;
  final GenderType gender;

  const GenderSelector({Key key, this.onGenderChange, this.gender})
      : super(key: key);
  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<RadioModel> data = <RadioModel>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     data.add(RadioModel(Localization.of(context).male, FileConstants.icMale,
          GenderType.male, colorPurple100));
      data.add(RadioModel(Localization.of(context).female,
          FileConstants.icFemale, GenderType.female, colorPink));
  }

  _buildRadioButton(int pos) {
    
    var genderModel = data[pos];
    return GestureDetector(
      onTap: () {
        widget.onGenderChange(genderModel.value);
      },
      child: Container(
        height: spacing50,
        width: SizeConfig.screenWidth / 2.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              genderModel.icon,
              height: spacing20,
              width: spacing20,
            ),
            SizedBox(
              width: spacing10,
            ),
            Text(
              genderModel.text,
              style: TextStyle(color: genderModel.color),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: (widget.gender == genderModel.value)
                  ? genderModel.color
                  : colorGrey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRadioButton(0),
          _buildRadioButton(1),
        ],
      ),
    );
  }
}

class RadioModel {
  final String text;
  final String icon;
  final GenderType value;
  final Color color;

  RadioModel(this.text, this.icon, this.value, this.color);
}
