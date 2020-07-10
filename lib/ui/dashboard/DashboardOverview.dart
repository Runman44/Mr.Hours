import 'dart:async';

import 'package:eventtracker/bloc/RegistrationBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/components/Loading.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/database.dart';
import 'package:eventtracker/ui/registration/RegistrationEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    BlocProvider.of<DashboardBloc>(context).add(HoursUpdated(DatePeriod(first, last)));
    setState(() {
      _firstDay = first;
      _lastDay = last;
      _calendarController.setCalendarFormat(format);
    });
  }

  void _onCalenderCreated(DateTime first, DateTime last, CalendarFormat format) {
    _firstDay = first;
    _lastDay = last;
  }

  @override
  Widget build(BuildContext context) {
    var dashboardBloc = BlocProvider.of<DashboardBloc>(context);

    return BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          dashboardBloc.add(HoursUpdated(DatePeriod(_firstDay, _lastDay)));
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
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
        todayColor: Colors.amber[200],
        markersColor: Colors.red[700],
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
    var booking = _getList(bookings);
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
                      color: event.clientColor,
                    ),
                    title: Text(event.clientName),
                    subtitle: Text(event.projectName),
                    trailing: Text(event.minutesToUIString() + " uur"),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationEditor(
                                      clientId: event.clientId,
                                      clientName: event.clientName,
                                      projectId: event.projectId,
                                      projectName: event.projectName,
                                      registration: event.registrationId,
                                      startDate: event.startDateTime,
                                      endDate: event.endDateTime,
                                    )),
                          )
                        }),
              ))
          .toList(),
    );
  }

  List<DashboardItem> _getList(Map<DateTime, List<DashboardItem>> bookings) {
    var formatStartDate = _selectedDay;
    var format = DateFormat("yyyy-MM-dd");
    var formatDate = format.format(formatStartDate);
    var booking = bookings[format.parse(formatDate)];
    return booking ?? [];
  }
}

abstract class DashboardEvent {
  const DashboardEvent();
}

class HoursUpdated extends DashboardEvent {
  final DatePeriod datePeriod;

  const HoursUpdated(this.datePeriod);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DatabaseService data;
  final RegistrationBloc registrationBloc;

  DashboardBloc(this.data, this.registrationBloc);

  @override
  DashboardState get initialState => DashboardInit();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is HoursUpdated) {
      yield DashboardLoadInProgress();

      List<DashboardItem> items = await data.listRegistrations(event.datePeriod);

      var result = <DateTime, List<DashboardItem>>{};
      for (var item in items) {
        var formatStartDate = item.startDateTime;
        var format = DateFormat("yyyy-MM-dd");
        var formatDate = format.format(formatStartDate);
        var list = result.putIfAbsent(format.parse(formatDate), () => []);
        var bookingToAdd = item;
        if (list.isEmpty || !identical(list.last, bookingToAdd)) {
          list.add(bookingToAdd);
        }
      }

      yield DashboardLoadSuccess(result);
    }
  }
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardInit extends DashboardState {}

class DashboardLoadInProgress extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final Map<DateTime, List<DashboardItem>> bookings;

  DashboardLoadSuccess(this.bookings);
}
