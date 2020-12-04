import 'dart:io';

import 'package:flutter/material.dart';

class Client {

  int id;
  String name;
  Color color;
  List<Project> projects = [];

  Client({this.id, this.name, this.color, this.projects});
}

class Project {

  int id;
  String name;
  int rate = 0;
  bool billable = false;
  int clientId;
  List<Registration> registrations = [];

  Project({this.id, this.name, this.rate, this.billable, this.clientId, this.registrations});

  double centsToDouble() {
    return rate / 100;
  }
}

class Registration {

  int id;
  DateTime startDateTime;
  DateTime endDateTime;
  int breakTime;
  int projectId;

  Registration({this.id, this.startDateTime, this.endDateTime, this.breakTime, this.projectId});

  TimeOfDay minutesToTimeOfDay(int minutes) {
      Duration duration = Duration(minutes: minutes);
      List<String> parts = duration.toString().split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

}

class DashboardItem {

  int registrationId;
  int projectId;
  int clientId;
  String clientName;
  Color clientColor;
  String projectName;
  DateTime startDateTime;
  DateTime endDateTime;
  int breakTime;
  String tasks;

  DashboardItem({this.registrationId, this.projectId, this.clientId, this.clientName, this.clientColor, this.projectName, this.startDateTime, this.endDateTime, this.breakTime, this.tasks});

  String minutesToUIString() {
    var inMinutes = endDateTime
        .difference(startDateTime)
        .inMinutes;
    Duration duration = Duration(minutes: inMinutes);
    List<String> parts = duration.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  int totalMinutes(){
    return endDateTime
        .difference(startDateTime)
        .inMinutes;
  }



  TimeOfDay minutesToTimeOfDay(int minutes) {
    Duration duration = Duration(minutes: minutes);
    List<String> parts = duration.toString().split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

}

class Settings {
  bool darkMode;
  File logo;

  Settings([this.darkMode, this.logo]);

}

class Account {
  final File logo;

  Account({this.logo});
}