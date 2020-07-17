import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ClientBloc.dart';

abstract class RegistrationsEvent {
  const RegistrationsEvent();
}

class CreateRegistration extends RegistrationsEvent {
  final Client client;
  final Project project;
  final DateTime startDate;
  final DateTime endDate;
  final int breakTime;
  final int rate;
  final bool billable;

  const CreateRegistration(this.client, this.project, this.startDate, this.endDate, this.breakTime, this.rate, this.billable);
}

class EditRegistration extends RegistrationsEvent {
  final int clientId;
  final int projectId;
  final int registration;
  final DateTime startDate;
  final DateTime endDate;
  final int breakTime;

  const EditRegistration(
      this.registration,
      this.clientId,
      this.projectId,
      this.startDate,
      this.endDate,
      this.breakTime);
}

class RemoveRegistration extends RegistrationsEvent {
  final int registrationId;

  const RemoveRegistration(this.registrationId);
}

class RegistrationBloc extends Bloc<RegistrationsEvent, RegistrationState> {
  final DatabaseService data;

  RegistrationBloc(this.data);

  @override
  RegistrationState get initialState => RegistrationState(null, null, null, null, null);

  @override
  Stream<RegistrationState> mapEventToState(RegistrationsEvent event) async* {
    if (event is CreateRegistration) {
      await data.insertRegistration(event.project.id, event.startDate, event.endDate, event.breakTime);
      yield RegistrationState(state.client, state.project, state.startDate, state.endDate, state.breakTime);
    } else if (event is EditRegistration) {
      await data.editRegistration(event.registration, event.projectId, event.startDate, event.endDate, event.breakTime);
      yield RegistrationState(state.client, state.project, state.startDate, state.endDate, state.breakTime);
    } else if (event is RemoveRegistration) {
      await data.deleteRegistration(event.registrationId);
      yield RegistrationState(null, null, null, null, null);
    }
  }
}

class RegistrationState {

  final Client client;
  final Project project;
  final DateTime startDate;
  final DateTime endDate;
  final int breakTime;

  const RegistrationState(this.client, this.project, this.startDate, this.endDate, this.breakTime);

}
