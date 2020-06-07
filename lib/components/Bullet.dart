import 'package:flutter/material.dart';

class Bullet extends StatelessWidget {
  static const double SIZE = 22;
  final Color color;
  final bool mini;

  const Bullet({Key key, this.color, this.mini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool m = mini ?? false;
    double scale = m ? 0.75 : 1.0;
    return Container(
      width: SIZE * scale,
      height: SIZE * scale,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        //borderRadius: BorderRadius.circular(SIZE * 0.5 * scale),
        border: color == null
            ? Border.all(
          color: Theme.of(context).disabledColor,
          width: 3.0,
        )
            : null,
        shape: BoxShape.circle,
      ),
    );
  }
}