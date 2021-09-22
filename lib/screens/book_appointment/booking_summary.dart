import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart'
    as MedImg;
import 'package:hutano/screens/book_appointment/diagnosis/model/res_diagnostic_test_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/preference_constants.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/problem_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Bookingsummary extends StatefulWidget {
  Bookingsummary({Key key}) : super(key: key);

  @override
  _BookingsummaryState createState() => _BookingsummaryState();
}

class _BookingsummaryState extends State<Bookingsummary> {
  Map<String, String> timeSpanConfig = {
    "1": "Hours",
    "2": "Days",
    "3": "Weeks",
    "4": "Months",
    "5": "Years"
  };

  InheritedContainerState _container;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "Summary",
        color: AppColors.snow,
        // isLoading: _isLoading,
        isAddAppBar: true,
        addBottomArrows: true,
        addHeader: true,
        onForwardTap: () {
          Navigator.of(context).pushNamed(
            _container.projectsResponse[ArgumentConstant.serviceTypeKey]
                        .toString() ==
                    '3'
                ? Routes.onsiteAddresses
                : Routes.paymentMethodScreen,
            arguments: true,
          );
        },
        isSkipLater: false,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: profileWidget(),
      ),
    );
  }

  Widget profileWidget() {
    return ListView(padding: EdgeInsets.all(20), children: [
      problemswidget(
        Provider.of<HealthConditionProvider>(context, listen: false)
            .allHealthIssuesData,
      ),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .vitalsData
                  .date !=
              null
          ? vitalsDetailWidgets(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .vitalsData)
          : SizedBox(),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalHistoryData
                  .length >
              0
          ? medicalHistoryWidget(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalHistoryData)
          : SizedBox(),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicationModelData
                  .length >
              0
          ? prescriptionWidget(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicationModelData)
          : SizedBox(),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalImagesData
                  .length >
              0
          ? medicalImagesWidget(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalImagesData)
          : SizedBox(),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalDocumentsData
                  .length >
              0
          ? medicalDocumentWidget(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalDocumentsData)
          : SizedBox(),
      Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalDiagnosticsTestsModelData
                  .length >
              0
          ? diagnosticTestWidget(
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .medicalDiagnosticsTestsModelData)
          : SizedBox(),
    ]);
  }

  ListView medicalHistoryWidget(List<BookedMedicalHistory> medicalHistories) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          "Medical history",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 14,
        ),
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
              itemCount: medicalHistories.length,
              itemBuilder: (context, index) {
                return Text(
                  '${index + 1}. ${medicalHistories[index].name} from ${medicalHistories[index].month}, ${medicalHistories[index].year}',
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                );
              },
            )),
      ],
    );
  }

  ListView vitalsDetailWidgets(Vitals vitals) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          "Vitals",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 14,
        ),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${DateFormat("MMM dd,yyyy").format(DateTime.parse(vitals.date))}, ${vitals.time}',
                    style: AppTextStyle.semiBoldStyle(fontSize: 14)),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: vitals.bloodPressureSbp != null ||
                                vitals.bloodPressureDbp != null
                            ? 'Blood Pressure '
                            : '',
                        style: AppTextStyle.regularStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.bloodPressureSbp != null ||
                                vitals.bloodPressureDbp != null
                            ? '${vitals.bloodPressureSbp}/${vitals.bloodPressureDbp}; \t'
                            : '',
                        style: AppTextStyle.mediumStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.oxygenSaturation != null
                            ? 'Oxygen Saturation '
                            : '',
                        style: AppTextStyle.regularStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.oxygenSaturation != null
                            ? '${vitals.oxygenSaturation}%; \t'
                            : '',
                        style: AppTextStyle.mediumStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.heartRate != null ? 'Heart Rate ' : '',
                        style: AppTextStyle.regularStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.heartRate != null
                            ? '${vitals.heartRate} b/m; \t'
                            : '',
                        style: AppTextStyle.mediumStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.temperature != null ? 'Temperature ' : '',
                        style: AppTextStyle.regularStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: vitals.temperature != null
                            ? vitals.temperature.toString().contains('.0')
                                ? '${vitals.temperature.toInt()} \u2109'
                                : '${vitals.temperature} \u2109'
                            : '',
                        style: AppTextStyle.mediumStyle(fontSize: 14),
                      ),

                      // TextSpan(
                      //   text:
                      //       'Blood Pressure ${widget.args['vitals']['bloodPressureSbp']}/${widget.args['vitals']['bloodPressureDbp']};\t Oxygen Saturation ${widget.args['vitals']['oxygenSaturation']}%;\t Heart Rate ${widget.args['vitals']['heartRate']} BPM',
                      // ),
                    ],
                  ),
                ),
              ],
            ))
      ],
    );
  }

  ListView problemswidget(List<Problems> problems) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          "Problems",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20),
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: problems.length,
          itemBuilder: (context, index) {
            return ProblemWidget(
                dob: getString(AppPreference.dobKey),
                gender: getInt(PreferenceKey.gender),
                appointmentProblem: problems[index].toJson(),
                problemTimeSpanMap: timeSpanConfig);
          },
        ),
      ],
    );
  }

  ListView medicalImagesWidget(List<MedImg.MedicalImages> medicalImages) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          "Medical images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: medicalImages.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: medicalImages[index]
                                    .images
                                    .toLowerCase()
                                    .endsWith("pdf")
                                ? "ic_pdf".imageIcon()
                                : Image.network(
                                    ApiBaseHelper.imageUrl +
                                        medicalImages[index].images,
                                    height: 80.0,
                                    width: 80.0,
                                    fit: BoxFit.cover,
                                  )),
                      )).onClick(
                    onTap: medicalImages[index]
                            .images
                            .toLowerCase()
                            .endsWith("pdf")
                        ? () async {
                            var url = ApiBaseHelper.imageUrl +
                                medicalImages[index].images;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        : () {
                            Navigator.of(context).pushNamed(
                              Routes.providerImageScreen,
                              arguments: ApiBaseHelper.imageUrl +
                                  medicalImages[index].images,
                            );
                          },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('${(index + 1)}. ' +
                        medicalImages[index].name +
                        ' taken on ' +
                        medicalImages[index].date),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  ListView medicalDocumentWidget(
      List<MedImg.MedicalDocuments> medicalDocuments) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          "Medical Documents",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: medicalDocuments.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: medicalDocuments[index]
                                    .medicalDocuments
                                    .toLowerCase()
                                    .endsWith("pdf")
                                ? "ic_pdf".imageIcon()
                                : Image.network(
                                    ApiBaseHelper.imageUrl +
                                        medicalDocuments[index]
                                            .medicalDocuments,
                                    height: 80.0,
                                    width: 80.0,
                                    fit: BoxFit.cover,
                                  )),
                      )).onClick(
                    onTap: medicalDocuments[index]
                            .medicalDocuments
                            .toLowerCase()
                            .endsWith("pdf")
                        ? () async {
                            var url = ApiBaseHelper.imageUrl +
                                medicalDocuments[index].medicalDocuments;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        : () {
                            Navigator.of(context).pushNamed(
                              Routes.providerImageScreen,
                              arguments: ApiBaseHelper.imageUrl +
                                  medicalDocuments[index].medicalDocuments,
                            );
                          },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('${(index + 1)}. ' +
                        medicalDocuments[index].name +
                        ' ' +
                        medicalDocuments[index].type +
                        ' taken on ' +
                        medicalDocuments[index].date),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  ListView diagnosticTestWidget(List<DiagnosticTest> dignosticTest) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Text(
          "Diagnostic tests",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dignosticTest.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: dignosticTest[index]
                                    .image
                                    .toLowerCase()
                                    .endsWith("pdf")
                                ? "ic_pdf".imageIcon()
                                : Image.network(
                                    ApiBaseHelper.imageUrl +
                                        dignosticTest[index].image,
                                    height: 80.0,
                                    width: 80.0,
                                    fit: BoxFit.cover,
                                  )),
                      )).onClick(
                    onTap:
                        dignosticTest[index].image.toLowerCase().endsWith("pdf")
                            ? () async {
                                var url = ApiBaseHelper.imageUrl +
                                    dignosticTest[index].image;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                            : () {
                                Navigator.of(context).pushNamed(
                                  Routes.providerImageScreen,
                                  arguments: ApiBaseHelper.imageUrl +
                                      dignosticTest[index].image,
                                );
                              },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('${(index + 1)}. ' +
                        dignosticTest[index].name +
                        ' ' +
                        dignosticTest[index].type +
                        ' taken on ' +
                        dignosticTest[index].date),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column prescriptionWidget(List<Medications> medications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Medications",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20),
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
            itemCount: medications.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${medications[index].name}',
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                    '${medications[index].dose} , ${medications[index].frequency}',
                    style: AppTextStyle.regularStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // void setLoading(bool value) {
  //   setState(() {
  //     isLoading = value;
  //   });
  // }
}
