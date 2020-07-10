import 'package:eventtracker/service/database.dart';
import 'package:eventtracker/themes.dart';
import 'package:eventtracker/ui/HomeOverview.dart';
import 'package:eventtracker/ui/dashboard/DashboardOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'bloc/ClientBloc.dart';
import 'bloc/RegistrationBloc.dart';
import 'model/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService data = await DatabaseService.open();

//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);

  initializeDateFormatting().then((_) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(data),
          ),
          BlocProvider<RegistrationBloc>(
            create: (context) => RegistrationBloc(data, BlocProvider.of<ClientBloc>(context)),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(data, BlocProvider.of<RegistrationBloc>(context)),
          ),
        ],
//        child: DevicePreview(
//          enabled: !kReleaseMode,
//          builder: (context) => TimeApp(),
//        ),
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
    BlocProvider.of<DashboardBloc>(context).add(HoursUpdated(DatePeriod(DateTime.now().subtract(Duration(days: 4)), DateTime.now().add(Duration(days: 4)))));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//          locale: DevicePreview.of(context).locale,
//           <--- Add the locale
//          builder: DevicePreview.appBuilder,
        // <--- Add the builder
        title: 'Pyre',
        theme: lightTheme,
//          home: AuthenticationWrapper()),
        home: MyHomePage());
  }
}


