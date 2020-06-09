import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/registration/RegistrationEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../main.dart';

class DashboardOverview extends StatefulWidget {
  @override
  _DashboardOverviewState createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> with TickerProviderStateMixin {
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
    ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
      if (state is DashboardLoadInProgress) {
        return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator());
      } else if (state is DashboardLoadSuccess) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(clientBloc.state),
            const SizedBox(height: 8.0),
            _buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        );
      } else {
        return Container();
      }
    });
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
        formatButtonShowsNext: false,
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
            leading: Bullet(
              color: event.client.color,
            ),
            title: Text(event.client.name),
            subtitle: Text(event.project.name),
            trailing: Text(event.minutesToUIString() + " uur"),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationEditor(
                      client: event.client,
                      project: event.project,
                      registration: event.registration,
                      pickedDate: event.registration.date,
                    )),
              )
            }),
      ))
          .toList(),
    );
  }
}
