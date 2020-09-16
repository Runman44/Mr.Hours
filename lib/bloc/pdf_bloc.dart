
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PdfEvent {
  const PdfEvent();
}

class CreatePdf extends PdfEvent {
  final DateTimeRange datePeriod;

  const CreatePdf(this.datePeriod);
}

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final DatabaseService data;


  PdfBloc(this.data) : super(PdfInit());

  @override
  Stream<PdfState> mapEventToState(PdfEvent event) async* {
    if (event is CreatePdf) {
      yield PdfLoadInProgress();

      try {
        List<DashboardItem> items = await data.listRegistrations(event.datePeriod);
        yield PdfLoadSuccess(items, event.datePeriod);
      } catch (exception) {
        yield PdfLoadFailed();
      }
    }
  }
}

abstract class PdfState {
  const PdfState();
}

class PdfInit extends PdfState {}

class PdfLoadInProgress extends PdfState {}

class PdfLoadFailed extends PdfState {}

class PdfLoadSuccess extends PdfState {
  final DateTimeRange datePeriod;
  final List<DashboardItem> bookings;

  PdfLoadSuccess(this.bookings, this.datePeriod);
}