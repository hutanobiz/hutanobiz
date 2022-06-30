import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_card_view.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

class AppointmentTypeScreen extends StatefulWidget {
  final Map? appointmentTypeMap;

  AppointmentTypeScreen({Key? key, this.appointmentTypeMap}) : super(key: key);

  @override
  _AppointmentTypeScreenState createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  late InheritedContainerState conatiner;
  Map? _appointentTypeMap = {};
  bool isOfficeSelected = false;
  bool isVirtualSelected = false;
  bool isHomeSelected = false;
  String selectedType = "";
  late var isFirstAppointmentOnline;
  var totalAppointmentWithProvider;

  @override
  void initState() {
    super.initState();

    _appointentTypeMap!["isOfficeEnabled"] = true;
    _appointentTypeMap!["isVideoChatEnabled"] = true;
    _appointentTypeMap!["isOnsiteEnabled"] = true;

    if (widget.appointmentTypeMap != null) {
      _appointentTypeMap = widget.appointmentTypeMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);
    isFirstAppointmentOnline = conatiner.providerResponse['providerData']
            ['data'][0]['isFirstAppointmentOnline'] ??
        false;

    totalAppointmentWithProvider = conatiner.providerResponse['providerData']
            ['totalAppointmentWithProvider'] ??
        0;
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        child: column(context),
        addBottomArrows: true,
        onForwardTap: () {
          if (selectedType.isNotEmpty) {
            if (widget.appointmentTypeMap!['services'] != null) {
              List<Services> searchedSubService = [];
              for (Services s in widget.appointmentTypeMap!['services']) {
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
            Widgets.showToast(Localization.of(context)!.noAppointmentSelected);
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
          child: Text(Localization.of(context)!.appointmentTypeScreenHeader,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: fontWeightSemiBold,
                  fontSize: fontSize18)),
        ),
        isFirstAppointmentOnline && totalAppointmentWithProvider == 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.sunglow.withOpacity(0.20),
                  border: Border.all(
                    width: 1.0,
                    color: AppColors.sunglow,
                  ),
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.goldenTainoi,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text("This provider's first consult is virtual",
                          style: AppTextStyle.mediumStyle(fontSize: 15)),
                    ),
                  ],
                ))
            : SizedBox(),
        cardView(
            FileConstants.icProviderOffice,
            Localization.of(context)!.providerOfficeLabel,
            Localization.of(context)!.providerOfficeSubLabel,
            _appointentTypeMap![ArgumentConstant.isOfficeEnabled],
            '1',
            isOfficeSelected,
            !(isFirstAppointmentOnline && totalAppointmentWithProvider == 0)),
        SizedBox(height: 20.0),
        cardView(
            FileConstants.icVideoChatAppointment,
            Localization.of(context)!.videoChatLabel,
            Localization.of(context)!.videoChatSubLabel,
            _appointentTypeMap![ArgumentConstant.isVideoChatEnabled],
            '2',
            isVirtualSelected,
            true),
        SizedBox(height: 20.0),
        cardView(
            FileConstants.icOnSiteAppointment,
            Localization.of(context)!.onSiteLabel,
            Localization.of(context)!.onSiteSubLabel,
            _appointentTypeMap![ArgumentConstant.isOnsiteEnabled],
            '3',
            isHomeSelected,
            !(isFirstAppointmentOnline && totalAppointmentWithProvider == 0)),
      ],
    );
  }

  Widget cardView(
      String image,
      String cardText,
      String subText,
      bool isAppointmentTypeTrue,
      String type,
      bool isSelected,
      bool isEnabled) {
    return !isAppointmentTypeTrue
        ? Container()
        : CustomCardView(
            onTap: isEnabled
                ? () {
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
                  }
                : null,
            isEnabled: isEnabled,
            image: image,
            cardText: cardText,
            cardSubText: subText,
            isSelected: isSelected,
          );
  }
}
