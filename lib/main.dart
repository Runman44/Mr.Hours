import 'dart:async';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/themes.dart';
import 'package:eventtracker/ui/client/ClientEditor.dart';
import 'package:eventtracker/ui/client/ClientOverview.dart';
import 'package:eventtracker/ui/dashboard/DashboardOverview.dart';
import 'package:eventtracker/ui/export/ExportOverview.dart';
import 'package:eventtracker/ui/login/login.dart';
import 'package:eventtracker/ui/registration/RegistrationEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

import 'bloc/ClientBloc.dart';
import 'bloc/UserBloc.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              clientBloc: BlocProvider.of<ClientBloc>(context),
            ),
          ),
        ],
        child: TimeApp(),
      )));
}

class TimeApp extends StatefulWidget {
  @override
  _TimeAppState createState() => _TimeAppState();
}

class _TimeAppState extends State<TimeApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadUser());
    BlocProvider.of<ClientBloc>(context).add(LoadClient());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tellow-Time',
      theme: lightTheme,
      home: LoginPage(),
    );
  }
}

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
    ExportPage()
  ];
  final List<String> _appBarTitle = [
    "Overzicht",
    "Opdrachtgevers",
    "Rapportage",
    "Instellingen"
  ];

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

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
            circleColors: [Colors.white, Theme.of(context).accentColor, Theme.of(context).primaryColor],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Theme.of(context).accentColor),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
            activeTitleStyle: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
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
              SCItem(icon: Icon(Icons.person_add), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientEditor(client: null),
                  ),
                );
              }),
              SCItem(icon: Icon(Icons.access_time), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationEditor(
                            client: null,
                            project: null,
                            registration: null,
                            pickedDate: DateTime.now(),
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

  String getWelcomeMessage(UserState state) {
    if (state is UserLoadSuccess) {
      var text = state.user?.firstName;
      return "Welkom $text";
    } else {
      return "Welkom";
    }
  }
}

abstract class DashboardEvent {
  const DashboardEvent();
}

class HoursUpdated extends DashboardEvent {
  final List<Client> clients;

  const HoursUpdated(this.clients);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClientBloc clientBloc;
  StreamSubscription dataSubscription;

  DashboardBloc({@required this.clientBloc}) {
    dataSubscription = clientBloc.listen((state) {
      if (clientBloc.state.clients.isNotEmpty) {
        add(HoursUpdated(clientBloc.state.clients));
      }
    });
  }

  @override
  DashboardState get initialState {
    return clientBloc.state.clients.isNotEmpty
        ? DashboardLoadSuccess(
            clientBloc.state.clients,
          )
        : DashboardLoadInProgress();
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (clientBloc.state.clients.isNotEmpty) {
      yield DashboardLoadSuccess(
        clientBloc.state.clients,
      );
    }
  }

  @override
  Future<void> close() {
    dataSubscription.cancel();
    return super.close();
  }
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardLoadInProgress extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final List<Client> clients;

  DashboardLoadSuccess(this.clients);
}
