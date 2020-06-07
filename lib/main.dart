import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:eventtracker/ui/client/ClientOverview.dart';
import 'package:eventtracker/ui/login/login.dart';
import 'package:eventtracker/ui/registration/RegistrationEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bloc/ClientBloc.dart';
import 'bloc/ProjectBloc.dart';
import 'bloc/UserBloc.dart';
import 'ui/export/ExportOverview.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(),
          ),
          BlocProvider<ProjectBloc>(
            create: (_) => ProjectBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
          )
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
    BlocProvider.of<UserBloc>(context).add(UserEvent.geteverything);
    BlocProvider.of<ClientBloc>(context).add(LoadClient());
    BlocProvider.of<ProjectBloc>(context).add(LoadProject());
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
  List _selectedEvents;
  DateTime _selectedDay;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _selectedEvents = [];
    _selectedDay = DateTime.now();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _calendarController.setCalendarFormat(format);
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);
    ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);

    return BlocProvider<DashboardBloc>(
      create: (_) => DashboardBloc(clientBloc, projectBloc, userBloc),
      // provide the local bloc instance
      child: Scaffold(
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
          title: Text("Time"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(clientBloc.state),
            const SizedBox(height: 8.0),
            _buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            //TODO if no clients - go to clientOverview screen.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationEditor(client: null, project: null, registration: null, pickedDate: _selectedDay,)),
            );
          },
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(ClientState state) {
    Map<DateTime, List<Booking>> clientsByRegistrationDate(
        Iterable<Client> clients) {
      var result = <DateTime, List<Booking>>{};
      for (var client in clients) {
        for (var project in client.projects) {
          for (var registration in project.registrations) {
            var list = result.putIfAbsent(registration.date, () => []);
            var bookingToAdd = Booking(client, project, registration);
            if (list.isEmpty || !identical(list.last, bookingToAdd)) {
              list.add(bookingToAdd);
            }
          }
        }
      }
      return result;
    }

    return TableCalendar(
      locale: 'nl_Nl',
      calendarController: _calendarController,
      events: clientsByRegistrationDate(state.clients),
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepPurple[400],
        todayColor: Colors.deepPurple[200],
        markersColor: Colors.green[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildButtons() {
    var bookings = _selectedEvents.cast<Booking>();
    var totalMinutesWorked = 0;
    for (Booking booking in bookings) {
      totalMinutesWorked =
          totalMinutesWorked + booking.registration.minutesWorked;
    }

    String calculateHours(int minutes) {
      return Duration(minutes: minutes).inHours.toString();
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("${calculateHours(totalMinutesWorked)} uur deze dag"),
      ],
    );
  }

  Widget _buildEventList() {
    var booking = _selectedEvents.cast<Booking>();
    return ListView(
      children: booking
          .map((event) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    leading: Bullet(color: event.client.color,),
                    title: Text(event.client.name),
                    subtitle: Text(event.project.name),
                    trailing: Text(event.minutesToUIString() + " uur"),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationEditor(client :event.client, project:event.project, registration:event.registration, pickedDate: event.registration.date,)),
                          )
                        }),
              ))
          .toList(),
    );
  }

  String getWelcomeMessage(UserState state) {
    var text = state.user?.firstName;
    if (text != null) {
      return "Welkom $text";
    } else {
      return "Welkom";
    }
  }
}

class DashboardBloc extends Bloc<UserEvent, DashboardState> {
  final ClientBloc clientBloc;
  final ProjectBloc projectBloc;
  final UserBloc userBloc;

  DashboardBloc(this.clientBloc, this.projectBloc, this.userBloc);

  @override
  DashboardState get initialState {
    return DashboardState(userBloc.state.user, clientBloc.state.clients,
        projectBloc.state.projects);
  }

  @override
  Stream<DashboardState> mapEventToState(UserEvent event) async* {}
}

class DashboardState {
  final User user;
  final List<Client> clients;
  final List<Project> projects;

  DashboardState(this.user, this.clients, this.projects) : assert(user != null);
}
