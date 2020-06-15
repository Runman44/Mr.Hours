import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegistrationEditor extends StatefulWidget {
  final Client client;
  final Project project;
  final Registration registration;
  final DateTime pickedDate;

  RegistrationEditor(
      {Key key,
      @required this.client,
      @required this.project,
      @required this.registration,
      @required this.pickedDate})
      : super(key: key);

  @override
  _RegistrationEditorState createState() => _RegistrationEditorState();
}

class _RegistrationEditorState extends State<RegistrationEditor> {
  FocusNode _focus;
  final _formKey = GlobalKey<FormState>();
  Client _dropdownValue;
  Project _dropdownValue2;
  DateTime _date;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _dropdownValue = widget.client;
    _dropdownValue2 = widget.project;
    _date = widget.registration?.date ?? widget.pickedDate;
    _startTime =  widget.registration?.startTime ?? TimeOfDay.now();
    _endTime = widget.registration?.endTime ?? TimeOfDay.now();
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime:_startTime, );
    if (picked != null && picked != _startTime)
      setState(() {
        _startTime = picked;
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime:_endTime);
    if (picked != null && picked != _endTime)
      setState(() {
        _endTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);

    var projects = _dropdownValue?.projects ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.registration == null ? "Uren toevoegen" : "Uren wijzigen",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        bloc: clientBloc,
        builder: (context, clientState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Kies een opdrachtgever",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton(
                      isExpanded: true,
                      disabledHint: Text(widget.client?.name ?? ""),
                      hint: Text("Selecteer een opdrachtgever"),
                      value: _dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: widget.client == null ?  (newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      } : null,
                      items: clientBloc.state.clients
                          .map<DropdownMenuItem<Client>>((Client value) {
                        return DropdownMenuItem<Client>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                  ),
                  Text(
                    "Kies een project",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton(
                      hint: Text("Selecteer een project"),
                      disabledHint: Text(widget.project?.name ?? ""),
                      value: _dropdownValue2,
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: widget.project == null ?  (newValue) {
                        setState(() {
                          _dropdownValue2 = newValue;
                        });
                      } : null,
                      items: projects
                          .map<DropdownMenuItem<Project>>((Project value) {
                        return DropdownMenuItem<Project>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                  ),
                  Text(
                    "Kies een datum",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.white,
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.calendar_today),
                          ),
                          Text(formatDate(_date)),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Kies een starttijd",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.white,
                      onPressed: () {
                        _selectStartTime(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.access_time),
                          ),
                          Text(_startTime.format(context)),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Kies een eindtijd",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.white,
                      onPressed: () {
                        _selectEndTime(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.access_time),
                          ),
                          Text(_endTime.format(context)),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        visible: widget.registration != null,
                        child: RaisedButton(
                          child: Text("Uren Verwijderen"),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () async {
                            clientBloc.add(
                              DeleteRegistration(widget.client, widget.project, widget.registration.id),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      RaisedButton(
                        child: Text("Uren Opslaan"),
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        onPressed: () async {
                          bool valid = _formKey.currentState.validate();
                          if (!valid) return;

                          if (widget.client != null && widget.project != null && widget.registration != null) {
                            clientBloc.add(EditRegistration(
                                widget.client,
                                widget.project,
                                widget.registration,
                                _date,
                                _startTime,
                                0,
                                _endTime,
                                widget.project.rate,
                                widget.project.billable));
                          } else {
                            clientBloc.add(AddRegistration(
                                _dropdownValue,
                                _dropdownValue2,
                                _date,
                                _startTime,
                                0,
                                _endTime,
                                _dropdownValue2.rate,
                                _dropdownValue2.billable));
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }
}
