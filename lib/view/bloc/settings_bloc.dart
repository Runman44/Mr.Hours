import 'dart:io';
import 'package:eventtracker/view/model/model.dart';
import 'package:eventtracker/view/service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadToggles extends SettingsEvent {
  const LoadToggles();
}

class ChangeLogo extends SettingsEvent {
  final File image;

  const ChangeLogo(this.image);
}

class ToggleDarkMode extends SettingsEvent {
  final bool isDarkMode;

  const ToggleDarkMode(this.isDarkMode);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DatabaseService data;

  SettingsBloc(this.data) : super(SettingsState(Settings(false, null)));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadToggles) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var darkMode = prefs.getBool("dark_mode");
      var logo = prefs.getString("logo");
      var settings = state.settings;

      if (darkMode != null) {
        settings.darkMode = darkMode;
      }
      if (logo !=null) {
        settings.logo = File(logo);
      }
      yield SettingsState(settings);

    } else if (event is ToggleDarkMode) {
      var settings = state.settings;
      settings.darkMode = event.isDarkMode;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("dark_mode", event.isDarkMode);

      yield SettingsState(settings);
    } else if (event is ChangeLogo) {
      var settings = state.settings;
      settings.logo = event.image;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("logo", event.image.path);

      yield SettingsState(settings);
    }
  }
}

class SettingsState {
  final Settings settings;

  const SettingsState(this.settings);
}
