import 'dart:convert' show json;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:eventtracker/extention.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProjectDto {
  String _clientId;
  String _name;
  int _rate;
  bool _billable;
  String _id;
  String _createdOn;
  String _updatedOn;
  String _deletedOn;

  ProjectDto({String clientId,
        String name,
        int rate,
        bool billable,
        String id,
        String createdOn,
        String updatedOn}) {
    this._clientId = clientId;
    this._name = name;
    this._rate = rate;
    this._billable = billable;
    this._id = id;
    this._createdOn = createdOn;
    this._updatedOn = updatedOn;
    this._deletedOn = deletedOn;
  }

  String get clientId => _clientId;
  set clientId(String clientId) => _clientId = clientId;
  String get name => _name;
  set name(String name) => _name = name;
  int get rate => _rate;
  set rate(int rate) => _rate = rate;
  bool get billable => _billable;
  set billable(bool billable) => _billable = billable;
  String get id => _id;
  set id(String id) => _id = id;
  String get createdOn => _createdOn;
  set createdOn(String createdOn) => _createdOn = createdOn;
  String get updatedOn => _updatedOn;
  set updatedOn(String updatedOn) => _updatedOn = updatedOn;
  String get deletedOn => _deletedOn;
  set deletedOn(String deletedOn) => _deletedOn = deletedOn;

  ProjectDto.fromJson(Map<String, dynamic> json) {
    _clientId = json['client_id'];
    _name = json['name'];
    _rate = json['rate'];
    _billable = json['billable'];
    _id = json['id'];
    _createdOn = json['created_on'];
    _updatedOn = json['updated_on'];
    _deletedOn = json['deleted_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this._clientId;
    data['name'] = this._name;
    data['rate'] = this._rate;
    data['billable'] = this._billable;
    data['id'] = this._id;
    data['created_on'] = this._createdOn;
    data['updated_on'] = this._updatedOn;
    data['deleted_on'] = this._deletedOn;
    return data;
  }
}

class RegistrationDto {
  int _minutes;
  String _projectId;
  DateTime _date;
  int _rate;
  bool _billable;
  int _startTime;
  int _endTime;
  int _break;
  String _id;
  String _createdOn;
  String _updatedOn;
  String _deletedOn;

  RegistrationDto({int minutes, String projectId, DateTime date, int rate, bool billable, int startTime, int endTime, int breakz, String id, String createdOn, String updatedOn}) {
    this._minutes = minutes;
    this._projectId = projectId;
    this._date = date;
    this._rate = rate;
    this._billable = billable;
    this._startTime = startTime;
    this._endTime = endTime;
    this._break = breakz;
    this._id = id;
    this._createdOn = createdOn;
    this._updatedOn = updatedOn;
    this._deletedOn = deletedOn;
  }

  int get minutes => _minutes;
  set minutes(int minutes) => _minutes = minutes;
  String get projectId => _projectId;
  set projectId(String projectId) => _projectId = projectId;
  DateTime get date => _date;
  set date(DateTime date) => _date = date;
  int get rate => _rate;
  set rate(int rate) => _rate = rate;
  bool get billable => _billable;
  set billable(bool billable) => _billable = billable;
  int get startTime => _startTime;
  set startTime(int startTime) => _startTime = startTime;
  int get endTime => _endTime;
  set endTime(int endTime) => _endTime = endTime;
  int get breakz => _break;
  set breakz(int breakz) => _break = breakz;
  String get id => _id;
  set id(String id) => _id = id;
  String get createdOn => _createdOn;
  set createdOn(String createdOn) => _createdOn = createdOn;
  String get updatedOn => _updatedOn;
  set updatedOn(String updatedOn) => _updatedOn = updatedOn;
  String get deletedOn => _deletedOn;
  set deletedOn(String deletedOn) => _deletedOn = deletedOn;

  RegistrationDto.fromJson(Map<String, dynamic> json) {
    _minutes = json['minutes'];
    _projectId = json['project_id'];
    _date = DateTime.parse(json['date']);
    _rate = json['rate'];
    _billable = json['billable'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _break = json['break'];
    _id = json['id'];
    _createdOn = json['created_on'];
    _updatedOn = json['updated_on'];
    _deletedOn = json['deleted_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minutes'] = this._minutes;
    data['project_id'] = this._projectId;
    data['date'] = this._date;
    data['rate'] = this._rate;
    data['billable'] = this._billable;
    data['start_time'] = this._startTime;
    data['end_time'] = this._endTime;
    data['break'] = this._break;
    data['id'] = this._id;
    data['created_on'] = this._createdOn;
    data['updated_on'] = this._updatedOn;
    data['deleted_on'] = this._deletedOn;
    return data;
  }

  format(Duration d) => d.toString().substring(0, 4);

  String calculateHours() {
    return  format(Duration(minutes: _minutes));
  }

  String formatDate() {
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(_date);
  }
}

class ClientDto {
  int _tellowId;
  int _contactId;
  String _type;
  String _name;
  String _hex;
  String _id;
  String _createdOn;
  String _updatedOn;
  String _deletedOn;

  ClientDto(
      {int tellowId,
        int contactId,
        String type,
        String name,
        String hex,
        String id,
        String createdOn,
        String updatedOn}) {
    this._tellowId = tellowId;
    this._contactId = contactId;
    this._type = type;
    this._name = name;
    this._hex = hex;
    this._id = id;
    this._createdOn = createdOn;
    this._updatedOn = updatedOn;
    this._deletedOn = deletedOn;
  }

  int get tellowId => _tellowId;
  set tellowId(int tellowId) => _tellowId = tellowId;
  int get contactId => _contactId;
  set contactId(int contactId) => _contactId = contactId;
  String get type => _type;
  set type(String type) => _type = type;
  String get name => _name;
  set name(String name) => _name = name;
  String get hex => _hex;
  set hex(String hex) => _hex = hex;
  String get id => _id;
  set id(String id) => _id = id;
  String get createdOn => _createdOn;
  set createdOn(String createdOn) => _createdOn = createdOn;
  String get updatedOn => _updatedOn;
  set updatedOn(String updatedOn) => _updatedOn = updatedOn;
  String get deletedOn => _deletedOn;
  set deletedOn(String deletedOn) => _deletedOn = deletedOn;

  ClientDto.fromJson(Map<String, dynamic> json) {
    _tellowId = json['tellow_id'];
    _contactId = json['contact_id'];
    _type = json['type'];
    _name = json['name'];
    _hex = json['hex'];
    _id = json['id'];
    _createdOn = json['created_on'];
    _updatedOn = json['updated_on'];
    _deletedOn = json['deleted_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tellow_id'] = this._tellowId;
    data['contact_id'] = this._contactId;
    data['type'] = this._type;
    data['name'] = this._name;
    data['hex'] = this._hex;
    data['id'] = this._id;
    data['created_on'] = this._createdOn;
    data['updated_on'] = this._updatedOn;
    data['deleted_on'] = this._deletedOn;
    return data;
  }
}


class UserDto {
  int _id;
  String _email;
  int _tellowId;
  String _firstName;
  String _lastName;
  int _administrationId;
  String _intercomHash;

  UserDto(
      {int id,
        String email,
        int tellowId,
        String firstName,
        String lastName,
        int administrationId,
        String intercomHash}) {
    this._id = id;
    this._email = email;
    this._tellowId = tellowId;
    this._firstName = firstName;
    this._lastName = lastName;
    this._administrationId = administrationId;
    this._intercomHash = intercomHash;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get email => _email;
  set email(String email) => _email = email;
  int get tellowId => _tellowId;
  set tellowId(int tellowId) => _tellowId = tellowId;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  int get administrationId => _administrationId;
  set administrationId(int administrationId) =>
      _administrationId = administrationId;
  String get intercomHash => _intercomHash;
  set intercomHash(String intercomHash) => _intercomHash = intercomHash;

  UserDto.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _email = json['email'];
    _tellowId = json['tellow_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _administrationId = json['administration_id'];
    _intercomHash = json['intercom_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['email'] = this._email;
    data['tellow_id'] = this._tellowId;
    data['first_name'] = this._firstName;
    data['last_name'] = this._lastName;
    data['administration_id'] = this._administrationId;
    data['intercom_hash'] = this._intercomHash;
    return data;
  }
}

var token = "MTViYzBmYjg4NWI3MDRhZjAxNTE1OTY4Mjc2N2E4MzcyMTQxNWQxMjRmMDJhZjZjOGJlNjZlZGFlZjgwNTg5Mw";

Future<List<ClientDto>> getAllClients() async {
  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
  final response = await http.get("http://api.test.time.tellow.nl/api/client", headers: headerzz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable list = json.decode(response.body);
    return list.map((model) => ClientDto.fromJson(model)).toList();
  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}

Future<ClientDto> sendClient(String clientName, Color clientColor) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id": "${Random.secure().nextInt(564365)}", '
      '"name": "$clientName", '
      '"hex" : "#${clientColor.value.toRadixString(16)}",'
      '"type": "COMPANY",'
      '"updated_on": "$apiDate",'
      '"created_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.post("https://api.test.time.tellow.nl/api/client", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ClientDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}

Future<ClientDto> updateClient(String id, String clientName, Color clientColor) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id": "$id", '
      '"name": "$clientName", '
      '"hex" : "#${clientColor.value.toRadixString(16)}",'
      '"updated_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/client", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ClientDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}

Future<ClientDto> deleteClient(String id) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id": "$id", '
      '"deleted_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/client", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ClientDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}


Future<List<ProjectDto>> getAllProjectsByClient(String clientId) async {
  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
  final response = await http.get("https://api.test.time.tellow.nl/api/project/client/" + clientId, headers: headerzz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable list = json.decode(response.body);
    return list.map((model) => ProjectDto.fromJson(model)).toList();
  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration');
  }
}

Future<ProjectDto> updateProject(String projectId, String projectName, bool billable, int rate) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"name": "$projectName", '
      '"billable" : $billable,'
      '"id" : "$projectId",'
      '"rate": "$rate",'
      '"updated_on": "$apiDate"'
      '}';
  print(jsonz);
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/project", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(json.decode(response.body));
    return ProjectDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to send project' + response.toString());
  }
}

Future<ProjectDto> deleteProject(String projectId) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id" : "$projectId",'
      '"deleted_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/project", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProjectDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to send project' + response.toString());
  }
}

Future<ProjectDto> sendProject(String projectName, bool billable, int rate, String clientId) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id": "${Random.secure().nextInt(564365)}", '
      '"name": "$projectName", '
      '"billable" : $billable,'
      '"rate": "$rate",'
      '"client_id": "$clientId",'
      '"updated_on": "$apiDate",'
      '"created_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.post("https://api.test.time.tellow.nl/api/project", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProjectDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to send project' + response.toString());
  }
}

//TODO dont forget when using it to filter out deleted once
//Future<List<ProjectDto>> getAllProjects() async {
//  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
//  final response = await http.get("https://api.test.time.tellow.nl/api/project/", headers: headerzz);
//
//  if (response.statusCode == 200) {
//    // If the server did return a 200 OK response,
//    // then parse the JSON.
//    Iterable list = json.decode(response.body);
//    return list.map((model) => ProjectDto.fromJson(model)).toList();
//  } else {
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//    throw Exception('Failed to load registration');
//  }
//}

Future<List<RegistrationDto>> getAllRegistrationsByProduct(String projectId) async {
  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
  final response = await http.get("http://api.test.time.tellow.nl/api/registration/project/" + projectId, headers: headerzz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable list = json.decode(response.body);
    return list.map((model) => RegistrationDto.fromJson(model)).toList();
  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}

Future<RegistrationDto> sendRegistration(DateTime date, int startTime, int breakz,int endTime,bool billable, int rate, String projectId) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  var formatter2 = new DateFormat('yyyy-MM-dd');
  var apiDate2 = formatter2.format(date);

  String jsonz = '{'
      '"id": "${Random.secure().nextInt(999999)}", '
      '"billable": $billable, '
      '"date" : "$apiDate2",'
      '"rate": "$rate",'
      '"break": "$breakz",'
      '"start_time": "$startTime",'
      '"end_time": "$endTime",'
      '"project_id": "$projectId",'
      '"updated_on": "$apiDate",'
      '"created_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.post("https://api.test.time.tellow.nl/api/registration", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RegistrationDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to send registration' + response.toString());
  }
}

Future<RegistrationDto> updateRegistration(Registration registration, DateTime date, int startTime, int breakz,int endTime,bool billable, int rate, String projectId) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  var formatter2 = new DateFormat('yyyy-MM-dd');
  var apiDate2 = formatter2.format(date);

  String jsonz = '{'
      '"id": "${registration.id}", '
      '"billable": $billable, '
      '"date" : "$apiDate2",'
      '"rate": "$rate",'
      '"break": "$breakz",'
      '"start_time": "$startTime",'
      '"end_time": "$endTime",'
      '"project_id": "$projectId",'
      '"updated_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/registration", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RegistrationDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to send registration' + response.toString());
  }
}


Future<RegistrationDto> deleteRegistration(String registrationId) async {
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var apiDate = formatter.format(DateTime.now());

  String jsonz = '{'
      '"id" : "$registrationId",'
      '"deleted_on": "$apiDate"'
      '}';
  Map<String, String> headerzz = {"Accept": "application/json", "Content-type": "application/json", "Authorization": "Bearer " + token};
  final response = await http.patch("https://api.test.time.tellow.nl/api/registration", headers: headerzz, body: jsonz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RegistrationDto.fromJson(json.decode(response.body));

  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to delete registration' + response.toString());
  }
}


Future<UserDto> getUserDetails() async {
  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
  final response = await http.get("http://api.test.time.tellow.nl/api/user", headers: headerzz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,

    return UserDto.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}


Future<Uint8List> getPdfReport(String clientId, DatePeriod datePeriod) async {
  Map<String, String> headerzz = {"Accept": "application/json", "Authorization": "Bearer " + token};
  final response = await http.get("http://api.test.time.tellow.nl/api/report/pdf?client_id=${clientId}&type=selection&start_date=${datePeriod.start}&end_date=${datePeriod.end}", headers: headerzz);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,

    return response.bodyBytes;
  } else if (response.statusCode == 401) {
    throw Exception('new token required - Dennis');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load registration' + response.toString());
  }
}