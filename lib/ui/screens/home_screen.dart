import 'package:eventtracker/ui/screens/registration_screen.dart';
import 'package:eventtracker/ui/screens/settings_overview.dart';
import 'package:flutter/material.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

import 'client_create_screen.dart';
import 'client_screen.dart';
import 'dashboard_screen.dart';
import 'export_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashboardOverview(),
    ClientPage(),
    ExportPage(),
    SettingsPage()
  ];
  final List<String> _appBarTitle = [
    "Overzicht",
    "Opdrachtgevers",
    "Rapportage",
    "Instellingen"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle[_currentIndex]),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
            ),
          ),
        ),
      ),
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            circleColors: [
              Colors.teal[100],
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Theme.of(context).accentColor),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
            activeTitleStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            actionButtonDetails: SCActionButtonDetails(
                color: Theme.of(context).accentColor,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,

                ),
                elevation: 2),
            elevation: 2.0,
            items: [
              // Suggested count : 4
              SCBottomBarItem(
                  icon: Icons.view_list,
                  title: "Overzicht",
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.person,
                  title: "Clienten",
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.pie_chart,
                  title: "Rapportage",
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.settings,
                  title: "Instellingen",
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  }),
            ],
            circleItems: [
              SCItem(
                  icon: Icon(Icons.person_add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientCreator(),
                      ),
                    );
                  }),
              SCItem(
                  icon: Icon(Icons.access_time),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationEditor(
                            clientId: null,
                            clientName: null,
                            projectId: null,
                            projectName: "",
                            registration: null,
                            startDate: DateTime.now(),
                            endDate: DateTime.now(),
                          )),
                    );
                  }),
            ],
            bnbHeight: 80 // Suggested Height 80
        ),
        // Put your Screen Content in Child
        child: _children[_currentIndex],
      ),
    );
  }
}
