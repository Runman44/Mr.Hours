
import 'package:eventtracker/bloc/RegistrationBloc.dart';
import 'package:eventtracker/ui/widgets/Bullet.dart';
import 'package:eventtracker/ui/widgets/Loading.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sup/sup.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/DashboardBloc.dart';

class DashboardOverview extends StatefulWidget {
  @override
  _DashboardOverviewState createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview>
    with TickerProviderStateMixin {
  DateTime _firstDay = DateTime.now();
  DateTime _lastDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _selectedDay = day;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {

    first = DateTime(first.year, first.month, first.day);
    last = DateTime(last.year, last.month, last.day);

    BlocProvider.of<DashboardBloc>(context)
        .add(HoursUpdated(DateTimeRange(start: first, end : last)));
    setState(() {
      _firstDay = first;
      _lastDay = last;
      _calendarController.setCalendarFormat(format);
    });
  }

  void _onCalenderCreated(
      DateTime first, DateTime last, CalendarFormat format) {

    first = DateTime(first.year, first.month, first.day);
    last = DateTime(last.year, last.month, last.day);

    _firstDay = first;
    _lastDay = last;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
          BlocProvider.of<DashboardBloc>(context)
              .add(HoursUpdated(DateTimeRange(start: _firstDay, end : _lastDay)));
        }),
      ],
      child:
          BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
        if (state is DashboardLoadInProgress) {
          return Loading();
        }
        if (state is DashboardLoadSuccess) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(state.bookings),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList(state.bookings)),
            ],
          );
        }
        if (state is DashboardLoadFailed) {
          return QuickSup.error(
            title: "Er is iets mis gegaan",
            retryText: "Probeer opnieuw",
          );
        }
        return Container();
      }),
    );
  }

  Widget _buildTableCalendar(Map<DateTime, List<DashboardItem>> bookings) {
    return TableCalendar(
      locale: 'nl_Nl',
      calendarController: _calendarController,
      events: bookings,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      initialSelectedDay: _selectedDay,
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).accentColor,
        todayColor: Colors.teal[200],
        markersColor: Colors.teal[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        formatButtonShowsNext: false,
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalenderCreated,
    );
  }

  Widget _buildEventList(Map<DateTime, List<DashboardItem>> bookings) {
    var booking = _getListForSelectedDate(bookings);
    if (booking.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Card(
              elevation: 0,
              child: ListTile(
                  leading: Bullet(
                    mini: true,
                    color: booking[index].clientColor,
                  ),
                  title: Text(booking[index].clientName),
                  subtitle: Text(booking[index].projectName),
                  trailing: Text(booking[index].minutesToUIString() + " uur"),
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationEditor(
                                    clientId: booking[index].clientId,
                                    clientName: booking[index].clientName,
                                    projectId: booking[index].projectId,
                                    projectName: booking[index].projectName,
                                    registration: booking[index].registrationId,
                                    startDate: booking[index].startDateTime,
                                    endDate: booking[index].endDateTime,
                                  )),
                        )
                      }),
            ),
          );
        },
        itemCount: booking.length,
      );
    } else {
      return Center(
          child: QuickSup.empty(subtitle: "Nog geen registraties op deze dag"));
    }
  }

  List<DashboardItem> _getListForSelectedDate(
      Map<DateTime, List<DashboardItem>> bookings) {
    var formatStartDate = _selectedDay;
    var format = DateFormat("yyyy-MM-dd");
    var formatDate = format.format(formatStartDate);
    var booking = bookings[format.parse(formatDate)];
    return booking ?? [];
  }
}
