import 'dart:ui';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ClientsEvent {
  const ClientsEvent();
}

class LoadClients extends ClientsEvent {}

class CreateClient extends ClientsEvent {
  final String name;
  final Color color;
  final String projectName;
  final double rate;
  final bool billable;

  const CreateClient(
      this.name, this.color, this.projectName, this.rate, this.billable);
}

class EditClient extends ClientsEvent {
  final int id;
  final String name;
  final Color color;
  final List<Project> projects;

  const EditClient(this.id, this.name, this.color, this.projects);
}

class DeleteClient extends ClientsEvent {
  final int id;

  const DeleteClient(this.id);
}

class AddProject extends ClientsEvent {
  final Client client;
  final String name;
  final double rate;
  final bool billable;

  const AddProject(this.client, this.name, this.rate, this.billable);
}

class EditProject extends ClientsEvent {
  final Client client;
  final int projectId;
  final String name;
  final double rate;
  final bool billable;
  final List<Registration> registrations;

  const EditProject(this.client, this.projectId, this.name, this.rate, this.billable, this.registrations);
}

class DeleteProject extends ClientsEvent {
  final Client client;
  final int projectId;

  const DeleteProject(this.client, this.projectId);
}

class ClientBloc extends Bloc<ClientsEvent, ClientState> {
  final DatabaseService data;

  ClientBloc(this.data);

  @override
  ClientState get initialState => ClientsLoadInProgress();

  @override
  Stream<ClientState> mapEventToState(ClientsEvent event) async* {
    if (event is LoadClients) {
      yield* _fetchClients();
    } else if (event is CreateClient) {
      if (state is ClientsLoadSuccess) {
        var amountInCents = (event.rate * 100).toInt();
        Client newClient = await data.insertClient(event.name, event.color);
        Project newProject = await data.insertProject(
            newClient.id, event.projectName, event.billable, amountInCents);
        newClient.projects.add(newProject);
        List<Client> clients = (state as ClientsLoadSuccess).clients;
        clients.add(newClient);
        yield ClientsLoadSuccess(clients);
      }
    } else if (event is EditClient) {

      if (state is ClientsLoadSuccess) {
        await data.editClient(event.id, event.name, event.color);

        List<Client> clients = (state as ClientsLoadSuccess).clients.map((client) {
          if (client.id == event.id)
            return Client(
                id: event.id,
                name: event.name,
                color: event.color,
                projects: event.projects);
          return client;
        }).toList();

        yield ClientsLoadSuccess(clients);
      }

    } else if (event is DeleteClient) {

      if (state is ClientsLoadSuccess) {
        await data.deleteClient(event.id);
        var clients = (state as ClientsLoadSuccess).clients;
        clients.removeWhere((element) => element.id == event.id);
        yield ClientsLoadSuccess(clients);
      }
    } else if (event is AddProject) {
      var amountInCents = (event.rate * 100).toInt();
      Project newProject  = await data.insertProject(event.client.id, event.name, event.billable, amountInCents);

      var client = event.client;
      client.projects.add(newProject);

      List<Client> clients = (state as ClientsLoadSuccess).clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();

      yield ClientsLoadSuccess(clients);
    }
     else if (event is EditProject) {

      var amountInCents = (event.rate * 100).toInt();

      await data.editProject(event.projectId, event.name, event.billable, amountInCents);

      var client = event.client;

      List<Project> projects = client.projects.map((oldProject) {
        if (oldProject.id == event.projectId) return
          Project(
            id: event.projectId,
            name: event.name,
            billable: event.billable,
            rate: amountInCents,
            clientId: event.client.id,
            registrations: event.registrations);
        return oldProject;
      }).toList();

      client.projects = projects;

      List<Client> clients = (state as ClientsLoadSuccess).clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();


      yield ClientsLoadSuccess(clients);
    }
    else if (event is DeleteProject) {
      await data.deleteProject(event.projectId);

      var client = event.client;
      client.projects.removeWhere((element) => element.id == event.projectId);

      List<Client> clients = (state as ClientsLoadSuccess).clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();

      yield ClientsLoadSuccess(clients);
    }
//    else if (event is AddRegistration) {
//      var client = event.client;
//      var project = event.project;
//
//      RegistrationDto registrationDto = await sendRegistration(event.date, timeOfDayToMinutes(event.startTime), event.breakTime, timeOfDayToMinutes(event.endTime), project.billable, project.rate, project.id);
//      Registration registration = Registration.fromDto(registrationDto);
//
//      project.registrations.add(registration);
//
//      List<Project> projects = client.projects.map((oldProject) {
//        if (oldProject.id == project.id) return project;
//        return oldProject;
//      }).toList();
//
//      client.projects = projects;
//
//      List<Client> clients = state.clients.map((oldClient) {
//        if (oldClient.id == client.id) return client;
//        return oldClient;
//      }).toList();
//      yield ClientState(clients);
//    }
//    else if (event is EditRegistration) {
//      var client = event.client;
//      var project = event.project;
//
//      RegistrationDto registrationDto = await updateRegistration(event.registration, event.date, timeOfDayToMinutes(event.startTime), event.breakTime, timeOfDayToMinutes(event.endTime), project.billable, project.rate, project.id);
//      Registration registration = Registration.fromDto(registrationDto);
//
//      List<Registration> registrations = project.registrations.map((oldRegistration) {
//        if (oldRegistration.id == registration.id) return registration;
//        return oldRegistration;
//      }).toList();
//
//      project.registrations = registrations;
//
//      List<Project> projects = client.projects.map((oldProject) {
//        if (oldProject.id == project.id) return project;
//        return oldProject;
//      }).toList();
//
//      client.projects = projects;
//
//      List<Client> clients = state.clients.map((oldClient) {
//        if (oldClient.id == client.id) return client;
//        return oldClient;
//      }).toList();
//      yield ClientState(clients);
//    }
//    else if (event is DeleteRegistration) {
//      RegistrationDto deletedRegistrationDto = await deleteRegistration(event.registrationId);
//      Registration deletedRegistration = Registration.fromDto(deletedRegistrationDto);
//
//      var project = event.project;
//
//      project.registrations.removeWhere((element) => element.id == deletedRegistration.id);
//
//      var client = event.client;
//
//      List<Project> projects = client.projects.map((oldProject) {
//        if (oldProject.id == project.id) return project;
//        return oldProject;
//      }).toList();
//
//      client.projects = projects;
//
//      List<Client> clients = state.clients.map((oldClient) {
//        if (oldClient.id == client.id) return client;
//        return oldClient;
//      }).toList();
//
//      yield ClientState(clients);

  }

  Stream<ClientState> _fetchClients() async* {
    yield ClientsLoadInProgress();
    try {
      List<Client> clients = await data.listClients();
      if (clients.isEmpty) {
        yield ClientsLoadEmpty();
      } else {
        clients.forEach((client) async {
          List<Project> projects = await data.listProjects(client.id);
          client.projects = projects;
        });
        yield ClientsLoadSuccess(clients);
      }
    } catch (_) {
      yield ClientsLoadFailed();
    }
  }

  int timeOfDayToMinutes(TimeOfDay timeOfDay) {
    return Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute).inMinutes;
  }
}

abstract class ClientState {
  const ClientState();
}

class ClientsLoadInProgress extends ClientState {}

class ClientsLoadFailed extends ClientState {}

class ClientsLoadEmpty extends ClientState {}

class ClientsLoadSuccess extends ClientState {
  final List<Client> clients;

  ClientsLoadSuccess(this.clients);
}
