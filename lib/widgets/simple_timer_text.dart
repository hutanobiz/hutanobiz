import 'package:flutter/material.dart';

/// Create a Circular Countdown Timer
class SimpleCountDownTimer extends StatefulWidget {
  /// Key for Countdown Timer
  final Key key;


  /// Text Style for Countdown Text
  final TextStyle textStyle;

  final String text;
    final int duration;
    final bool isReverse;
     final Function onComplete;
                                        

  /// Controller to control (i.e Pause, Resume, Restart) the Countdown
  final SimpleCountDownController controller;

  SimpleCountDownTimer(
      {
      @required this.duration,
      @required this.text,
      this.isReverse =true,
      this.onComplete,
      this.textStyle,
      this.key,
      this.controller})
      : 
        assert(duration != null),
        super(key: key);

  @override
  SimpleCountDownTimerState createState() => SimpleCountDownTimerState();
}

class SimpleCountDownTimerState extends State<SimpleCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _countDownAnimation;
  AnimationController _animationcontroller;

  String get time {
    if (widget.isReverse) {
      return '0:00';
    } else {
      Duration duration = _controller.duration * _controller.value;
      return _getTime(duration);
    }
  }




  void _setController() {
    widget.controller?._state = this;
    // widget.controller?._isReverse = widget.isReverse;
  }

  String _getTime(Duration duration) {
    // For HH:mm:ss format
    if (duration.inHours != 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For mm:ss format
    else {
      return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  void _onComplete() {
    if (widget.onComplete != null) widget.onComplete();
  }

  @override
  void initState() {
    super.initState();
      _animationcontroller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          _onComplete();
          break;
        case AnimationStatus.completed:

          /// [AnimationController]'s value is manually set to [1.0] that's why [AnimationStatus.completed] is invoked here this animation is [isReverse]
          /// Only call the [_onComplete] block when the animation is not reversed.
          if (!widget.isReverse) _onComplete();
          break;
        default:
        // Do nothing
      }
    });
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
                                             widget.text +time,
                                              style: widget.textStyle ??
                                                  TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                            );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}

/// Controller for controlling Countdown Widget (i.e Pause, Resume, Restart)
class SimpleCountDownController {
  SimpleCountDownTimerState _state;
  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**
  String getTime() {
    return _state
        ._getTime(_state._controller.duration * _state._controller?.value);
  }
}