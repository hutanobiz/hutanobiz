import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dimens.dart';

class ScreenProgress extends StatefulWidget {

  final double points;

  ScreenProgress({@required this.points});

  @override
  _ScreenProgressState createState() => _ScreenProgressState();
}

class _ScreenProgressState extends State<ScreenProgress> {
  AnimationController controller;



  @override
  void initState() {
    super.initState();


    }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:Alignment.center,
      child: Center(
        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            line1(),
            tick1(),
            line2(),
            tick2(),
            line3(),
            tick3(),
            line4(),
            tick4(),
            line5(),
            tick5(),
            line6(),
          ],
        ),
      ),
    );


  }

  Widget tick(bool isChecked,String text){
    return Padding(
      padding: EdgeInsets.only(top: spacing10),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: isChecked ? Icon(Icons.call_end,color: colorYellow100,size:20) :
              Icon(Icons.radio_button_unchecked,color: colorGray44,size: 20,)
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: colorBlack50, fontSize: fontSize10),
            ),
          ],
        ),
      ),
    );
  }


  Widget tick1() {
    return this.widget.points>50?tick(true,"50"):tick(false,"50");
  }

  Widget tick2() {
    return this.widget.points>100?tick(true,"100"):tick(false,"100");
  }

  Widget tick3() {
    return this.widget.points>150?tick(true,"150"):tick(false,"150");
  }

  Widget tick4() {
    return this.widget.points>200?tick(true,"200"):tick(false,"200");
  }

  Widget tick5() {
    return this.widget.points>250?tick(true,"250"):tick(false,"250");
  }


  Widget line1() {
    return this.widget.points > 50? linarProgress(10,20):linarProgress(0,20);
  }

  Widget line2() {
    Widget returnLine;
    if(widget.points>50 && widget.points< 100)
    {
      print(widget.points);
      print((widget.points-50)/50);
      returnLine = linarProgress((widget.points-50)/50,50);
    }else if(widget.points >100) {
      print("Points 1");
      returnLine =linarProgress(10,50);
    }else{
      print("Points 2");
      returnLine =linarProgress(0,50);
    }
    return returnLine;
  }

  Widget line3() {
    Widget returnLine;
    if(widget.points>100 && widget.points< 150)
    {
      returnLine =linarProgress((widget.points-100)/100,50);
    }else if(widget.points >150) {
      returnLine =linarProgress(10,50);
    }else{
      returnLine =linarProgress(0,50);
    }
    return returnLine;
  }

  Widget line4() {
    Widget returnLine;
    if(widget.points>150 && widget.points< 200)
    {
      returnLine =linarProgress((widget.points-150)/150,50);
    }else if(widget.points > 200) {
      returnLine =linarProgress(10,50);
    }else{
      returnLine =linarProgress(0,50);
    }
    return returnLine;
  }

  Widget line5() {
    Widget returnLine;
    if(widget.points>200 && widget.points< 250)
    {
      returnLine =linarProgress((widget.points-200)/200,50);
    }else if(widget.points > 250) {
      returnLine =linarProgress(10,50);
    }else{
      returnLine =linarProgress(0,50);
    }
    return returnLine;
  }

  Widget line6() {
    Widget returnLine;
    if(widget.points > 250)
    {
      returnLine =linarProgress(10,50);
    }else{
      returnLine =linarProgress(0,50);
    }
    return returnLine;
  }


  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line() {
    return Center(
      child: Container(
        color: colorYellow100,
        height: 2.0,
        width: 50.0,
      ),
    );
  }

  Widget linarProgress(double progress,double width)
  {
    return Container(
      margin: EdgeInsets.only(bottom:10 ),
      child: SizedBox(
        height: 2.0,
        width: width,
        child:
         LinearProgressIndicator(
          minHeight: 2.0,
          backgroundColor: colorGrey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
          value: progress,
        ),
      ),
    );
  }


  Widget linarProgressIndicator(double progress,double width)
  {
    return Container(

      child: LinearPercentIndicator(
       width: width,
       lineHeight: 2.0,
       percent: progress,
       widgetIndicator:  Align(
         alignment: Alignment.topLeft,
           child: Image.asset(FileConstants.icProgressCount, width: 20)),
       progressColor: colorYellow100,
        backgroundColor:colorGrey,
        animation: true,
        ),
    );
  }




  Widget lineGrey() {
    return Center(
      child: Container(
        color: colorGrey,
        height: 2.0,
        width: 50.0,
      ),
    );
  }
}