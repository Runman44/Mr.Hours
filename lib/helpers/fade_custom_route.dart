import 'package:flutter/material.dart';

class FadeCustomRoute<T> extends MaterialPageRoute<T> {
  FadeCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings,);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child,);
  }
}
