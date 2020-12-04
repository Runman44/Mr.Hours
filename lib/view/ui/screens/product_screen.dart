
import 'package:eventtracker/view/bloc/ClientBloc.dart';
import 'package:eventtracker/view/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectEditor extends StatefulWidget {
  final Project project;
  final Client client;

  ProjectEditor({Key key, @required this.project, @required this.client})
      : super(key: key);

  @override
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
//  MoneyMaskedTextController _rateController;
  bool _isSwitched = false;
  final _projectFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
//    _rateController = MoneyMaskedTextController(
//        decimalSeparator: ',',
//        thousandSeparator: '.',
//        initialValue: widget.project?.centsToDouble() ?? 0.0);
    _isSwitched = widget.project?.billable ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
//    _rateController.dispose();
    _projectFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("project".tr(), style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.normal),),
              Spacer(flex: 1,),
              Visibility(
                visible: widget.project != null,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white,),
                  onPressed: () async {
                    BlocProvider.of<ClientBloc>(context).add(
                      DeleteProject(widget.client, widget.project.id),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.check, color: Colors.white,),
                onPressed: () async {
                  bool valid = _formKey.currentState.validate();
                  if (!valid) return;

                  assert(BlocProvider.of<ClientBloc>(context) != null);
                  if (widget.project != null) {
                    BlocProvider.of<ClientBloc>(context).add(EditProject(
                        widget.client,
                        widget.project.id,
                        _nameController.text.trim(),
                        0,
                        _isSwitched,
                        widget.project.registrations));
                  } else {
                    BlocProvider.of<ClientBloc>(context).add(AddProject(
                        widget.client,
                        _nameController.text.trim(),
                        0,
                        _isSwitched));
                  }
                  Navigator.of(context).pop();
                },
              ),

            ],),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: _nameController,
                      validator: (String value) =>
                          value.trim().isEmpty ? "add_name".tr() : null,
                      decoration: InputDecoration(hintText: "project_name".tr()),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_){
                        FocusScope.of(context).requestFocus(_projectFocusNode);
                      },
                    ),
                  ),
//                  TextFormField(
//                    controller: _rateController,
//                    keyboardType: TextInputType.numberWithOptions(decimal: true),
//                    validator: (String value) =>
//                        value.trim().isEmpty ? "add_rate".tr() : null,
//                    decoration: InputDecoration(hintText: "hour_rate".tr()),
//                    textInputAction: TextInputAction.done,
//                    focusNode: _projectFocusNode,
//                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("invoiceable".tr()),
                        Switch.adaptive(
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
        ],
    );
  }
}
