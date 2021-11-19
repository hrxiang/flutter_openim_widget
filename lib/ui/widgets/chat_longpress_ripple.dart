import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LongPressRippleAnimation extends StatefulWidget {
  const LongPressRippleAnimation({
    Key? key,
    required this.child,
    required this.radius,
    this.onStart,
    this.onStop,
  }) : super(key: key);
  final Widget child;
  final double radius;
  final Function()? onStart;
  final Function()? onStop;

  @override
  _LongPressRippleAnimationState createState() =>
      _LongPressRippleAnimationState();
}

class _LongPressRippleAnimationState extends State<LongPressRippleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  late AnimationController _inflateController;
  late Animation<double> _inflateAnimation;
  bool _a1 = true;
  bool _start = false;

  @override
  void dispose() {
    _rippleController.dispose();
    _inflateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _rippleController.forward();
        }
      });
    _rippleAnimation = Tween(begin: 1.0, end: .8).animate(_rippleController)
      ..addListener(() {
        setState(() {});
      });

    _inflateController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _a1 = false;
          });
          _inflateController.stop();
          _rippleController.forward();
        } else if (status == AnimationStatus.dismissed) {
        } else if (status == AnimationStatus.reverse) {
          setState(() {
            _start = false;
          });
        } else if (status == AnimationStatus.forward) {
          setState(() {
            _start = true;
          });
        }
      });
    _inflateAnimation = Tween(begin: 0.0, end: 1.0).animate(_inflateController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  double get size2 =>
      _rippleAnimation.value * (widget.radius) + widget.radius * 2;

  double get size1 =>
      _inflateAnimation.value * (widget.radius) + widget.radius * 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (detail) {
        _inflateController.forward();
        widget.onStart?.call();
      },
      onLongPressEnd: (detail) {
        setState(() {
          _a1 = true;
        });
        _rippleController.stop();
        _inflateController.reverse();
        widget.onStop?.call();
      },
      child: Container(
        alignment: Alignment.center,
        width: _a1 ? size1 : size2,
        height: _a1 ? size1 : size2,
        decoration: (!_start && _inflateAnimation.isDismissed)
            ? null
            : BoxDecoration(
                color: const Color(0xFF1d6bed).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}

/// You can use whatever widget as a [child], when you don't need to provide any
/// [child], just provide an empty Container().
/// [delay] is using a [Timer] for delaying the animation, it's zero by default.
/// You can set [repeat] to true for making a paulsing effect.
/*
class LongPressRippleAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double minRadius;
  final Color color;

  final int ripplesCount;
  final Duration duration;
  final bool repeat;

  LongPressRippleAnimation({
    Key? key,
    required this.child,
    this.color = Colors.black,
    this.delay = const Duration(milliseconds: 0),
    this.repeat = false,
    this.minRadius = 60,
    this.ripplesCount = 5,
    this.duration = const Duration(milliseconds: 0),
  }) : super(key: key);

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<LongPressRippleAnimation>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // repeating or just forwarding the animation once.
    // Timer(widget.delay, () {
    //   widget.repeat ? _controller?.repeat() : _controller?.forward();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      onLongPressStart: (detail) {
        _controller?.repeat();
      },
      onLongPressEnd: (detail) {
        _controller?.reset();
      },
      child: CustomPaint(
        painter: CirclePainter(
          _controller,
          color: widget.color,
          minRadius: widget.minRadius,
          wavesCount: widget.ripplesCount,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

// Creating a Circular painter for clipping the rects and creating circle shapes
class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    this.minRadius,
    this.wavesCount,
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final double? minRadius;
  final wavesCount;
  final Animation<double>? _animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 0; wave <= wavesCount; wave++) {
      circle(canvas, rect, minRadius, wave, _animation!.value, wavesCount);
    }
  }

  // animating the opacity according to min radius and waves count.
  void circle(Canvas canvas, Rect rect, double? minRadius, int wave,
      double value, int? length) {
    Color _color;
    double r;
    if (wave != 0) {
      double opacity = (1 - ((wave - 1) / length!) - value).clamp(0.0, 1.0);
      _color = color.withOpacity(opacity);

      r = minRadius! * (1 + ((wave * value))) * value;
      final Paint paint = Paint()..color = _color;
      canvas.drawCircle(rect.center, r, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
*/
