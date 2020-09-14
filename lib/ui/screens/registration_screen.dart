import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/bloc/RegistrationBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sup/quick_sup.dart';

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
      @required this.endDate})
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

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _startDateTime = widget.startDate;
    _endDateTime = widget.endDate;
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var projects = _dropdownValue?.projects ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.registration == null ? "Uren toevoegen" : "Uren wijzigen",
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
                BlocProvider.of<RegistrationBloc>(context).add(
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

              _startDateTime = DateTime(
                  _startDateTime.year,
                  _startDateTime.month,
                  _startDateTime.day,
                  _startDateTime.hour,
                  _startDateTime.minute);
              _endDateTime = DateTime(_endDateTime.year, _endDateTime.month,
                  _endDateTime.day, _endDateTime.hour, _endDateTime.minute);

              if (widget.clientId != null &&
                  widget.projectId != null &&
                  widget.registration != null) {
                BlocProvider.of<RegistrationBloc>(context).add(EditRegistration(
                    widget.registration,
                    widget.clientId,
                    widget.projectId,
                    _startDateTime,
                    _endDateTime,
                    0));
              } else {
                BlocProvider.of<RegistrationBloc>(context).add(
                    CreateRegistration(
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
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (BuildContext context, ClientState clientState) {
          if (clientState is ClientsLoadSuccess) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down),
                        style: Theme.of(context).textTheme.bodyText2,
                        disabledHint: Text(widget.clientName ?? ""),
                        hint: Text("Kies een opdrachtgever"),
                        value: _dropdownValue,
                        onChanged: widget.clientId == null
                            ? (newValue) {
                                setState(() {
                                  _dropdownValue = newValue;
                                });
                              }
                            : null,
                        underline: Container(),
                        items: (BlocProvider.of<ClientBloc>(context).state
                                as ClientsLoadSuccess)
                            .clients
                            .map<DropdownMenuItem<Client>>((Client value) {
                          return DropdownMenuItem<Client>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        hint: Text("Selecteer een project"),
                        disabledHint: Text(widget.projectName ?? ""),
                        value: _dropdownValue2,
                        icon: Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        style: Theme.of(context).textTheme.bodyText2,
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
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Wanneer ben je begonnen?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
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
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Wanneer ben je gestopt?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
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
            );
          }
          if (clientState is ClientsLoadEmpty) {
            return Center(
              child: QuickSup.empty(
                subtitle: 'Nog geen clienten aangemaakt',
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
