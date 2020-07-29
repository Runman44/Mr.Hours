import 'dart:io';

import 'package:eventtracker/bloc/settings_bloc.dart';
import 'package:eventtracker/ui/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);

    void _selectImage(File savedImage) {
      settingsBloc.add(ChangeLogo(savedImage));
    }

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageInput(logo: state.settings.logo, onSelectImage: _selectImage,),
          ),
          Divider(),
          SwitchListTile(
            title: Text("Dark-mode"),
            value: state.settings.darkMode,
            subtitle: Text("It's better for your eye's"),
            onChanged: (newValue) {
                settingsBloc.add(ToggleDarkMode(newValue));
            },
          ),
        ],
      );
    });
  }
}
