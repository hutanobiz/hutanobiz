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
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';

class TemperatureChart extends StatefulWidget {
  TemperatureChart({Key key}) : super(key: key);

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
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

  @override
  void initState() {
    super.initState();
    getChartData();
  }

  void getChartData() {
    chartFuture = api.getGraphData("Bearer ${getString(PreferenceKey.tokens)}",
        'temperature', DateTime.now().toString());
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
                    child:
                        Image.asset('images/vital.png', height: 50, width: 50)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Temperature',
                    style: AppTextStyle.semiBoldStyle(fontSize: 20),
                  ),
                ),
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                      )),
                  onTap: () {
                    if (Platform.isAndroid) {
                      openMaterialDatePicker(
                          context, _dateController, _dateFocusNode,
                          isOnlyDate: true,
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now(), onDateChanged: (value) {
                        if (value != null) {
                          var date = DateFormat("MM/dd/yyyy").format(value);
                          _dateController.text = date;
                          setState(() {
                            _selectedDate =
                                DateFormat("MM/dd/yyyy").format(value);
                          });
                        }
                      });
                    } else {
                      openCupertinoDatePicker(
                          context, _dateController, _dateFocusNode,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(), onDateChanged: (value) {
                        if (value != null) {
                          var date = DateFormat("MM/dd/yyyy").format(value);
                          _dateController.text = date;
                          setState(() {
                            _selectedDate =
                                DateFormat("MM/dd/yyyy").format(value);
                          });
                        }
                      });
                    }
                  },
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
                        'Temperature',
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
                            hintText: '\u2109',
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
                ],
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<dynamic>(
              future: chartFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
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
                  case ConnectionState.none:
                    // if (snapshot.hasData) {
                    // responseData = snapshot.data;
                    responseData = [
                      {
                        "user": "621c95675d38b50ee1fb2431",
                        "doctor": "621c6ec45d38b50ee1fb2392",
                        "appointment": "621f09bd7fb1590f0b20d58b",
                        "bloodPressureDbp": "200",
                        "bloodPressureSbp": "100",
                        "bloodGlucose": 80,
                        "heartRate": "60",
                        "temperature": "90",
                        "height": "5.9",
                        "weight": "123",
                        "bmi": "18.2",
                        "date": "2022-03-02T00:00:00.000Z",
                        "time": "11:36 AM",
                        "addedBy": 1,
                        "_id": "621f09bf7fb1590f0b20d592",
                        "createdAt": "2022-03-02T06:07:59.377Z",
                        "updatedAt": "2022-03-02T06:07:59.377Z",
                        "__v": 0
                      },
                      {
                        "user": "621c95675d38b50ee1fb2431",
                        "doctor": "621c6ec45d38b50ee1fb2392",
                        "appointment": "621f0b797fb1590f0b20d593",
                        "bloodPressureDbp": "234",
                        "bloodPressureSbp": "123",
                        "bloodGlucose": 36,
                        "heartRate": "123",
                        "temperature": "253",
                        "height": "5.6",
                        "weight": "152",
                        "bmi": "24.5",
                        "date": "2022-03-02T00:00:00.000Z",
                        "time": "11:44 AM",
                        "addedBy": 1,
                        "_id": "621f0b7a7fb1590f0b20d599",
                        "createdAt": "2022-03-02T06:15:22.929Z",
                        "updatedAt": "2022-03-02T06:15:22.929Z",
                        "__v": 0
                      }
                    ];
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
                              child: Text('Date',
                                  style: AppTextStyle.semiBoldStyle(
                                      fontSize: 12))),
                          Center(
                              child: Text('130',
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
        minX: 0,
        maxX: 6,
        maxY: 400,
        minY: 0,
      );

  LineTouchData get lineTouchData2 {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
    );
  }

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: bottomTitles,
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 50:
                return '50';
              case 100:
                return '100';
              case 150:
                return '150';
              case 200:
                return '200';
              case 250:
                return '250';
              case 300:
                return '300';
              case 350:
                return '350';
              case 400:
                return '400';
              case 450:
                return '450';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_3,
      ];

  SideTitles leftTitles({@required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles {
    return SideTitles(
      showTitles: true,
      // reservedSize: 22,
      margin: 10,
      interval: 1,
      getTextStyles: (context, value) =>
          const TextStyle(color: Colors.black, fontSize: 12.0),
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return responseData[0]['date'].toString().substring(5, 10);
          case 1:
            return responseData[1]['date'].toString().substring(5, 10);
          case 2:
            return responseData[2]['date'].toString().substring(5, 10);
          case 3:
            return responseData[3]['date'].toString().substring(5, 10);
          case 4:
            return responseData[4]['date'].toString().substring(5, 10);
          case 5:
            return responseData[5]['date'].toString().substring(5, 10);
          // case 6:
          //   return responseData[6]['date'].toString().substring(5, 10);
          // case 7:
          //   return responseData[7]['date'].toString().substring(4, 10);
          // case 8:
          //   return responseData[8]['date'].toString().substring(4, 10);
        }
        return '';
      },
    );
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

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [Color(0x444af699)],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1),
          FlSpot(5, 1),
          FlSpot(7, 1),
          FlSpot(10, 1),
          FlSpot(12, 1),
          FlSpot(13, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_2 {
    List<FlSpot> spots = [];

    for (int i = 0; i < responseData.length; i++) {
      spots.add(FlSpot(
          i.toDouble(), double.parse(responseData[i]['bloodPressureDbp'])));
    }
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      colors: const [AppColors.female],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
          show: true,
          getDotPainter: (p0, p1, p2, p3) {
            return FlDotCirclePainter(
              radius: 5,
              color: p0.y > 80
                  ? AppColors.goldenTainoi
                  : p0.y < 60
                      ? Colors.grey
                      : Colors.white,
              strokeColor: AppColors.female,
            );
          }),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  LineChartBarData get lineChartBarData2_3 {
    List<FlSpot> spots = [];

    for (int i = 0; i < responseData.length; i++) {
      spots.add(FlSpot(i.toDouble(),
          double.parse(responseData[i]['temperature'].toString())));
    }
    return LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [AppColors.goldenTainoi],
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
