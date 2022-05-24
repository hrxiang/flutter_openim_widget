import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimingView extends StatefulWidget {
  const TimingView({
    Key? key,
    required this.sec,
    this.onFinished,
  }) : super(key: key);
  final int sec;
  final Function()? onFinished;

  @override
  _TimingViewState createState() => _TimingViewState();
}

class _TimingViewState extends State<TimingView> {
  Timer? _timer;
  late int _sec;

  @override
  void initState() {
    _sec = widget.sec;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      --_sec;
      if (_sec <= 0) {
        _timer?.cancel();
        _timer = null;
        widget.onFinished?.call();
      }
      setState(() {
        if (_sec <= 0) {
          _sec = 0;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h, right: 4.w),
      child: Text(
        '$_sec s',
        style: TextStyle(
          fontSize: 10.sp,
          color: Color(0xFF006AFF),
        ),
      ),
    );
  }
}
