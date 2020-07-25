import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ClientBloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class ToggleDarkMode extends SettingsEvent {
  final bool isDarkMode;

  const ToggleDarkMode(this.isDarkMode);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DatabaseService data;

  SettingsBloc(this.data);

  @override
  SettingsState get initialState => SettingsState(false);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
   if (event is ToggleDarkMode) {
      yield SettingsState(event.isDarkMode);
    }
  }
}

class SettingsState {
  final bool isDarkMode;

  const SettingsState(this.isDarkMode);

}
