import 'package:flutter/material.dart';

/// Create a Circular Countdown Timer
class SimpleCountDownTimer extends StatefulWidget {
  /// Key for Countdown Timer
  final Key key;

  /// Text Style for Countdown Text
  final TextStyle textStyle;

  final String text;
  final int duration;
  final bool isReverse, isReverseAnimation;
  final Function onComplete;

  /// Controller to control (i.e Pause, Resume, Restart) the Countdown
  final SimpleCountDownController controller;

  SimpleCountDownTimer(
      {@required this.duration,
      @required this.text,
      this.isReverse = true,
      this.isReverseAnimation = false,
      this.onComplete,
      this.textStyle,
      this.key,
      this.controller})
      : assert(duration != null),
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
    if (widget.isReverse && _controller.isDismissed) {
      return '0:00';
    } else {
      Duration duration = _controller.duration * _controller.value;
      return _getTime(duration);
    }
  }

  void _setAnimation() {
    if (widget.isReverse) {
      _controller.reverse(from: 1);
    } else {
      _controller.forward();
    }
  }

  void _setAnimationDirection() {
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller);
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
    _animationcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();

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
    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Text(
            widget.text + time,
            style: widget.textStyle ??
                TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
          );
        });
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
  bool _isReverse;

  /// This Method Pauses the Countdown Timer
  void pause() {
    _state._controller?.stop(canceled: false);
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (_isReverse) {
      _state._controller
          ?.reverse(from: _state._controller.value = _state._controller.value);
    } else {
      _state._controller?.forward(from: _state._controller.value);
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer
  void restart({int duration}) {
    _state._controller.duration =
        Duration(seconds: duration ?? _state._controller.duration.inSeconds);
    if (_isReverse) {
      _state._controller?.reverse(from: 1);
    } else {
      _state._controller?.forward(from: 0);
    }
  }

  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**
  String getTime() {
    return _state
        ._getTime(_state._controller.duration * _state._controller?.value);
  }
}