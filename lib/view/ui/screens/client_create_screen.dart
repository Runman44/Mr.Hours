import 'package:easy_localization/easy_localization.dart';
import 'package:eventtracker/view/bloc/ClientBloc.dart';
import 'package:eventtracker/view/ui/widgets/Bullet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
//  MoneyMaskedTextController _rateController = new MoneyMaskedTextController();
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
//    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(230.0),
          child: AppBar(
            title: Text(
              "add_client".tr(),
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
                            value.trim().isEmpty ? "add_name".tr() : null,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "customer".tr(),
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    ),
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
                      0,
                      _isSwitched));
                  //TODO using named routing we could open the detail screen directly
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MaterialColorPicker(
                    physics: const NeverScrollableScrollPhysics(),
                    selectedColor: _colour,
                    shrinkWrap: true,
                    onColorChange: (Color color) {
                      setState(() {
                        _colour = color;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(
                    "project".tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: TextFormField(
                    controller: _nameProjectController,
                    validator: (String value) =>
                        value.trim().isEmpty ? "add_name".tr() : null,
                    decoration: InputDecoration(hintText: "project_name".tr()),
                  ),
                ),
//                TextFormField(
//                  controller: _rateController,
//                  keyboardType: TextInputType.number,
//                  validator: (String value) =>
//                      value.trim().isEmpty ? "add_rate".tr() : null,
//                  decoration: InputDecoration(hintText: "hour_rate".tr()),
//                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("invoiceable".tr()),
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
      ),
    );
  }
}
