import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

class AppointmentTypeScreen extends StatefulWidget {
  final Map appointmentTypeMap;

  AppointmentTypeScreen({Key key, this.appointmentTypeMap}) : super(key: key);

  @override
  _AppointmentTypeScreenState createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  InheritedContainerState conatiner;
  Map _appointentTypeMap = {};
  bool isOfficeSelected = false;
  bool isVirtualSelected = false;
  bool isHomeSelected = false;
  String selectedType = "";

  @override
  void initState() {
    super.initState();

    _appointentTypeMap["isOfficeEnabled"] = true;
    _appointentTypeMap["isVideoChatEnabled"] = true;
    _appointentTypeMap["isOnsiteEnabled"] = true;

    if (widget.appointmentTypeMap != null) {
      _appointentTypeMap = widget.appointmentTypeMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);

    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        child: column(context),
        addBottomArrows: true,
        onForwardTap: () {
          if (selectedType.isNotEmpty) {
            if (widget.appointmentTypeMap['services'] != null) {
              List<Services> searchedSubService = [];
              for (Services s in widget.appointmentTypeMap['services']) {
                if (s.serviceType.toString() == selectedType) {
                  searchedSubService.add(s);
                  break;
                }
              }

              conatiner.setProjectsResponse("serviceType",
                  searchedSubService.first.serviceType.toString());
              conatiner.setServicesData("status", "1");
              conatiner.setServicesData("services", searchedSubService);
              Navigator.of(context).pushNamed(
                  Routes.selectAppointmentTimeScreen,
                  arguments: SelectDateTimeArguments(fromScreen: 0));
            } else {
              conatiner.setProjectsResponse("serviceType", selectedType);
              Navigator.of(context).pushNamed(Routes.selectServicesScreen);
            }
          } else {
            Widgets.showToast(Localization.of(context).noAppointmentSelected);
          }
        },
      ),
    );
  }

  Widget column(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(Localization.of(context).appointmentTypeScreenHeader,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: fontWeightSemiBold,
                  fontSize: fontSize18)),
        ),
        cardView(
            FileConstants.icProviderOffice,
            Localization.of(context).providerOfficeLabel,
            Localization.of(context).providerOfficeSubLabel,
            _appointentTypeMap[ArgumentConstant.isOfficeEnabled],
            '1',
            isOfficeSelected),
        SizedBox(height: 20.0),
        cardView(
            FileConstants.icVideoChatAppointment,
            Localization.of(context).videoChatLabel,
            Localization.of(context).videoChatSubLabel,
            _appointentTypeMap[ArgumentConstant.isVideoChatEnabled],
            '2',
            isVirtualSelected),
        SizedBox(height: 20.0),
        cardView(
            FileConstants.icOnSiteAppointment,
            Localization.of(context).onSiteLabel,
            Localization.of(context).onSiteSubLabel,
            _appointentTypeMap[ArgumentConstant.isOnsiteEnabled],
            '3',
            isHomeSelected),
      ],
    );
  }

  Widget cardView(String image, String cardText, String subText,
      bool isAppointmentTypeTrue, String type, bool isSelected) {
    return !isAppointmentTypeTrue
        ? Container()
        : CustomCardView(
            onTap: () {
              if (type == '1') {
                isOfficeSelected = true;
                isVirtualSelected = false;
                isHomeSelected = false;
                selectedType = "1";
              } else if (type == '2') {
                isOfficeSelected = false;
                isVirtualSelected = true;
                isHomeSelected = false;
                selectedType = "2";
              }
              if (type == '3') {
                isOfficeSelected = false;
                isVirtualSelected = false;
                isHomeSelected = true;
                selectedType = "3";
              }
              setState(() {});
            },
            image: image,
            cardText: cardText,
            cardSubText: subText,
            isSelected: isSelected,
          );
  }
}
