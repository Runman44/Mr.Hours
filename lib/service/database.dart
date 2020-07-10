import 'dart:io';
import 'dart:ui';
import 'package:eventtracker/model/model.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final Database _db;
  static const int DB_VERSION = 1;

  DatabaseService(this._db) : assert(_db != null);

  static void _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id TEXT not null primary key,
        name TEXT not null,
        email TEXT not null
      )
    ''');
    await db.execute('''
      create table client(
        id integer not null primary key autoincrement,
        name text not null,
        color integer not null
      )
    ''');
    await db.execute('''
      create table project(
        id integer not null primary key autoincrement,
        client_id integer default null,
        name text not null,
        billable integer not null,
        rate integer not null,
        foreign key(client_id) references client(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      create table registration(
        id integer not null primary key autoincrement,
        project_id integer default null,
        start_date_time int not null,
        end_date_time int not null,
        break integer not null,
        foreign key(project_id) references project(id) ON DELETE CASCADE
      )
    ''');
  }
  // Open the database and store the reference.
  static Future<DatabaseService> open() async {
    // get a path to the database file
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, 'mrandersonhours.db');
    await Directory(databasesPath).create(recursive: true);

    // open the database
    Database db = await openDatabase(path,
        onConfigure: _onConfigure, onCreate: _onCreate, version: DB_VERSION);
    DatabaseService repo = DatabaseService(db);

    return repo;
  }

  Future<void> insertUser(User user) async {
    await _db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Client> insertClient(String name, Color color) async {
    int id = await _db.rawInsert("insert into client(name, color) values(?, ?)", <dynamic>[name, color.value]);
    return Client(id: id, name: name, color: color, projects: []);
  }

  Future<List<Client>> listClients() async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _db.rawQuery("select id, name, color from client order by client.name asc");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Client(
        id: maps[i]['id'],
        name: maps[i]['name'],
        color: Color(maps[i]['color'] as int),
        projects: []
      );
    });
  }

  Future<void> editClient(int id, String name, Color color) async {
    int rows = await _db.rawUpdate("update client set name=?, color=? where id=?", <dynamic>[name, color.value, id]);
    assert(rows == 1);
  }

  Future<void> deleteClient(int clientId) async {
    await _db.delete(
      'client',
      where: "id = ?",
      whereArgs: [clientId],
    );
  }

  Future<Project> insertProject(int clientId, String name, bool billable, int rate) async {
    int id = await _db.rawInsert("insert into project(client_id, name, billable, rate) values(?, ?, ?, ?)", <dynamic>[clientId, name, billable ? 1 : 0, rate]);
    return Project(id: id, name: name, billable: billable, rate: rate, clientId: clientId, registrations: []);
  }

  Future<void> editProject(int projectId, String name, bool billable, int rate) async {
    int rows = await _db.rawUpdate("update project set name=?, billable=?, rate=? where id=?", <dynamic>[name, billable ? 1 : 0, rate, projectId]);
    assert(rows == 1);
  }

  Future<void> deleteProject(int projectId) async {
    await _db.delete(
      'project',
      where: "id = ?",
      whereArgs: [projectId],
    );
  }

  Future<List<Project>> listProjects(int clientId) async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _db.rawQuery("select id, name, billable, rate from project where client_id=?", <dynamic>[clientId]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Project(
          id: maps[i]['id'],
          name: maps[i]['name'],
          billable: maps[i]['billable'] == 1 ? true : false,
          rate: maps[i]['rate'],
          registrations: []
      );
    });
  }

  Future<Registration> insertRegistration(int projectId, DateTime startDateTime, DateTime endDateTime, int breakTime) async {
    int st = startDateTime?.millisecondsSinceEpoch;
    int et = endDateTime?.millisecondsSinceEpoch;
    int id = await _db.rawInsert("insert into registration(project_id, start_date_time, end_date_time, break) values(?, ?, ?, ?)", <dynamic>[projectId, st, et, breakTime]);
    return Registration(id: id, startDateTime: startDateTime, endDateTime: endDateTime, breakTime: breakTime, projectId: projectId);
  }

  Future<void> editRegistration(int registrationId, int projectId, DateTime startDateTime, DateTime endDateTime, int breakTime) async {
    int st = startDateTime?.millisecondsSinceEpoch;
    int et = endDateTime?.millisecondsSinceEpoch;
    int rows = await _db.rawUpdate("update registration set project_id=?, break=?, start_date_time=?, end_date_time=? where id=?", <dynamic>[projectId, breakTime, st, et, registrationId]);
    assert(rows == 1);
  }

  Future<void> deleteRegistration(int registrationId) async {
    await _db.delete(
      'registration',
      where: "id = ?",
      whereArgs: [registrationId],
    );
  }

  Future<List<DashboardItem>> listRegistrations(DatePeriod datePeriod) async {

    final List<Map<String, dynamic>> maps = await _db.rawQuery('''select registration.id, project_id, project.client_id, client.color, client.name as client_name, project.name as project_name, start_date_time, end_date_time, break from registration inner join project on registration.project_id = project.id inner join client on project.client_id = client.id where start_date_time between '${datePeriod.start.millisecondsSinceEpoch}' and '${datePeriod.end.millisecondsSinceEpoch}' ''');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DashboardItem(
          registrationId: maps[i]['id'],
          projectId: maps[i]['project_id'],
          clientId: maps[i]['client_id'],
          clientColor: Color(maps[i]['color'] as int),
          clientName: maps[i]['client_name'],
          projectName: maps[i]['project_name'],
          startDateTime: DateTime.fromMillisecondsSinceEpoch(maps[i]["start_date_time"] as int),
          endDateTime:  DateTime.fromMillisecondsSinceEpoch(maps[i]["end_date_time"] as int),
          breakTime: maps[i]['break'],

      );
    });
  }

  Future<List<DashboardItem>> listRegistrationsFromClient(int clientId, DatePeriod datePeriod) async {

    final List<Map<String, dynamic>> maps = await _db.rawQuery('''select registration.id, project_id, project.client_id, client.color, client.name as client_name, project.name as project_name, start_date_time, end_date_time, break from registration inner join project on registration.project_id = project.id inner join client on project.client_id = client.id where start_date_time between '${datePeriod.start.millisecondsSinceEpoch}' and '${datePeriod.end.millisecondsSinceEpoch}' ''');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DashboardItem(
        registrationId: maps[i]['id'],
        projectId: maps[i]['project_id'],
        clientId: maps[i]['client_id'],
        clientColor: Color(maps[i]['color'] as int),
        clientName: maps[i]['client_name'],
        projectName: maps[i]['project_name'],
        startDateTime: DateTime.fromMillisecondsSinceEpoch(maps[i]["start_date_time"] as int),
        endDateTime:  DateTime.fromMillisecondsSinceEpoch(maps[i]["end_date_time"] as int),
        breakTime: maps[i]['break'],

      );
    });
  }
}