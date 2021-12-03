import 'package:flutter/material.dart';

class UnreadCountView extends StatelessWidget {
  final Color color;
  final double size;
  final Stream<int>? steam;
  final int? count;

  const UnreadCountView({
    Key? key,
    this.steam,
    this.color = const Color(0xFFF44038),
    this.size = 13,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (null == steam) {
      return _buildChild(count: count ?? 0);
    }
    return StreamBuilder(
      stream: steam,
      builder: (_, AsyncSnapshot<int> hot) => Visibility(
        visible: (hot.data ?? 0) > 0,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${(hot.data ?? 0) > 99 ? '...' : hot.data}',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild({required int count}) => Visibility(
        visible: count > 0,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${count > 99 ? '...' : count}',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      );
}
