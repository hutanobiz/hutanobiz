import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/anthropometric_completed_summary_widget.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';
import 'package:hutano/screens/appointments/widgets/gait_completed_widget.dart';
import 'package:hutano/screens/appointments/widgets/integumentry_completed_widget.dart';
import 'package:hutano/screens/appointments/widgets/summary_provider_widget.dart';
import 'package:hutano/screens/appointments/widgets/vital_complete_widget.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
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
  Future<dynamic> appointmentDetailFuture;
  Future<PatientMedicationResponse> medicationChangesFuture;
  Map profileMap = {};

  Map<int, String> followUpType = {
    1: "Office appointment",
    2: "Telemedicine appointment",
    3: "Onsite Appointment"
  };
  List<String> medChangeString = ['Added', 'Reviewed', 'Discontinued'];

  ApiBaseHelper _api = ApiBaseHelper();
  String token = '';
  List<Data> appointmentMedication = [];

  @override
  void initState() {
    super.initState();

    appointmentDetailFuture = _api.getAppointmentDetails(
        "Bearer ${getString(PreferenceKey.tokens)}",
        widget.appointmentId,
        LatLng(0.00, 0.00));
    getMedicationHistoryApi();
  }

  getMedicationHistoryApi() {
    var filterString = '&appointment=${widget.appointmentId}';
    medicationChangesFuture = ApiManager()
        .getMedicationDetails(getString(PreferenceKey.id), 1, '', filterString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
          title: "Appointment Summary",
          isAddBack: false,
          addHeader: true,
          isBackRequired: true,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
          child: FutureBuilder(
            future: appointmentDetailFuture,
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
    String license = '';
    String encounterDate = '';
    String professionalTitle = '';
    if (appointmentData['doctorData'] != null &&
        appointmentData['doctorData'].isNotEmpty) {
      if (appointmentData['doctorData'][0]['licenseDetails'] != null &&
          appointmentData['doctorData'][0]['licenseDetails'].isNotEmpty) {
        license =
            ' (License ${appointmentData['doctorData'][0]['licenseDetails'][0]['licenseNumber']})';
      }
      if (appointmentData['doctorData'][0]['professionalTitle'] != null) {
        professionalTitle = Extensions.getSortProfessionTitle(
            appointmentData['doctorData'][0]['professionalTitle']["title"] ??
                "---");
      }
    }
    if (appointmentData['data']['createdAt'] != null) {
      encounterDate = DateFormat('MMM dd, yyyy').format(
          DateTime.parse(appointmentData['data']['completedAt']).toLocal());
    }

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
      mrn = appointmentData['data']['mrn'];
    }
    return ListView(padding: EdgeInsets.all(20), children: [
      ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
                  "Encounter Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height:16),
          SummaryHeaderWidget(
            context: context,
            appointmentType: appointmentData['data']['type'] == 1
                ? 'Office'
                : appointmentData['data']['type'] == 2
                    ? 'Telemedicine'
                    : 'Onsite',
            provider: appointmentData['data']['doctor']['title'] +
                ' ' +
                appointmentData['data']['doctor']['fullName'] +
                ', ' +
                professionalTitle +
                license,
            patient: appointmentData['data']['user']['fullName'],
            mrn: mrn,
            encounterDate: encounterDate,
          ),
          SizedBox(height: 20),
          // SummaryProviderWidget(
          //     context: context,
          //     name: appointmentData['data']['doctor']['title'] +
          //         ' ' +
          //         appointmentData['data']['doctor']['fullName'],
          //     exp: (appointmentData['doctorData'][0]["practicingSince"] != null
          //             ? (DateTime.now()
          //                         .difference(DateTime.parse(
          //                             appointmentData['doctorData'][0]
          //                                 ["practicingSince"]))
          //                         .inDays /
          //                     366)
          //                 .toStringAsFixed(1)
          //             : "---") +
          //         " Years of Experience",
          //     img: appointmentData['data']['doctor']['avatar']),
          // SizedBox(height: 20),
          // SummaryPatientWidget(
          //     context: context,
          //     name: appointmentData['data']['user']['fullName'],
          //     exp: age + sex + mrn,
          //     img: appointmentData['data']['user']['avatar']),
          // SizedBox(height: 20),
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
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .anthropometricMeasurements !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .anthropometricMeasurements
                          .weight !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .anthropometricMeasurements
                          .weight
                          .current !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .anthropometricMeasurements
                          .weight
                          .current !=
                      ''
              ? AnthopometricCompletedSummaryWidget(
                  anthropometricMeasurements:
                      AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .anthropometricMeasurements)
              : SizedBox(),
          AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .integumentary !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .integumentary
                          .summary
                          .length >
                      0
              ? IntegumentryCompletedWidget(
                  integumentry: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .integumentary,
                )
              : SizedBox(),
          AppointmentData.fromJson(appointmentData).doctorFeedback[0].gait !=
                      null &&
                  AppointmentData.fromJson(appointmentData)
                          .doctorFeedback[0]
                          .gait
                          .summary
                          .length >
                      0
              ? GaitCompletedWidget(
                  gait: AppointmentData.fromJson(appointmentData)
                      .doctorFeedback[0]
                      .gait)
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
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .preferredLabs
                                  .name !=
                              ''
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
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .labDetails
                                  .labTestInstructions !=
                              ''
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
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .preferredImagingCenters
                                  .name !=
                              ''
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
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .imagingDetails
                                  .imagingInstructions !=
                              ''
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
                  prescriptionWidget(),
                  AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .prescriptionDetails !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .prescriptionDetails
                                  .preferredPharmacy !=
                              null &&
                          AppointmentData.fromJson(appointmentData)
                                  .doctorFeedback[0]
                                  .prescriptionDetails
                                  .preferredPharmacy
                                  .name !=
                              null
                      ? preffredPharmacyWidget(
                          AppointmentData.fromJson(appointmentData)
                              .doctorFeedback[0]
                              .prescriptionDetails
                              .preferredPharmacy)
                      : SizedBox(),
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
                      ? followUpWidget(appointmentData['followUpAppointment'])
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

  Column preffredPharmacyWidget(Pharmacy preferredPhramacy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Preferred Pharmacy',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          preferredPhramacy.name,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
        Text(
          preferredPhramacy.address != null
              ? ((preferredPhramacy.address.address ?? '') +
                  ', ' +
                  (preferredPhramacy.address.city ?? '') +
                  ', ' +
                  (preferredPhramacy.address.state ?? '') +
                  ', ' +
                  (preferredPhramacy.address.zipCode ?? ''))
              : '---',
          style: AppTextStyle.regularStyle(fontSize: 14),
        )
      ],
    );
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
                    style: AppTextStyle.semiBoldStyle(fontSize: 14),
                  ),
                  Text(
                    'Reason: ${intervention[index].reason}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                    'Time: ${intervention[index].time}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                    'Patient response: ${intervention[index].patientResponse}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                    'Body Part: ${intervention[index].bodyPart}',
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${educationCategories[index].category}, ${educationCategories[index].name}',
                    style: AppTextStyle.semiBoldStyle(fontSize: 14),
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                          text: 'Reference: ',
                          style: AppTextStyle.semiBoldStyle(fontSize: 14),
                        ),
                        TextSpan(
                            text: educationCategories[index].reference,
                            style: AppTextStyle.mediumStyle(fontSize: 13)),
                      ])),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                          text: 'Comments: ',
                          style: AppTextStyle.semiBoldStyle(fontSize: 14),
                        ),
                        TextSpan(
                            text: educationCategories[index].comments,
                            style: AppTextStyle.mediumStyle(fontSize: 13)),
                      ])),
                ],
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
          'Preferred Lab',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          preferredLabs.name,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
        Text(
          preferredLabs.address != null
              ? ((preferredLabs.address.address ?? '') +
                  ', ' +
                  (preferredLabs.address.city ?? '') +
                  ', ' +
                  (preferredLabs.address.state ?? '') +
                  ', ' +
                  (preferredLabs.address.zipCode ?? ''))
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
          'Preferred Imaging',
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          preferredImaging.name,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
        Text(
          preferredImaging.address != null
              ? ((preferredImaging.address.address ??
                  '' +
                      ', ' +
                      (preferredImaging.address.city ?? '') +
                      ', ' +
                      (preferredImaging.address.state ?? '') +
                      ', ' +
                      (preferredImaging.address.zipCode ?? '')))
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
              if (exercise[index].images != null) {
                for (dynamic img in exercise[index].images) {
                  imageVideo.add({'type': '1', 'url': img});
                }
              }
              if (exercise[index].video != null) {
                imageVideo.add({'type': '2', 'url': exercise[index].video});
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022 ${exercise[index].name}',
                    style: AppTextStyle.semiBoldStyle(fontSize: 14),
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
                  Text('Instruction: ${exercise[index].instructions}')
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  prescriptionWidget() {
    return FutureBuilder(
      future: medicationChangesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          appointmentMedication = snapshot.data.data;

          return appointmentMedication.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Prescription',
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
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: appointmentMedication.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\u2022  ${appointmentMedication[index].name} ${medChangeString[appointmentMedication[index].status]}',
                                style: AppTextStyle.mediumStyle(fontSize: 14),
                              ),
                              appointmentMedication[index].status == 2
                                  ? SizedBox()
                                  : Text(
                                      '${appointmentMedication[index].dose} , ${appointmentMedication[index].frequency}',
                                      style: AppTextStyle.regularStyle(
                                          fontSize: 14),
                                    ),
                              Text(
                                'Because ${appointmentMedication[index].providerReason}',
                                style: AppTextStyle.regularStyle(fontSize: 14),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : SizedBox();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CustomLoader(),
        );
      },
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
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 2),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: followUp.length,
          itemBuilder: (context, index) {
            return followUp[index]['isReferred']
                ? Text(
                    '\u2022 ${followUpType[followUp[index]['type']]} with ${followUp[index]['doctorName']} at: ${DateFormat("MM/dd/yyyy, h:mm a").format(DateFormat("yyyy-MM-ddThh:mm:ss.000Z").parse(followUp[index]['date'], true).toLocal())}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  )
                : Text(
                    '\u2022 ${followUpType[followUp[index]['type']]} with ${followUp[index]['doctorName']} at: ${DateFormat("MM/dd/yyyy, h:mm a").format(DateFormat("yyyy-MM-ddThh:mm:ss.000Z").parse(followUp[index]['date'], true).toLocal())}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  );
          },
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
