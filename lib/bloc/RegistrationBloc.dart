import 'dart:ui';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ClientBloc.dart';

abstract class RegistrationsEvent {
  const RegistrationsEvent();
}

class LoadProject extends RegistrationsEvent {}

class EditRegistration extends RegistrationsEvent {
  final RegistrationEntry entry;
  const EditRegistration(this.entry);
}

class EditProject extends RegistrationsEvent {
  final String name;
  final String rate;
  final Color billable;

  const EditProject(this.name, this.rate, this.billable);
}

class RegistrationBloc extends Bloc<RegistrationsEvent, RegistrationState> {
  final ClientBloc clientBloc;

  RegistrationBloc(this.clientBloc);

  @override
  RegistrationState get initialState => RegistrationState.initial();

  @override
  Stream<RegistrationState> mapEventToState(RegistrationsEvent event) async* {
    if (event is LoadProject) {
//      var projects = await getAllProjects();
//      var uiProjects = projects.map((e) => Project.fromDto(e)).toList();
//      yield ProjectState(uiProjects);
    } else if (event is EditRegistration) {
      yield RegistrationState(event.entry);
    } else if (event is EditProject) {
//      yield ProjectState(uiClients);
    }
  }
}

class RegistrationState {
  final RegistrationEntry entry;

  RegistrationState(this.entry);

  static RegistrationState initial() {
    return RegistrationState(null);
  }
}

class RegistrationEntry {
  final Client client;
  final Project project;
  final DateTime date;

  RegistrationEntry(this.client, this.project, this.date);

}
