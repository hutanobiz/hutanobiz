import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';

class HeartRateChart extends StatefulWidget {
  HeartRateChart({Key key}) : super(key: key);

  @override
  State<HeartRateChart> createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> {
  ApiBaseHelper api = new ApiBaseHelper();
  FocusNode _dateFocusNode = FocusNode();
  FocusNode _timeFocusNode = FocusNode();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController dbpController = TextEditingController();
  String _selectedDate = "";
  String _selectedTime = "";
  bool isLoading = false;
  List<Color> gradientColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];
  Future<dynamic> chartFuture;
  List<dynamic> responseData;
  double touchedValue;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    touchedValue = 1;
    _dateController.text = DateFormat("MM/dd/yyyy").format(DateTime.now());
    _selectedDate = DateTime.now().toString();
    _timeController.text = DateFormat("hh:mm a").format(DateTime.now());
    _weightController.addListener(() {
      setState(() {});
    });
    getChartData();
  }

  void getChartData() {
    chartFuture = api.getGraphData("Bearer ${getString(PreferenceKey.tokens)}",
        'heartRate', DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "",
        padding: EdgeInsets.only(bottom: 0),
        isAddBack: true,
        isAddAppBar: true,
        addBottomArrows: false,
        isLoading: isLoading,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('images/heart_lung.png',
                        height: 50, width: 50)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Heart rate',
                    style: AppTextStyle.semiBoldStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.white),
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Image.asset(
                          'images/trackReschedule.png',
                          height: 18,
                        ),
                        SizedBox(width: 12),
                        GestureDetector(
                          child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: TextFormField(
                                controller: _dateController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xb5000000),
                                  fontSize: fontSize14,
                                  fontWeight: fontWeightSemiBold,
                                ),
                                focusNode: _dateFocusNode,
                                enabled: false,
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: 'Date',
                                  hintStyle: TextStyle(
                                      fontSize: fontSize13,
                                      fontWeight: fontWeightMedium),
                                  contentPadding: EdgeInsets.all(spacing8),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.grey[100]),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.grey[100]),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.grey[100]),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: AppColors.windsor),
                                  ),
                                ),
                              )),
                          onTap: () {
                            if (Platform.isAndroid) {
                              openMaterialDatePicker(
                                  context, _dateController, _dateFocusNode,
                                  isOnlyDate: true,
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime.now(),
                                  onDateChanged: (value) {
                                if (value != null) {
                                  var date =
                                      DateFormat("MM/dd/yyyy").format(value);
                                  _dateController.text = date;
                                  setState(() {
                                    _selectedDate = value.toString();
                                  });
                                }
                              });
                            } else {
                              openCupertinoDatePicker(
                                  context, _dateController, _dateFocusNode,
                                  firstDate: DateTime.now(),
                                  isOnlyDate: true,
                                  initialDate: DateTime.now(),
                                  onDateChanged: (value) {
                                if (value != null) {
                                  var date =
                                      DateFormat("MM/dd/yyyy").format(value);
                                  _dateController.text = date;
                                  setState(() {
                                    _selectedDate = value.toString();
                                  });
                                }
                              });
                            }
                          },
                        ),
                        Spacer(),
                        Image.asset(
                          'images/watch.png',
                          height: 18,
                        ),
                        SizedBox(width: 12),
                        Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white),
                            child: TextFormField(
                              controller: _timeController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xb5000000),
                                fontSize: fontSize14,
                                fontWeight: fontWeightSemiBold,
                              ),
                              focusNode: _timeFocusNode,
                              enabled: false,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Time',
                                hintStyle: TextStyle(
                                    fontSize: fontSize13,
                                    fontWeight: fontWeightMedium),
                                contentPadding: EdgeInsets.all(spacing8),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.windsor),
                                ),
                              ),
                            )),
                      ],
                    ),
                    onTap: () {
                      showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.goldenTainoi,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child,
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          DateTime tempDate = DateFormat("hh:mm").parse(
                              value.hour.toString() +
                                  ":" +
                                  value.minute.toString());
                          var dateFormat = DateFormat("hh:mm a");
                          _timeController.text = dateFormat.format(tempDate);
                          _selectedTime = dateFormat.format(tempDate);
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Heart rate',
                        style: TextStyle(
                          color: colorBlack2,
                          fontSize: fontSize14,
                          fontWeight: fontWeightSemiBold,
                        ),
                      ),
                      SizedBox(width: spacing15),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            color: Color(0xb5000000),
                            fontSize: fontSize14,
                            fontWeight: fontWeightSemiBold,
                          ),
                          enabled: true,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '',
                            hintStyle: TextStyle(
                                fontSize: fontSize13,
                                fontWeight: fontWeightMedium),
                            contentPadding: EdgeInsets.all(spacing8),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey[100]),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey[100]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey[100]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: AppColors.windsor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FancyButton(
                      title: 'Save',
                      onPressed: _weightController.text == ''
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              api.postGraphData(
                                  "Bearer ${getString(PreferenceKey.tokens)}", {
                                "date": _dateController.text,
                                "time": _timeController.text,
                                "heartRate": _weightController.text
                              }).then((value) {
                                responseData.insert(0, {
                                  "date": _selectedDate,
                                  "time": _timeController.text,
                                  "heartRate": _weightController.text
                                });

                                setState(() {});
                              });
                            })
                ],
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<dynamic>(
              future: chartFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text("No Requests."),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: CustomLoader(),
                    );
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      if (isFirst) {
                        responseData = snapshot.data;
                        isFirst = false;
                      }

                      responseData.sort((a, b) {
                        var aa = DateTime.utc(
                          DateTime.parse(a['date']).year,
                          DateTime.parse(a['date']).month,
                          DateTime.parse(a['date']).day,
                          int.parse(DateFormat("HH:mm")
                              .format(DateFormat.jm().parse(a['time']))
                              .split(':')[0]),
                          int.parse(DateFormat("HH:mm")
                              .format(DateFormat.jm().parse(a['time']))
                              .split(':')[1]),
                        ).toLocal();

                        var bb = DateTime.utc(
                          DateTime.parse(b['date']).year,
                          DateTime.parse(b['date']).month,
                          DateTime.parse(b['date']).day,
                          int.parse(DateFormat("HH:mm")
                              .format(DateFormat.jm().parse(b['time']))
                              .split(':')[0]),
                          int.parse(DateFormat("HH:mm")
                              .format(DateFormat.jm().parse(b['time']))
                              .split(':')[1]),
                        ).toLocal();

                        return bb.compareTo(aa);
                      });
                    }
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          color: Colors.grey[100]),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: LineChart(
                              sampleData2,
                            ),
                          ),
                          Center(
                              child: Text(
                                  touchedValue == 1
                                      ? '---'
                                      : dateFormatter(
                                          'EEEE, MMM dd, yyyy hh:mm a',
                                          responseData[-touchedValue.toInt()]),
                                  style: AppTextStyle.semiBoldStyle(
                                      fontSize: 12))),
                          Center(
                              child: Text(
                                  touchedValue == 1
                                      ? '---'
                                      : responseData[-touchedValue.toInt()]
                                              ['heartRate']
                                          .toString(),
                                  style: AppTextStyle.semiBoldStyle(
                                      fontSize: 30))),
                          Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Low'),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.goldenTainoi)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Normal'),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.goldenTainoi)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('High'),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.goldenTainoi,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.goldenTainoi)),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  // } else if (snapshot.hasError) {
                  //   return Text('No Requests.');
                  // }
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        backgroundColor: Colors.grey[100],
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        extraLinesData: ExtraLinesData(verticalLines: [
          VerticalLine(
              x: touchedValue,
              strokeWidth: 30,
              color: Colors.white.withOpacity(.5))
        ]),
        minX: -6,
        maxX: 0,
        maxY: 400,
        minY: 0,
      );

  LineTouchData get lineTouchData2 {
    return LineTouchData(
      getTouchLineEnd: (data, index) => double.infinity,
      touchSpotThreshold: double.infinity,
      handleBuiltInTouches: true,
      touchCallback: (FlTouchEvent event, LineTouchResponse lineTouch) {
        if (!event.isInterestedForInteractions ||
            lineTouch == null ||
            lineTouch.lineBarSpots == null) {
          // setState(() {
          //   touchedValue = -1;
          // });
          return;
        }
        final value = lineTouch.lineBarSpots[0].x;

        if (value == 1 || value == -7) {
          // setState(() {
          //   touchedValue = -1;
          // });
          return;
        }

        setState(() {
          touchedValue = value;
        });
      },

      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.white, strokeWidth: 30),
            FlDotData(
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                        radius: 12,
                        color: spot.y > 120
                            ? AppColors.goldenTainoi
                            : spot.y < 80
                                ? Colors.grey
                                : Colors.white,
                        strokeColor: AppColors.goldenTainoi)),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueAccent,
      ),
      // touchTooltipData: LineTouchTooltipData(
      //   tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      // ),
    );
  }

  FlTitlesData get titlesData2 => FlTitlesData(
      bottomTitles: bottomTitles,
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,reservedSize: 40)));
  //    leftTitles(
  //     getTitles: (value) {
  //       switch (value.toInt()) {
  //         case 0:
  //           return '0';
  //         case 50:
  //           return '50';
  //         case 100:
  //           return '100';
  //         case 150:
  //           return '150';
  //         case 200:
  //           return '200';
  //         case 250:
  //           return '250';
  //         case 300:
  //           return '300';
  //         case 350:
  //           return '350';
  //         case 400:
  //           return '400';
  //         case 450:
  //           return '450';
  //       }
  //       return '';
  //     },
  //   ),
  // );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_3,
      ];

  // SideTitles leftTitles({@required GetTitleFunction getTitles}) => SideTitles(
  //       getTitles: getTitles,
  //       showTitles: true,
  //       margin: 8,
  //       interval: 1,
  //       reservedSize: 40,
  //       getTextStyles: (context, value) => const TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.normal,
  //         fontSize: 14,
  //       ),
  //     );

  AxisTitles get bottomTitles {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      // reservedSize: 22,
      // margin: 10,
      interval: 1,
      getTitlesWidget: (value, mt) {
        final isTouched = value == touchedValue;
        return Text(
            responseData.length > (-value.toInt())
                ? dateFormatter('M/d', responseData[-value.toInt()])
                : '',
            style: isTouched
                ? TextStyle(color: Colors.black, fontSize: 14.0)
                : TextStyle(color: Colors.black, fontSize: 12.0));
      },
      // getTextStyles: (context, value) {
      //   final isTouched = value == touchedValue;
      //   return isTouched
      //       ? TextStyle(color: Colors.black, fontSize: 14.0)
      //       : TextStyle(color: Colors.black, fontSize: 12.0);
      // },
      // getTitles: (value) {
      //   return responseData.length > (-value.toInt())
      //       ? dateFormatter('M/d', responseData[-value.toInt()])
      //       : '';
      // },
    ));
  }

  String dateFormatter(format, data) {
    return data == null
        ? ''
        : DateFormat(format)
            .format(DateTime.utc(
                    DateTime.parse(data['date']).year,
                    DateTime.parse(data['date']).month,
                    DateTime.parse(data['date']).day,
                    int.parse(DateFormat("HH:mm")
                        .format(DateFormat.jm().parse(data['time']))
                        .split(':')[0]),
                    int.parse(DateFormat("HH:mm")
                        .format(DateFormat.jm().parse(data['time']))
                        .split(':')[1]))
                .toLocal())
            .toString();
  }

  FlGridData get gridData =>
      FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          // bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          bottom: BorderSide(color: Colors.transparent),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_3 {
    List<FlSpot> spots = [];

    for (int i = 0;
        i < (responseData.length > 7 ? 7 : responseData.length);
        i++) {
      spots.add(FlSpot(-i.toDouble(),
          double.parse(responseData[i]['heartRate'].toString())));
    }
    return LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.goldenTainoi,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(
                radius: 5,
                color: p0.y > 120
                    ? AppColors.goldenTainoi
                    : p0.y < 80
                        ? Colors.grey
                        : Colors.white,
                strokeColor: AppColors.goldenTainoi,
              );
            }),
        belowBarData: BarAreaData(show: false),
        spots: spots);
  }
}
