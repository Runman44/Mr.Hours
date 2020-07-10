import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/bloc/RegistrationBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegistrationEditor extends StatefulWidget {
  final int clientId;
  final int projectId;
  final String projectName;
  final String clientName;
  final int registration;
  final DateTime startDate;
  final DateTime endDate;

  RegistrationEditor(
      {Key key,
      @required this.clientId,
      @required this.projectId,
      @required this.projectName,
      @required this.clientName,
      @required this.registration,
      @required this.startDate,
      @required this.endDate
      })
      : super(key: key);

  @override
  _RegistrationEditorState createState() => _RegistrationEditorState();
}

class _RegistrationEditorState extends State<RegistrationEditor> {
  FocusNode _focus;
  final _formKey = GlobalKey<FormState>();
  Client _dropdownValue;
  Project _dropdownValue2;
  DateTime _startDateTime;
  DateTime _endDateTime;
  int _breakTime;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
//    _dropdownValue = widget.client;
//    _dropdownValue2 = widget.project;
    _startDateTime = widget.startDate;
    _endDateTime = widget.endDate;
    _breakTime = 0;
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO other bloc!
    final ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);
    final RegistrationBloc registrationBloc = BlocProvider.of<RegistrationBloc>(context);

    var projects = _dropdownValue?.projects ?? [];

    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (BuildContext context, RegistrationState registrationState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.registration == null
                  ? "Uren toevoegen"
                  : "Uren wijzigen",
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              // action button
              Visibility(
                visible: widget.registration != null,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    registrationBloc.add(
                      RemoveRegistration(widget.registration),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {

                  bool valid = _formKey.currentState.validate();
                  if (!valid) return;
                  if (widget.clientId != null &&
                      widget.projectId != null &&
                      widget.registration != null) {
                    registrationBloc.add(EditRegistration(
                        widget.registration,
                        widget.clientId,
                        widget.projectId,
                        _startDateTime,
                        _endDateTime,
                        0));
                  } else {
                    registrationBloc.add(CreateRegistration(
                        _dropdownValue,
                        _dropdownValue2,
                        _startDateTime,
                        _endDateTime,
                        0,
                        _dropdownValue2.rate,
                        _dropdownValue2.billable));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Kies een opdrachtgever",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton(
                      isExpanded: true,
                      disabledHint: Text(widget.clientName ?? ""),
                      hint: Text("Selecteer een opdrachtgever"),
                      value: _dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: widget.clientId == null
                          ? (newValue) {
                              setState(() {
                                _dropdownValue = newValue;
                              });
                            }
                          : null,
                      items: (clientBloc.state as ClientsLoadSuccess)
                          .clients
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
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton(
                      hint: Text("Selecteer een project"),
                      disabledHint: Text(widget.projectName ?? ""),
                      value: _dropdownValue2,
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: widget.projectId == null
                          ? (newValue) {
                              setState(() {
                                _dropdownValue2 = newValue;
                              });
                            }
                          : null,
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
                    "Wanneer ben je begonnen?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
//                    Padding(
//                      padding: const EdgeInsets.all(16),
//                      child: FlatButton(
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(5.0)),
//                        color: Colors.white,
//                        onPressed: () {
//                          _selectStartDate(context);
//                        },
//                        child: Row(
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.all(16.0),
//                              child: Icon(Icons.calendar_today),
//                            ),
//                            Text(_startDateTime.toIso8601String()),
//                          ],
//                        ),
//                      ),
//                    ),
                  DateTimeField(
                    format: DateFormat("yyyy-MM-dd HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: _startDateTime ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              _startDateTime ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return _startDateTime;
                      }
                    },
                    autovalidate: true,
                    validator: (date) => date == null ? 'Invalid date' : null,
                    initialValue: _startDateTime,
                    onChanged: (date) => setState(() {
                      _startDateTime = date;
                    }),
                    resetIcon: Icon(Icons.delete),
                  ),
                  Text(
                    "Wanneer ben je gestopt?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
//                    Padding(
//                      padding: const EdgeInsets.all(16),
//                      child: FlatButton(
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(5.0)),
//                        color: Colors.white,
//                        onPressed: () {
////                          _selectStartTime(context);
//                        },
//                        child: Row(
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.all(16.0),
//                              child: Icon(Icons.calendar_today),
//                            ),
////                            Text(_startTime.format(context)),
//                          ],
//                        ),
//                      ),
//                    ),
                  DateTimeField(
                    format: DateFormat("yyyy-MM-dd HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: _endDateTime ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              _endDateTime ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return _endDateTime;
                      }
                    },
                    autovalidate: true,
                    validator: (date) => date == null ? 'Invalid date' : null,
                    initialValue: _endDateTime,
                    onChanged: (date) => setState(() {
                      _endDateTime = date;
                    }),
                    resetIcon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
