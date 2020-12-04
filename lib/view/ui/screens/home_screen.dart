import 'package:easy_localization/easy_localization.dart';
import 'package:eventtracker/view/ui/screens/registration_screen.dart';
import 'package:eventtracker/view/ui/screens/settings_overview.dart';
import 'package:flutter/material.dart';

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
    "overview_title".tr(),
    "customer_title".tr(),
    "rapport_title".tr(),
    "settings_title".tr()
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("overview_title".tr()),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("customer_title".tr()),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text("rapport_title".tr()),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("settings_title".tr()),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      floatingActionButton: Visibility(
        visible: _currentIndex == 0 || _currentIndex == 1,
        child: FloatingActionButton(
          onPressed: () {
            if (_currentIndex == 0) {
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
                          tasks: "",
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientCreator(),
                ),
              );
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
