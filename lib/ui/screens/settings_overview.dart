import 'package:eventtracker/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _darkMode = false;

  @override
  Widget build(BuildContext context) {
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return ListView(
      children: [

        SwitchListTile(
          title: Text("Dark-mode"),
          value: _darkMode,
          subtitle: Text("It's better for your eye's"),
          onChanged: (newValue) {
            setState(() {
              _darkMode = newValue;
              settingsBloc.add(ToggleDarkMode(_darkMode));
            });
          },
        ),

      ],
    );
  }
}
