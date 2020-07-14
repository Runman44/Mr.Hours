
import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ProjectEditor extends StatefulWidget {
  final Project project;
  final Client client;

  ProjectEditor({Key key, @required this.project, @required this.client}) : super(key: key);

  @override
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  MoneyMaskedTextController _rateController;
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _rateController =  MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', initialValue: widget.project?.centsToDouble() ?? 0.0);
    _isSwitched = widget.project?.billable ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Project",
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
            visible: widget.project != null,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                BlocProvider.of<ClientBloc>(context).add(
                  DeleteProject(widget.client, widget.project.id),
                );
                Navigator.pop(context);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              bool valid = _formKey.currentState.validate();
              if(!valid) return;

              assert(BlocProvider.of<ClientBloc>(context) != null);
              if(widget.project != null) {
                BlocProvider.of<ClientBloc>(context).add(EditProject(widget.client, widget.project.id, _nameController.text.trim(), _rateController.numberValue, _isSwitched, widget.project.registrations));
              } else {
                BlocProvider.of<ClientBloc>(context).add(AddProject(widget.client, _nameController.text.trim(), _rateController.numberValue, _isSwitched));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Project",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: TextFormField(
                  controller: _nameController,
                  validator: (String value) =>
                      value.trim().isEmpty ? "Vul een naam in" : null,
                  decoration: InputDecoration(hintText: "Project naam"),
                ),
              ),
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                validator: (String value) =>
                    value.trim().isEmpty ? "Vul een rate in" : null,
                decoration: InputDecoration(hintText: "Uurloon"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Factureerbaar"),
                    Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

