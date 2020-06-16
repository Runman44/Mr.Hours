
import 'dart:ui';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ClientsEvent {
  const ClientsEvent();
}

class LoadClient extends ClientsEvent {}

class CreateClient extends ClientsEvent {
  final String name;
  final Color color;
  final String projectName;
  final double rate;
  final bool billable;

  const CreateClient(this.name, this.color, this.projectName, this.rate, this.billable);
}

class EditClient extends ClientsEvent {
  final String id;
  final String name;
  final Color color;
  final List<Project> projects;

  const EditClient(this.id, this.name, this.color, this.projects);
}

class DeleteClient extends ClientsEvent {
  final String id;

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
  final String projectId;
  final String name;
  final double rate;
  final bool billable;

  const EditProject(this.client, this.projectId, this.name, this.rate, this.billable);
}

class DeleteProject extends ClientsEvent {
  final Client client;
  final String projectId;

  const DeleteProject(this.client, this.projectId);
}

class AddRegistration extends ClientsEvent {
  final Client client;
  final Project project;
  final DateTime date;
  final TimeOfDay startTime;
  final int breakTime;
  final TimeOfDay endTime;
  final int rate;
  final bool billable;

  const AddRegistration(this.client, this.project, this.date, this.startTime, this.breakTime, this.endTime, this.rate, this.billable);
}

class EditRegistration extends ClientsEvent {
  final Client client;
  final Project project;
  final Registration registration;
  final DateTime date;
  final TimeOfDay startTime;
  final int breakTime;
  final TimeOfDay endTime;
  final int rate;
  final bool billable;

  const EditRegistration(this.client, this.project, this.registration, this.date, this.startTime, this.breakTime, this.endTime, this.rate, this.billable);
}

class DeleteRegistration extends ClientsEvent {
  final Client client;
  final Project project;
  final String registrationId;

  const DeleteRegistration(this.client, this.project, this.registrationId);
}

class ClientBloc extends Bloc<ClientsEvent, ClientState> {
  @override
  ClientState get initialState => ClientState.initial();

  @override
  Stream<ClientState> mapEventToState(ClientsEvent event) async* {
    if (event is LoadClient) {
      List<ClientDto> clientsDto = await getAllClients();
      var clients = clientsDto.where((client) => client.deletedOn == null).toList();

      var uiClients = clients.map((e) => Client.fromDto(e)).toList();

      print("LoadClient start");
      for (Client client in uiClients) {
        var projectsDto = await getAllProjectsByClient(client.id);
        var projects = projectsDto.where((project) => project.deletedOn == null).toList();
        var uiProjects = projects.map((e) => Project.fromDto(e)).toList();

        for (Project project in uiProjects) {
          var registrationsDto = await getAllRegistrationsByProduct(project.id);
          var registrations = registrationsDto.where((registration) => registration.deletedOn == null).toList();
          var uiRegistrations = registrations.map((e) => Registration.fromDto(e)).toList();

          project.registrations = uiRegistrations;
          client.projects = uiProjects;
        }
      }
      print("LoadClient end");
      yield ClientState(uiClients);
    }
    else if (event is CreateClient) {
      ClientDto newClient = await sendClient(event.name, event.color);
      Client uiClient = Client.fromDto(newClient);

      var amountInCents = (event.rate * 100).toInt();

      ProjectDto newProject = await sendProject(event.projectName, event.billable, amountInCents, uiClient.id);
      Project uiProject = Project.fromDto(newProject);

      uiClient.projects.add(uiProject);

      List<Client> clients = state.clients;
      clients.add(uiClient);
      yield ClientState(clients);
    }
    else if (event is EditClient) {
      ClientDto newClient = await updateClient(event.id, event.name, event.color);
      Client uiClient = Client.fromDto(newClient);
      uiClient.projects = event.projects;

      List<Client> clients = state.clients.map((client) {
        if (client.id == event.id) return uiClient;
        return client;
      }).toList();
      yield ClientState(clients);
    }
    else if (event is DeleteClient) {
      ClientDto deletedClientDto = await deleteClient(event.id);
      Client deletedClient = Client.fromDto(deletedClientDto);

      var clients = state.clients;

      clients.removeWhere((element) => element.id == deletedClient.id);

      yield ClientState(clients);
    }
    else if (event is AddProject) {

      var amountInCents = (event.rate * 100).toInt();

       ProjectDto newProject = await sendProject(event.name, event.billable, amountInCents, event.client.id);
       Project uiProject = Project.fromDto(newProject);

       var client = event.client;
       client.projects.add(uiProject);

       List<Client> clients = state.clients.map((oldClient) {
         if (oldClient.id == client.id) return client;
         return oldClient;
       }).toList();
       yield ClientState(clients);
    }
    else if (event is EditProject) {
      var amountInCents = (event.rate * 100).toInt();

      print("EditProject start");
      print("EditProject start ${event.billable}");
      ProjectDto newProject = await updateProject(event.projectId, event.name, event.billable, amountInCents);
      Project uiProject = Project.fromDto(newProject);
      print("EditProject start ${uiProject.billable}");
      var client = event.client;

      List<Project> projects = client.projects.map((oldProject) {
        if (oldProject.id == uiProject.id) return uiProject;
        return oldProject;
      }).toList();

      client.projects = projects;

      List<Client> clients = state.clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();
      print("EditProject end");
      yield ClientState(clients);
    }
    else if (event is DeleteProject) {
      ProjectDto deletedProjectDto = await deleteProject(event.projectId);
      Project deletedProject = Project.fromDto(deletedProjectDto);

      var client = event.client;

      client.projects.removeWhere((element) => element.id == deletedProject.id);

      List<Client> clients = state.clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();

      yield ClientState(clients);
    }
    else if (event is AddRegistration) {
      var client = event.client;
      var project = event.project;

      RegistrationDto registrationDto = await sendRegistration(event.date, timeOfDayToMinutes(event.startTime), event.breakTime, timeOfDayToMinutes(event.endTime), project.billable, project.rate, project.id);
      Registration registration = Registration.fromDto(registrationDto);

      project.registrations.add(registration);

      List<Project> projects = client.projects.map((oldProject) {
        if (oldProject.id == project.id) return project;
        return oldProject;
      }).toList();

      client.projects = projects;

      List<Client> clients = state.clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();
      yield ClientState(clients);
    }
    else if (event is EditRegistration) {
      var client = event.client;
      var project = event.project;

      RegistrationDto registrationDto = await updateRegistration(event.registration, event.date, timeOfDayToMinutes(event.startTime), event.breakTime, timeOfDayToMinutes(event.endTime), project.billable, project.rate, project.id);
      Registration registration = Registration.fromDto(registrationDto);

      List<Registration> registrations = project.registrations.map((oldRegistration) {
        if (oldRegistration.id == registration.id) return registration;
        return oldRegistration;
      }).toList();

      project.registrations = registrations;

      List<Project> projects = client.projects.map((oldProject) {
        if (oldProject.id == project.id) return project;
        return oldProject;
      }).toList();

      client.projects = projects;

      List<Client> clients = state.clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();
      yield ClientState(clients);
    }
    else if (event is DeleteRegistration) {
      RegistrationDto deletedRegistrationDto = await deleteRegistration(event.registrationId);
      Registration deletedRegistration = Registration.fromDto(deletedRegistrationDto);

      var project = event.project;

      project.registrations.removeWhere((element) => element.id == deletedRegistration.id);

      var client = event.client;

      List<Project> projects = client.projects.map((oldProject) {
        if (oldProject.id == project.id) return project;
        return oldProject;
      }).toList();

      client.projects = projects;

      List<Client> clients = state.clients.map((oldClient) {
        if (oldClient.id == client.id) return client;
        return oldClient;
      }).toList();

      yield ClientState(clients);
    }
  }


  int timeOfDayToMinutes(TimeOfDay timeOfDay) {
    return Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute).inMinutes;
  }

}

class ClientState {
  final List<Client> clients;

  ClientState(this.clients) : assert(clients != null);

  static ClientState initial() {
    return ClientState([]);
  }
}
