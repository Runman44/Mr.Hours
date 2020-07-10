import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/login/LoginOverview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../HomeOverview.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user != null) {
      return MyHomePage();
    } else {
      return LoginPage();
    }
  }
}
