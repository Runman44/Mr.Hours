import 'package:easy_localization/easy_localization.dart';
import 'package:eventtracker/themes.dart';
import 'package:eventtracker/view/bloc/ClientBloc.dart';
import 'package:eventtracker/view/bloc/DashboardBloc.dart';
import 'package:eventtracker/view/bloc/RegistrationBloc.dart';
import 'package:eventtracker/view/bloc/pdf_bloc.dart';
import 'package:eventtracker/view/bloc/settings_bloc.dart';
import 'package:eventtracker/view/service/database.dart';
import 'package:eventtracker/view/ui/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService data = await DatabaseService.open();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('nl')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(data),
          ),
          BlocProvider<RegistrationBloc>(
            create: (_) => RegistrationBloc(data),
          ),
          BlocProvider<PdfBloc>(
            create: (_) => PdfBloc(data),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) =>
                DashboardBloc(data, BlocProvider.of<ClientBloc>(context)),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(data),
          ),
        ],
        child: TimeApp(),
      ),
    ),
  );
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
    BlocProvider.of<DashboardBloc>(context).add(HoursUpdated(DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 4)),
        end: DateTime.now().add(Duration(days: 4)))));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mr.Hours',
          theme: state.settings.darkMode
              ? darkTheme(context)
              : lightTheme(context),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: LoginPage());
    });
  }
}
