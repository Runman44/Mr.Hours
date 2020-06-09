import 'dart:async';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/client/ClientEditor.dart';
import 'package:eventtracker/ui/client/ClientOverview.dart';
import 'package:eventtracker/ui/dashboard/DashboardOverview.dart';
import 'package:eventtracker/ui/login/login.dart';
import 'package:eventtracker/ui/registration/RegistrationEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bloc/ClientBloc.dart';
import 'bloc/UserBloc.dart';
import 'ui/export/ExportOverview.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                getWelcomeMessage(userBloc.state),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
//                  image: DecorationImage(
//                      fit: BoxFit.fill,
//                      image: AssetImage('assets/images/cover.jpg')
//                  )
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Opdrachtgevers'),
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientPage()),
                );
                // Then close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Rapportage'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExportPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Instellingen'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Overzicht"),
      ),
      body: DashboardOverview(),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 26.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.access_time, color: Colors.deepPurple,),
              backgroundColor: Colors.white,
              label: 'Uren',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
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
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add, color: Colors.deepPurple,),
            backgroundColor: Colors.white,
            label: 'Opdrachtgever',
            labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientEditor(client: null),
                  ),
                );
              }
          ),
        ],
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
