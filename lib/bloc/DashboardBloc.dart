import 'dart:async';
import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventtracker/service/database.dart';
import 'package:intl/intl.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class HoursUpdated extends DashboardEvent {
  final DateTimeRange datePeriod;

  const HoursUpdated(this.datePeriod);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DatabaseService data;
  final ClientBloc clientBloc;
  StreamSubscription dashboardSubscription;

  DashboardBloc(this.data, this.clientBloc) : super(DashboardInit()) {
    dashboardSubscription = clientBloc.listen((statez) {
      if (statez is ClientsLoadSuccess) {
        add(HoursUpdated((this.state as DashboardLoadSuccess).datePeriod));
      }
    });
  }

  @override
  Future<void> close() {
    dashboardSubscription.cancel();
    return super.close();
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is HoursUpdated) {
      yield DashboardLoadInProgress();

      try {
        List<DashboardItem> items =
        await data.listRegistrations(event.datePeriod);

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

        yield DashboardLoadSuccess(result, event.datePeriod);
      } catch (exception) {
        yield DashboardLoadFailed();
      }
    }
  }
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardInit extends DashboardState {}

class DashboardLoadInProgress extends DashboardState {}

class DashboardLoadFailed extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final DateTimeRange datePeriod;
  final Map<DateTime, List<DashboardItem>> bookings;

  DashboardLoadSuccess(this.bookings, this.datePeriod);
}
