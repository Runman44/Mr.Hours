import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ClientCreator extends StatefulWidget {
  @override
  _ClientCreatorState createState() => _ClientCreatorState();
}

class _ClientCreatorState extends State<ClientCreator> {
  TextEditingController _nameController = new TextEditingController();
  Color _colour;
  FocusNode _focus;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameProjectController = new TextEditingController();
  MoneyMaskedTextController _rateController = new MoneyMaskedTextController();
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _colour = Colors.green[500];
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focus.dispose();
    _nameProjectController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Opdrachtgever toevoegen"),
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
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              bool valid = _formKey.currentState.validate();
              if (!valid) return;

              BlocProvider.of<ClientBloc>(context).add(CreateClient(
                  _nameController.text.trim(),
                  _colour,
                  _nameProjectController.text.trim(),
                  _rateController.numberValue,
                  _isSwitched));
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
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "Vul een naam in",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _nameController,
                validator: (String value) =>
                    value.trim().isEmpty ? "Vul een naam in" : null,
                decoration: InputDecoration(hintText: "Client naam"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                child: Text(
                  "Kies een kleur",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialColorPicker(
                physics: const NeverScrollableScrollPhysics(),
                selectedColor: _colour,
                shrinkWrap: true,
                onColorChange: (Color color) => _colour = color,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "Project",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: TextFormField(
                  controller: _nameProjectController,
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
