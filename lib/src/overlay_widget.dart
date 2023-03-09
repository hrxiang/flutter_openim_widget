import 'dart:async';

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
        onDismiss: dismiss,
        child: child,
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
      duration: const Duration(milliseconds: 200),
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
        behavior: HitTestBehavior.translucent,
        child: Material(
          color: Colors.black.withAlpha(150),
          child: Center(child: widget.child),
        ),
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.onDismiss?.call();
        // _controller.forward();
      }
    });
    _childAnimation = Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
        .animate(_controller)
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
      behavior: HitTestBehavior.translucent,
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
    );
  }
}

class PopupMenuButtonContainer extends StatefulWidget {
  const PopupMenuButtonContainer({
    Key? key,
    required this.child,
    this.alignment = Alignment.topRight,
    this.onStartCloseAnimation,
    this.onCloseAnimationEnd,
  }) : super(key: key);

  final Widget child;
  final Alignment alignment;
  final Future<bool> Function()? onStartCloseAnimation;
  final Function()? onCloseAnimationEnd;

  @override
  State<PopupMenuButtonContainer> createState() =>
      _PopupMenuButtonContainerState();
}

class _PopupMenuButtonContainerState extends State<PopupMenuButtonContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.onCloseAnimationEnd?.call();
        // _controller.forward();
      }
    });
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
    /*..addListener(() {
            setState(() {});
          })*/
    ;
    _controller.forward();

    widget.onStartCloseAnimation?.call().then((value) {
      if (value) _controller.reverse();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

class OverlayPopupMenuButton extends StatefulWidget {
  const OverlayPopupMenuButton({
    Key? key,
    required this.child,
    required this.builder,
  }) : super(key: key);
  final Widget child;
  final WidgetBuilder builder;

  @override
  State<OverlayPopupMenuButton> createState() => _OverlayPopupMenuButtonState();
}

class _OverlayPopupMenuButtonState extends State<OverlayPopupMenuButton> {
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;
  final _globalKey = GlobalKey();

  dismiss() async {
    if (!_isVisible) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }

  Rect getWidgetGlobalRect() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final bottomRight =
    renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
    return Rect.fromPoints(topLeft, bottomRight);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (_isVisible) return;
        _isVisible = true;
        final rect = getWidgetGlobalRect();
        final completer = Completer<bool>();
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final contentWidth = _globalKey.currentContext?.size?.width ?? 0;
        final contentHeight = _globalKey.currentContext?.size?.height ?? 0;
        final popupMenuButtonWidth = rect.right - rect.left;
        final popupMenuButtonHeight = rect.bottom - rect.top;
        double? left = rect.left + popupMenuButtonWidth / 2 - contentWidth / 2;
        double? top = rect.top + popupMenuButtonHeight;
        double? right = rect.right - popupMenuButtonWidth / 2;
        double? bottom;
        bool reverse = false;
        if (left < 0) {
          left = 0;
        } else if (left + contentWidth > screenWidth) {
          left = screenWidth - contentWidth;
        }

        if (top + contentHeight > screenHeight) {
          top = null;
          bottom = screenHeight - rect.top;
          reverse = true;
        }

        _overlayState = Overlay.of(context);
        _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => GestureDetector(
            onTap: () {
              completer.complete(true);
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned(
                  // right: right,
                  top: top,
                  bottom: bottom,
                  left: left,
                  child: PopupMenuButtonContainer(
                    onCloseAnimationEnd: dismiss,
                    onStartCloseAnimation: () => completer.future,
                    alignment:
                    reverse ? Alignment.bottomCenter : Alignment.topCenter,
                    child: widget.builder(context),
                  ),
                )
              ],
            ),
          ),
        );
        _overlayState?.insert(_overlayEntry!);
      },
      child: Stack(
        children: [
          Offstage(
            child: SizedBox(key: _globalKey, child: widget.builder(context)),
          ),
          widget.child,
        ],
      ),
    );
  }
}
