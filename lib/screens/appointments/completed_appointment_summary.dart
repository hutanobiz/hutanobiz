import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';
import 'package:hutano/screens/appointments/widgets/summary_provider_widget.dart';
import 'package:hutano/screens/appointments/widgets/vital_complete_widget.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/problem_widget.dart';
import 'package:intl/intl.dart';

class CompletedAppointmentSummary extends StatefulWidget {
  CompletedAppointmentSummary({Key key, this.appointmentId}) : super(key: key);
  String appointmentId;

  @override
  _CompletedAppointmentSummaryState createState() =>
      _CompletedAppointmentSummaryState();
}

class _CompletedAppointmentSummaryState
    extends State<CompletedAppointmentSummary> {
  Future<dynamic> _profileFuture;

  Map profileMap = {};

  Map<int, String> followUpType = {
    1: "Office appointment",
    2: "Telemedicine appointment",
    3: "Onsite Appointment"
  };

  ApiBaseHelper _api = ApiBaseHelper();
  String token = '';

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((usertoken) {
      token = usertoken;
      setState(() {
        _profileFuture = _api.getAppointmentDetails(
            usertoken, widget.appointmentId, LatLng(0.00, 0.00));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackground(
          title: "Appointment Summary",
          isAddBack: true,
          addBackButton: false,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
          child: FutureBuilder(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                profileMap = snapshot.data;
                return profileWidget(profileMap);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CustomLoader(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget profileWidget(Map appointmentData) {
    String age = "---";
    String sex = '';
    String mrn = '';
    if (appointmentData['data']["user"]['dob'] != null) {
      int day, month, year;
      if (appointmentData['data']["user"]['dob'].toString().contains('-')) {
        day = int.parse(appointmentData['data']["user"]['dob'].split("-")[2]);
        month = int.parse(appointmentData['data']["user"]['dob'].split("-")[1]);
        year = int.parse(appointmentData['data']["user"]['dob'].split("-")[0]);
      } else {
        day = int.parse(appointmentData['data']["user"]['dob'].split("/")[1]);
        month = int.parse(appointmentData['data']["user"]['dob'].split("/")[0]);
        year = int.parse(appointmentData['data']["user"]['dob'].split("/")[2]);
      }
      final birthday = DateTime(year, month, day);
      Duration dur = DateTime.now().difference(birthday);
      String differenceInYears = (dur.inDays / 365).floor().toString();
      age = differenceInYears + ' years,';
      sex = (appointmentData['data']['user']['gender'] ?? 1) == 2
          ? " Male, "
          : " Female, ";
      mrn = "MRN:" + appointmentData['data']['mrn'];
    }
    return ListView(padding: EdgeInsets.all(20), children: [
      ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SummaryProviderWidget(
              context: context,
              name: appointmentData['data']['doctor']['title'] +
                  ' ' +
                  appointmentData['data']['doctor']['fullName'],
              exp: (appointmentData['doctorData'][0]["practicingSince"] != null
                      ? (DateTime.now()
                                  .difference(DateTime.parse(
                                      appointmentData['doctorData'][0]
                                          ["practicingSince"]))
                                  .inDays /
                              366)
                          .toStringAsFixed(1)
                      : "---") +
                  " Years of Experience",
              img: appointmentData['data']['doctor']['avatar']),
          SizedBox(height: 20),
          SummaryPatientWidget(
              context: context,
              name: appointmentData['data']['user']['fullName'],
              exp: age + sex + mrn,
              img: appointmentData['data']['user']['avatar']),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Row(
              children: [
                Image.asset(
                  'images/checked_active.png',
                  height: 20,
                ),
                SizedBox(width: 4),
                Text(
                  "Subjective",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: appointmentData['appointmentProblems'].length,
            itemBuilder: (context, index) {
              return ProblemWidget(
                  dob: appointmentData['data']['user']['dob'],
                  gender: appointmentData['data']['user']['gender'],
                  appointmentProblem: appointmentData['appointmentProblems']
                      [index],
                  problemTimeSpanMap: appointmentData['problemTimeSpan']);
            },
          ),
        ],
      ),
      ListView(
        padding: EdgeInsets.only(top: 20),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Row(
              children: [
                Image.asset(
                  'images/checked_active.png',
                  height: 20,
                ),
                SizedBox(width: 4),
                Text(
                  "Test and Measures",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          AppointmentData.fromJson(appointmentData).doctorFeedback[0].vitals !=
                      null &&
                  (AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .vitals
                              .bloodPressureSbp !=
                          null ||
                      AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .vitals
                              .temperature !=
                          null)
              ? VitalsCompleteWidget(
                  vitals: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .vitals,
                )
              : SizedBox(),
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .heartAndLungs !=
                      null &&
                  ((AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .heartAndLungs
                                  .heart !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .heartAndLungs
                              .heart
                              .sound
                              .isNotEmpty) ||
                      (AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .heartAndLungs
                                  .lung !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .heartAndLungs
                              .lung
                              .summary
                              .isNotEmpty))
              ? HeartLungsCompleteWidget(
                  heartAndLungs: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .heartAndLungs)
              : SizedBox(),
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological !=
                      null &&
                  (AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .sensoryDeficits
                          .isNotEmpty ||
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .dtrDeficits
                          .isNotEmpty ||
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .strengthDeficits
                          .isNotEmpty ||
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .romDeficits
                          .isNotEmpty ||
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .positiveTests
                          .isNotEmpty)
              ? NeurologicalCompleteWidget(
                  sensoryDeficts: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .neurological
                      .sensoryDeficits,
                  dtrDeficts: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .neurological
                      .dtrDeficits,
                  strengthDeficts: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .neurological
                      .strengthDeficits,
                  romDeficts: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .neurological
                      .romDeficits,
                  positiveTestDeficts: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .neurological
                      .positiveTests,
                  neurologicalConcernList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .clinicalConcern,
                  neurologicalTreatmentlist:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .treatment,
                  neurologicalDiagnosisList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .neurological
                          .icd)
              : SizedBox(),
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .specialTests !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .specialTests
                      .tests
                      .isNotEmpty
              ? SpecialTestCompleteWidget(
                  specialTests: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .specialTests
                      .tests,
                  specialTestsConcernList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .specialTests
                          .clinicalConcern,
                  specialTestsTreatmentlist:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .specialTests
                          .treatment,
                  specialTestsDiagnosisList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .specialTests
                          .icd)
              : SizedBox(),
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal !=
                      null &&
                  (AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal
                          .muscle
                          .isNotEmpty ||
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal
                          .joint
                          .isNotEmpty)
              ? MuscleJointCompleteWidget(
                  muscleList: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .musculoskeletal
                      .muscle,
                  jointList: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .musculoskeletal
                      .joint,
                  masculoskeletonConcernList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal
                          .clinicalConcern,
                  masculoskeletonTreatmentlist:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal
                          .treatment,
                  masculoskeletonDiagnosisList:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .musculoskeletal
                          .icd)
              : SizedBox(),
        ],
      ),
      ListView(
        padding: EdgeInsets.only(top: 20),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Row(
              children: [
                Image.asset(
                  'images/checked_active.png',
                  height: 20,
                ),
                SizedBox(width: 4),
                Text(
                  "Treatment Options",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey[200]),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .education !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .education
                                  .length >
                              0
                      ? educationCategoriesWidget(
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .education)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .labTests
                                  .length >
                              0
                      ? testsWidget(AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .labDetails
                          .labTests)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .preferredLabs !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .preferredLabs
                                  .name !=
                              null
                      ? prefferedLabWidget(
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .labDetails
                              .preferredLabs)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .labTestInstructions !=
                              null
                      ? InstructionWidget(
                          title: 'Labs Instructions',
                          text: AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .labDetails
                              .labTestInstructions)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .imagings
                                  .length >
                              0
                      ? imagingWidget(AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .imagingDetails
                          .imagings)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .preferredImagingCenters !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .preferredImagingCenters
                                  .name !=
                              null
                      ? preferredImagingWidget(
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .imagingDetails
                              .preferredImagingCenters)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .imagingInstructions !=
                              null
                      ? InstructionWidget(
                          title: 'Imaging Instructions',
                          text: AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .imagingDetails
                              .imagingInstructions)
                      : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .exerciseDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .exerciseDetails
                                  .exercises
                                  .length >
                              0
                      ? exerciseWidget(AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .exerciseDetails
                          .exercises)
                      : SizedBox(),
                  // prescriptions.length > 0 ? prescriptionWidget() : SizedBox(),
                  // preferredPhramacy != null
                  //     ? preffredPharmacyWidget()
                  //     : SizedBox(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .therapeuticIntervention !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .therapeuticIntervention
                                  .intervention
                                  .length >
                              0
                      ? therapyWidget(
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .therapeuticIntervention
                              .intervention,
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .therapeuticIntervention)
                      : SizedBox(),
                  appointmentData['followUpAppointment'].length > 0
                      ? followUpWidget(
                          appointmentData['followUpAppointment'][0])
                      : noFollowUpWidget(),
                  SizedBox(height: 10),
                  Text(
                    'Signature',
                    style: AppTextStyle.semiBoldStyle(fontSize: 16),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      border: Border.all(
                        color: Colors.grey[300],
                        width: 1.0,
                      ),
                    ),
                    height: 100.0,
                    child: Image.network(
                      ApiBaseHelper.image_base_url +
                          appointmentData['data']['doctorSign'],
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              )),
        ],
      ),
    ]);
  }

  Column therapyWidget(List<Intervention> intervention,
      TherapeuticIntervention therapeuticIntervention) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Therapeuticlntervention',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 2),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: intervention.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022 ${intervention[index].name}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ),
        therapeuticIntervention.clinicalConcern.isNotEmpty
            ? EmrCompleteConcernListWidget(
                clinicalList: therapeuticIntervention.clinicalConcern)
            : SizedBox(),
        therapeuticIntervention.treatment.isNotEmpty
            ? EmrCompleteTreatmentListWidget(
                treatmentList: therapeuticIntervention.treatment)
            : SizedBox(),
        therapeuticIntervention.icd.isNotEmpty
            ? EmrCompleteDiagnosisListWidget(
                diagnosisList: therapeuticIntervention.icd)
            : SizedBox(),
      ],
    );
  }

  Column educationCategoriesWidget(List<Education> educationCategories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Education',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: educationCategories.length,
            itemBuilder: (context, index) {
              return Text(
                '\u2022 ${educationCategories[index].name}',
                style: AppTextStyle.mediumStyle(fontSize: 14),
              );
            },
          ),
        ),
      ],
    );
  }

  Column testsWidget(List<LabTests> labTest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Tests',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: labTest.length,
            itemBuilder: (context, index) {
              return Text(
                '\u2022 ${labTest[index].name}',
                style: AppTextStyle.mediumStyle(fontSize: 14),
              );
            },
          ),
        ),
      ],
    );
  }

  Column prefferedLabWidget(PreferredLabs preferredLabs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Preffred Lab',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          preferredLabs.name,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
        Text(
          preferredLabs.address != null
              ? preferredLabs.address.address +
                  ', ' +
                  preferredLabs.address.city +
                  ', ' +
                  preferredLabs.address.state +
                  ', ' +
                  preferredLabs.address.zipCode
              : '---',
          style: AppTextStyle.regularStyle(fontSize: 14),
        )
      ],
    );
  }

  Column preferredImagingWidget(PreferredImagingCenters preferredImaging) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Preffred Imaging',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          preferredImaging.name,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
        Text(
          preferredImaging.address != null
              ? preferredImaging.address.address +
                  ', ' +
                  preferredImaging.address.city +
                  ', ' +
                  preferredImaging.address.state +
                  ', ' +
                  preferredImaging.address.zipCode
              : '---',
          style: AppTextStyle.regularStyle(fontSize: 14),
        )
      ],
    );
  }

  Column imagingWidget(List<Imagings> imaging) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Imaging',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: imaging.length,
            itemBuilder: (context, index) {
              return Text(
                '\u2022 ${imaging[index].name}',
                style: AppTextStyle.mediumStyle(fontSize: 14),
              );
            },
          ),
        ),
      ],
    );
  }

  Column exerciseWidget(List<Exercises> exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Exercise',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: exercise.length,
            itemBuilder: (context, index) {
              List<dynamic> imageVideo = [];
              for (dynamic img in exercise[index].images) {
                imageVideo.add({'type': '1', 'url': img});
              }
              if (exercise[index].video != null) {
                imageVideo.add({'type': '2', 'url': exercise[index].video});
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022 ${exercise[index].name}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            shrinkWrap: true,
                            itemCount:
                                imageVideo.length > 2 ? 2 : imageVideo.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.imageSlider,
                                      arguments: imageVideo);
                                },
                                child:
                                    Stack(fit: StackFit.passthrough, children: [
                                  imageVideo[index]['type'] == '1'
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          child: Image.network(
                                            ApiBaseHelper.image_base_url +
                                                imageVideo[index]['url'],
                                            fit: BoxFit.cover,
                                            height: 60,
                                          ),
                                        )
                                      : Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          child:
                                              Icon(Icons.play_arrow_outlined),
                                        ),
                                  imageVideo.length > 2 && index == 1
                                      ? Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            // border: Border.all(color: Colors.grey[300]),
                                            color: Colors.black45,

                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          child: Center(
                                            child: Text(
                                                '+${imageVideo.length - 1}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )
                                      : SizedBox()
                                ]),
                              );
                            },
                          )),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "Frequency: ${exercise[index].frequency}",
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Times: ${exercise[index].times}",
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Sets: ${exercise[index].sets}",
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column followUpWidget(dynamic followUp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'FollowUp',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          '${followUpType[followUp['type']]} at: ${DateFormat("yyyy-MM-dd, h:mm a").format(DateFormat("yyyy-MM-ddThh:mm:ss.000Z").parse(followUp['date'], true).toLocal())}',
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
      ],
    );
  }

  Column noFollowUpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'FollowUp',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'No follow up required',
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
      ],
    );
  }
}
