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

  DashboardItem({this.registrationId, this.projectId, this.clientId, this.clientName, this.clientColor, this.projectName, this.startDateTime, this.endDateTime, this.breakTime});

  String minutesToUIString() {
    var inMinutes = endDateTime
        .difference(startDateTime)
        .inMinutes;
    print(startDateTime.toIso8601String() + " dss " + endDateTime.toIso8601String());
    Duration duration = Duration(minutes: inMinutes);
    List<String> parts = duration.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
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