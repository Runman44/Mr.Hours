import 'package:eventtracker/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
            ),
          ),
        ),
      ),
      body: Container(
              alignment: Alignment.center,
              child: RaisedButton(
                color: Colors.deepPurple,
                textColor: Colors.white,
                child: Text("Login"),
                onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
            ),
    );
  }
}
