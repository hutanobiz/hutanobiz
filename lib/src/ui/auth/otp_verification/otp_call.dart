import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';

const int kDuration = 60000;

class OtpCall extends StatefulWidget {
  final VoidCallback onCall;

  const OtpCall({Key key, this.onCall}) : super(key: key);
  @override
  _OtpCallState createState() => _OtpCallState();
}

class _OtpCallState extends State<OtpCall> with TickerProviderStateMixin {
  bool animation = false;
  AnimationController _controller;
  Duration duration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: kDuration));
    _controller.addStatusListener((status) {
      if (AnimationStatus.completed == status) {
        setState(() {
          animation = false;
        });
        _controller.reset();
      }
    });
  }

  _onTap() {
    setState(() {
      animation = true;
    });
    _controller.forward();
    widget.onCall();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: 150,
          child: animation
              ? LinearPercentIndicator(
                  lineHeight: 52,
                  backgroundColor: colorGrey33,
                  linearStrokeCap: LinearStrokeCap.butt,
                  animationDuration: kDuration,
                  animation: animation,
                  padding: EdgeInsets.all(0),
                  alignment: MainAxisAlignment.center,
                  width: 150,
                  percent: 1,
                  center: Countdown(
                      label: Localization.of(context).msgGetCode,
                      animation: StepTween(
                        begin: 1000,
                        end: 0,
                      ).animate(_controller)),
                  progressColor: colorGrey48,
                )
              : GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    width: 150,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: colorPurple100.withOpacity(0.04)),
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Localization.of(context).msgGetCode,
                          style: TextStyle(
                              color: colorPurple100, fontSize: fontSize13),
                        )),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation, this.label})
      : super(key: key, listenable: animation);
  final Animation<int> animation;
  final String label;

  @override
  Widget build(BuildContext context) {
    var clockTimer = Duration(milliseconds: 60 * animation.value);
    var timerText =
        """${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}""";

    return Text(
      "$label \n ${timerText}s",
      style: TextStyle(
        fontSize: fontSize13,
        color: colorDarkGrey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
