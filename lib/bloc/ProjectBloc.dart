import 'dart:ui';

import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProjectsEvent {
  const ProjectsEvent();
}

class LoadProject extends ProjectsEvent {}

class AddProject extends ProjectsEvent {
  final Client client;
  final String name;
  final String rate;
  final Color billable;

  const AddProject(this.client, this.name, this.rate, this.billable);
}

class EditProject extends ProjectsEvent {
  final String name;
  final String rate;
  final Color billable;

  const EditProject(this.name, this.rate, this.billable);
}

class ProjectBloc extends Bloc<ProjectsEvent, ProjectState> {

  @override
  ProjectState get initialState => ProjectState.initial();

  @override
  Stream<ProjectState> mapEventToState(ProjectsEvent event) async* {
    if (event is LoadProject) {
//      var projects = await getAllProjects();
//      var uiProjects = projects.map((e) => Project.fromDto(e)).toList();
//      yield ProjectState(uiProjects);
    } else if (event is AddProject) {
//      yield ProjectState(uiClients);
    } else if (event is EditProject) {
//      yield ProjectState(uiClients);
    }
  }
}

class ProjectState {
  final List<Project> projects;

  ProjectState(this.projects);

  static ProjectState initial() {
    return ProjectState(null);
  }
}
