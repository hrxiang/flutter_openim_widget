import 'package:flutter/material.dart';

class OverlayWidget {
  static final OverlayWidget singleton = OverlayWidget._();

  factory OverlayWidget() => singleton;

  OverlayWidget._();

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  void showDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    if (_isVisible) return;
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => DialogContainer(
        onDismiss: dismiss,
        child: child,
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);
  }

  void showBottomSheet({
    required BuildContext context,
    required Widget child,
  }) {
    if (_isVisible) return;
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => BottomSheetContainer(
        child: child,
        onDismiss: dismiss,
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);
  }

  dismiss() async {
    if (!_isVisible) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}

class DialogContainer extends StatefulWidget {
  const DialogContainer({
    Key? key,
    required this.child,
    this.onDismiss,
  }) : super(key: key);

  final Widget child;

  final Function()? onDismiss;

  @override
  State<DialogContainer> createState() => _DialogContainerState();
}

class _DialogContainerState extends State<DialogContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          widget.onDismiss?.call();
          // _controller.forward();
        }
      });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
        /*..addListener(() {
            setState(() {});
          })*/
        ;
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () {
          _controller.reverse();
        },
        child: Material(
          color: Colors.black.withAlpha(150),
          child: Center(child: widget.child),
        ),
        behavior: HitTestBehavior.translucent,
      ),
    );
  }
}

class BottomSheetContainer extends StatefulWidget {
  const BottomSheetContainer({
    Key? key,
    required this.child,
    this.onDismiss,
  }) : super(key: key);

  final Widget child;
  final Function()? onDismiss;

  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _childAnimation;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          widget.onDismiss?.call();
          // _controller.forward();
        }
      });
    _childAnimation =
            Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(_controller)
        /*..addListener(() {
            setState(() {});
          })*/
        ;
    _bgAnimation = Tween(begin: 0.5, end: 1.0).animate(_controller)
        /*..addListener(() {
            setState(() {});
          })*/
        ;

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reverse();
      },
      child: FadeTransition(
        opacity: _bgAnimation,
        child: Material(
          color: Colors.black.withAlpha(150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideTransition(position: _childAnimation, child: widget.child),
            ],
          ),
        ),
      ),
      behavior: HitTestBehavior.translucent,
    );
  }
}
