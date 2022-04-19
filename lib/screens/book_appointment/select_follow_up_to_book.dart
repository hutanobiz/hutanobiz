import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/selection_health_issue_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/chat/models/recent_chat_model.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/appointment_type_chip_widget.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectFollowUpToBook extends StatefulWidget {
  SelectFollowUpToBook({Key key}) : super(key: key);

  @override
  _SelectFollowUpToBookState createState() => _SelectFollowUpToBookState();
}

class _SelectFollowUpToBookState extends State<SelectFollowUpToBook> {
  bool isLoading = true;
  TextEditingController controller = new TextEditingController();

  List<dynamic> appointments = [];
  List<dynamic> _searchResult = [];
  dynamic selectedAppointmnet;

  @override
  void initState() {
    super.initState();
    _getMyDiseaseList();
  }

  _getMyDiseaseList() {
    ApiManager().getPatientDoctorAppointmentList().then((result) {
      appointments = result;

      setLoading(false);
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        setLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
          title: "Chief Complaint",
          padding: EdgeInsets.only(top: 10),
          isAddBack: false,
          addHeader: true,
          isLoading: isLoading,
          addBottomArrows: true,
          onForwardTap: () {
            if (selectedAppointmnet == null) {
              Widgets.showToast("Please select an appointment");
            } else {
              String doctorId =
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .providerId;
              List<BookedMedicalHistory> medicalHistory =
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .medicalHistoryData;
              String providerAddress =
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .providerAddress;
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .resetHealthConditionProvider();
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateProviderId(doctorId);
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateMedicalHistory(medicalHistory);
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateProviderAddress(providerAddress);
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateAllHealthIssuesData([]);
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updatePreviousAppointment(selectedAppointmnet);

              List<SelectionHealthIssueModel> _selectedConditionList = [];
              List<int> tempList = [];
              int i = 0;
              selectedAppointmnet['appintmentProblems'].forEach((element) {
                // if (element.isSelected) {
                _selectedConditionList.add(SelectionHealthIssueModel(
                    index: i,
                    sId: element['problemId'],
                    name: element['name'],
                    image: element['image'],
                    problem: selectedAppointmnet['appintmentProblems'][i],
                    isSelected: true));
                tempList.add(i);
                i++;
                // } else {
                //   i++;
                // }
              });
              if (tempList.isNotEmpty) {
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .updateHealthConditions(tempList);
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .updateListOfSelectedHealthIssues(_selectedConditionList);
                for (int i = 0;
                    i <
                        Provider.of<HealthConditionProvider>(context,
                                listen: false)
                            .listOfSelectedHealthIssues
                            .length;
                    i++) {
                  if (i ==
                      Provider.of<HealthConditionProvider>(context,
                              listen: false)
                          .currentIndexOfIssue) {
                    Provider.of<HealthConditionProvider>(context, listen: false)
                        .updateCurrentIndex(0);
                    Navigator.of(context)
                        .pushNamed(Routes.routeBoneAndMuscle, arguments: {
                      ArgumentConstant.problemIdKey:
                          Provider.of<HealthConditionProvider>(context,
                                  listen: false)
                              .listOfSelectedHealthIssues[i]
                              .sId,
                      ArgumentConstant.problemNameKey:
                          Provider.of<HealthConditionProvider>(context,
                                  listen: false)
                              .listOfSelectedHealthIssues[i]
                              .name,
                      ArgumentConstant.problemImageKey:
                          Provider.of<HealthConditionProvider>(context,
                                  listen: false)
                              .listOfSelectedHealthIssues[i]
                              .image,
                      ArgumentConstant.problem:
                          Provider.of<HealthConditionProvider>(context,
                                  listen: false)
                              .listOfSelectedHealthIssues[i]
                              .problem,
                      // ArgumentConstant.appointmentId: widget.appointmentId
                    });
                  }
                }
              } else {
                Widgets.showToast("Please select any health condition");
              }
            }
          },
          isBackRequired: true,
          child: Column(
            children: [
              Text(
                'Chief Complaint',
                style: AppTextStyle.boldStyle(fontSize: 20),
              ),
              SizedBox(height: 6),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 40,
                  decoration: BoxDecoration(
                      color: colorBlack2.withOpacity(0.06),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextFormField(
                    controller: controller,
                    decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: AppColors.goldenTainoi,
                        ),
                        onPressed: () {
                          controller.clear();
                          selectedAppointmnet = null;
                          onSearchTextChanged('');
                        },
                      ),
                      hintText: 'Search',
                      isDense: true,
                      hintStyle: TextStyle(
                          color: colorBlack2,
                          fontSize: fontSize13,
                          fontWeight: fontWeightRegular),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onChanged: onSearchTextChanged,
                  )),
              SizedBox(height: 6),
              Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: controller.text.isEmpty
                        ? appointments.length
                        : _searchResult.length,
                    itemBuilder: (context, index) {
                      return recentChatProviderWidget(controller.text.isEmpty
                          ? appointments[index]
                          : _searchResult[index]);
                    }),
              ),
            ],
          )),
    );
  }

  void setLoading(bool value) {
    setState(() => isLoading = value);
  }

  recentChatProviderWidget(dynamic chatAppointment) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAppointmnet = chatAppointment;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(14.0),
          ),
          border: Border.all(
              color: selectedAppointmnet == chatAppointment
                  ? AppColors.goldenTainoi
                  : Colors.grey[300]),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      splashColor: Colors.grey[200],
                      onTap: chatAppointment['doctor'][0]["avatar"] != null
                          ? () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.of(context).pushNamed(
                                Routes.providerImageScreen,
                                arguments: (ApiBaseHelper.imageUrl +
                                    chatAppointment['doctor'][0]["avatar"]),
                              );
                            }
                          : null,
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                chatAppointment['doctor'][0]["avatar"] == null
                                    ? AssetImage(FileConstants.icImgPlaceHolder)
                                    : NetworkImage(ApiBaseHelper.imageUrl +
                                        chatAppointment['doctor'][0]["avatar"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: spacing8,
                        right: spacing8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            chatAppointment['doctor'][0]['title'] +
                                ' ' +
                                chatAppointment['doctor'][0]['fullName'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: colorBlack,
                                fontWeight: fontWeightSemiBold,
                                fontSize: fontSize14),
                          ),
                          SizedBox(height: spacing4),
                          Text(
                              chatAppointment['appintmentProblems'][0]['name']),
                          SizedBox(height: spacing4),
                          Row(
                            children: [
                              Image(
                                image: AssetImage(
                                    "images/ic_appointment_time.png"),
                                height: 16.0,
                                width: 16.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat('MMM dd, hh:mm a')
                                    .format(DateTime.utc(
                                            DateTime.parse(
                                                    chatAppointment['date'])
                                                .year,
                                            DateTime.parse(
                                                    chatAppointment['date'])
                                                .month,
                                            DateTime.parse(
                                                    chatAppointment['date'])
                                                .day,
                                            int.parse(
                                                chatAppointment['fromTime']
                                                    .split(':')[0]),
                                            int.parse(
                                                chatAppointment['fromTime']
                                                    .split(':')[1]))
                                        .toLocal())
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    selectedAppointmnet = null;
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    appointments.forEach((userDetail) {
      if (userDetail['doctorName']
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        _searchResult.add(userDetail);
      } else {
        for (dynamic problem in userDetail['appintmentProblems']) {
          if (problem['name']
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase())) {
            _searchResult.add(userDetail);
            break;
          }
        }
        ;
      }
    });

    setState(() {});
  }
}
