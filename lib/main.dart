import 'package:eventtracker/service/database.dart';
import 'package:eventtracker/themes.dart';
import 'package:eventtracker/ui/screens/home_screen.dart';
import 'package:eventtracker/bloc/DashboardBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'bloc/ClientBloc.dart';
import 'bloc/RegistrationBloc.dart';
import 'bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService data = await DatabaseService.open();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initializeDateFormatting().then((_) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(data),
          ),
          BlocProvider<RegistrationBloc>(
            create: (_) => RegistrationBloc(data),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(data, BlocProvider.of<ClientBloc>(context)),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(data),
          ),
        ],
    child: TimeApp(),
      )));
}

class TimeApp extends StatefulWidget {
  @override
  _TimeAppState createState() => _TimeAppState();
}

class _TimeAppState extends State<TimeApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClientBloc>(context).add(LoadClients());
    BlocProvider.of<SettingsBloc>(context).add(LoadToggles());
    BlocProvider.of<DashboardBloc>(context).add(HoursUpdated(DatePeriod(DateTime.now().subtract(Duration(days: 4)), DateTime.now().add(Duration(days: 4)))));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return MaterialApp(
          title: 'Pyre',
          theme: state.settings.darkMode ? darkTheme(context) : lightTheme(context),
          home: MyHomePage()
      );
    });
  }
}


