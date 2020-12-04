import 'package:eventtracker/view/model/model.dart';
import 'package:eventtracker/view/service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final String tasks;

  const CreateRegistration(this.client, this.project, this.startDate, this.endDate, this.breakTime, this.rate, this.billable, this.tasks);
}

class EditRegistration extends RegistrationsEvent {
  final int clientId;
  final int projectId;
  final int registration;
  final DateTime startDate;
  final DateTime endDate;
  final int breakTime;
  final String tasks;

  const EditRegistration(
      this.registration,
      this.clientId,
      this.projectId,
      this.startDate,
      this.endDate,
      this.breakTime,
      this.tasks);
}

class RemoveRegistration extends RegistrationsEvent {
  final int registrationId;

  const RemoveRegistration(this.registrationId);
}

class RegistrationBloc extends Bloc<RegistrationsEvent, RegistrationState> {
  final DatabaseService data;

  RegistrationBloc(this.data) : super(RegistrationState(null, null, null, null, null, null));

  @override
  Stream<RegistrationState> mapEventToState(RegistrationsEvent event) async* {
    if (event is CreateRegistration) {
      await data.insertRegistration(event.project.id, event.startDate, event.endDate, event.breakTime, event.tasks);
      yield RegistrationState(state.client, state.project, state.startDate, state.endDate, state.breakTime, state.tasks);
    } else if (event is EditRegistration) {
      await data.editRegistration(event.registration, event.projectId, event.startDate, event.endDate, event.breakTime, event.tasks);
      yield RegistrationState(state.client, state.project, state.startDate, state.endDate, state.breakTime, state.tasks);
    } else if (event is RemoveRegistration) {
      await data.deleteRegistration(event.registrationId);
      yield RegistrationState(null, null, null, null, null, null);
    }
  }
}

class RegistrationState {

  final Client client;
  final Project project;
  final DateTime startDate;
  final DateTime endDate;
  final int breakTime;
  final String tasks;

  const RegistrationState(this.client, this.project, this.startDate, this.endDate, this.breakTime, this.tasks);

}
