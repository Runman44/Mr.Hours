import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ClientEditor extends StatefulWidget {
  final Client client;

  ClientEditor({Key key, @required this.client}) : super(key: key);

  @override
  _ClientEditorState createState() => _ClientEditorState();
}

class _ClientEditorState extends State<ClientEditor> {
  TextEditingController _nameController;
  Color _colour;
  FocusNode _focus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _colour = widget.client?.color ?? Colors.grey[50];
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(230.0),
        child: AppBar(
          title: Text(
            "Opdrachtgever wijzigen",
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  _colour,
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bullet(
                    color: _colour,
                    mini: true,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (String value) =>
                      value
                          .trim()
                          .isEmpty ? "Vul een naam in" : null,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      decoration: InputDecoration(),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                bool valid = _formKey.currentState.validate();
                if (!valid) return;
                BlocProvider.of<ClientBloc>(context).add(
                  EditClient(widget.client.id, _nameController.text.trim(),
                      _colour, widget.client.projects),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
             child: Center(
               child: MaterialColorPicker(
                  physics: const NeverScrollableScrollPhysics(),
                  selectedColor: _colour,
                  shrinkWrap: true,
                  onColorChange: (Color color) {
                    setState(() {
                      _colour = color;
                    });
                  },
                ),
             ),
          ),
        ),
      ),
    );
  }
}
