import 'package:eventtracker/resource/network.dart';
import 'package:flutter/material.dart';
import 'package:time/time.dart';
import '../extention.dart';

class User {

  int id;
  String email;
  String firstName;
  String middleName;
  String lastName;
  int administrationId;

  User();

  User.fromDto(UserDto userDto) {
    this.id = userDto.id;
    this.email = userDto.email;
    this.firstName = userDto.firstName;
    this.lastName = userDto.lastName;
    this.administrationId = userDto.administrationId;
  }
}

class Client {

  String id;
  String name;
  Color color;
  List<Project> projects = [];

  Client();

  Client.fromDto(ClientDto clientDto) {
    this.id = clientDto.id;
    this.name = clientDto.name;
    this.color = HexColor.fromHex(clientDto.hex);
  }
}

class Project {

  String id;
  String name;
  int rate = 0;
  bool billable = false;
  List<Registration> registrations = [];

  Project();

  Project.fromDto(ProjectDto projectDto) {
    this.id = projectDto.id;
    this.name = projectDto.name;
    this.rate = projectDto.rate;
    this.billable = projectDto.billable;
  }

  double centsToDouble() {
    return rate / 100;
  }
}

class Registration {

  String id;
  String description;
  DateTime date;
  int minutesWorked;
  TimeOfDay startTime;
  int breakTime;
  TimeOfDay endTime;

  Registration();

  Registration.fromDto(RegistrationDto registrationDto) {
    this.id = registrationDto.id;
    this.date = registrationDto.date;
    this.minutesWorked = registrationDto.minutes;
    this.startTime = minutesToTimeOfDay(registrationDto.startTime);
    this.breakTime = registrationDto.breakz;
    this.endTime = minutesToTimeOfDay(registrationDto.endTime);
  }

  TimeOfDay minutesToTimeOfDay(int minutes) {
      Duration duration = Duration(minutes: minutes);
      List<String> parts = duration.toString().split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

}

class Booking {

  Client client;
  Project project;
  Registration registration;

  Booking(this.client, this.project, this.registration);

  String minutesToUIString() {
    Duration duration = Duration(minutes: registration.minutesWorked);
    List<String> parts = duration.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}